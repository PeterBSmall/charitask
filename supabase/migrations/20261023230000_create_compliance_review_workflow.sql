
-- ChariTask: Compliance Review Workflow
-- Adds review assignments, checklist items, decisions, and audit history.
-- Existing credential records and private document storage are preserved.

BEGIN;

-- ============================================================
-- 1. REVIEW PERMISSIONS
-- ============================================================

INSERT INTO public.permissions (key, name, description, module)
VALUES
(
    'compliance.reviews.view',
    'View Compliance Reviews',
    'View compliance review records and their status.',
    'people'
),
(
    'compliance.reviews.manage',
    'Manage Compliance Reviews',
    'Assign reviewers and manage review checklists.',
    'people'
),
(
    'compliance.reviews.decide',
    'Decide Compliance Reviews',
    'Submit compliance review decisions.',
    'people'
),
(
    'compliance.reviews.audit.view',
    'View Compliance Review Audit',
    'View compliance review decision and audit history.',
    'people'
)
ON CONFLICT (key) DO NOTHING;

-- ============================================================
-- 2. REVIEW RECORDS
-- One current workflow record per credential.
-- Decisions and audit events are stored separately.
-- ============================================================

CREATE TABLE public.person_credential_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    person_id UUID NOT NULL,
    credential_id UUID NOT NULL,

    status TEXT NOT NULL DEFAULT 'pending',
    priority TEXT NOT NULL DEFAULT 'normal',

    assigned_reviewer_person_id UUID,
    assigned_at TIMESTAMPTZ,
    submitted_at TIMESTAMPTZ,
    decided_at TIMESTAMPTZ,
    due_at TIMESTAMPTZ,

    created_by_person_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT person_credential_reviews_status_check
        CHECK (
            status IN (
                'pending',
                'in_review',
                'needs_update',
                'approved',
                'rejected',
                'closed'
            )
        ),

    CONSTRAINT person_credential_reviews_priority_check
        CHECK (priority IN ('low', 'normal', 'high', 'urgent')),

    CONSTRAINT person_credential_reviews_credential_fkey
        FOREIGN KEY (organization_id, person_id, credential_id)
        REFERENCES public.person_credentials (
            organization_id, person_id, id
        ),

    CONSTRAINT person_credential_reviews_reviewer_fkey
        FOREIGN KEY (organization_id, assigned_reviewer_person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT person_credential_reviews_creator_fkey
        FOREIGN KEY (organization_id, created_by_person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT person_credential_reviews_credential_key
        UNIQUE (organization_id, person_id, credential_id),

    CONSTRAINT person_credential_reviews_org_id_key
        UNIQUE (organization_id, id)
);

CREATE INDEX person_credential_reviews_queue_idx
    ON public.person_credential_reviews (
        organization_id, status, priority, due_at
    );

CREATE INDEX person_credential_reviews_reviewer_idx
    ON public.person_credential_reviews (
        organization_id, assigned_reviewer_person_id, status
    );

-- ============================================================
-- 3. CHECKLIST ITEMS
-- Both system checks and reviewer checks are supported.
-- ============================================================

CREATE TABLE public.person_credential_review_checklist_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    review_id UUID NOT NULL,

    item_key TEXT NOT NULL,
    label TEXT NOT NULL,
    item_type TEXT NOT NULL,
    is_required BOOLEAN NOT NULL DEFAULT TRUE,
    is_complete BOOLEAN NOT NULL DEFAULT FALSE,

    result TEXT,
    completed_by_person_id UUID,
    completed_at TIMESTAMPTZ,
    sort_order INTEGER NOT NULL DEFAULT 0,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),



    CONSTRAINT credential_review_checklist_type_check
        CHECK (item_type IN ('system', 'reviewer')),

    CONSTRAINT credential_review_checklist_result_check
        CHECK (
            result IS NULL OR
            result IN ('pass', 'fail', 'not_applicable')
        ),

    CONSTRAINT credential_review_checklist_label_check
        CHECK (length(trim(label)) > 0),

    CONSTRAINT credential_review_checklist_review_fkey
        FOREIGN KEY (organization_id, review_id)
        REFERENCES public.person_credential_reviews (
            organization_id, id
        ),

    CONSTRAINT credential_review_checklist_completer_fkey
        FOREIGN KEY (organization_id, completed_by_person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT credential_review_checklist_item_key
        UNIQUE (review_id, item_key)
);

CREATE INDEX person_credential_review_checklist_review_idx
    ON public.person_credential_review_checklist_items (
        organization_id, review_id, sort_order
    );

-- ============================================================
-- 4. APPEND-ONLY DECISIONS
-- A new row is added for every submitted decision.
-- ============================================================

CREATE TABLE public.person_credential_review_decisions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    review_id UUID NOT NULL,
   
    decided_by_person_id UUID NOT NULL,

    decision TEXT NOT NULL,
    comments TEXT,
    rejection_reason TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT credential_review_decision_check
        CHECK (
            decision IN ('approve', 'request_update', 'reject')
        ),

    CONSTRAINT credential_review_decision_reason_check
        CHECK (
            decision = 'approve'
            OR length(trim(COALESCE(rejection_reason, ''))) > 0
        ),

    CONSTRAINT credential_review_decision_review_fkey
        FOREIGN KEY (organization_id, review_id)
        REFERENCES public.person_credential_reviews (
            organization_id, id
        ),



    CONSTRAINT credential_review_decision_person_fkey
        FOREIGN KEY (organization_id, decided_by_person_id)
        REFERENCES public.persons (organization_id, id)
);

CREATE INDEX person_credential_review_decisions_history_idx
    ON public.person_credential_review_decisions (
        organization_id, review_id, created_at DESC
    );

-- ============================================================
-- 5. AUDIT EVENTS
-- No UPDATE or DELETE policies are provided.
-- ============================================================

CREATE TABLE public.person_credential_review_audit_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    review_id UUID NOT NULL,
    actor_person_id UUID,
    event_type TEXT NOT NULL,
    details JSONB NOT NULL DEFAULT '{}'::JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT credential_review_audit_review_fkey
        FOREIGN KEY (organization_id, review_id)
        REFERENCES public.person_credential_reviews (
            organization_id, id
        ),

    CONSTRAINT credential_review_audit_actor_fkey
        FOREIGN KEY (organization_id, actor_person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT credential_review_audit_event_type_check
        CHECK (length(trim(event_type)) > 0)
);

CREATE INDEX person_credential_review_audit_history_idx
    ON public.person_credential_review_audit_events (
        organization_id, review_id, created_at DESC
    );

-- Reject direct updates/deletes to decision and audit history.
CREATE OR REPLACE FUNCTION public.prevent_credential_review_history_mutation()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $function$
BEGIN
    RAISE EXCEPTION 'Compliance review history is append-only.';
END;
$function$;

CREATE TRIGGER credential_review_decisions_immutable
BEFORE UPDATE OR DELETE
ON public.person_credential_review_decisions
FOR EACH ROW
EXECUTE FUNCTION public.prevent_credential_review_history_mutation();

CREATE TRIGGER credential_review_audit_immutable
BEFORE UPDATE OR DELETE
ON public.person_credential_review_audit_events
FOR EACH ROW
EXECUTE FUNCTION public.prevent_credential_review_history_mutation();

-- ============================================================
-- 6. ROW-LEVEL SECURITY
-- Background-check review permissions remain separate.
-- ============================================================

ALTER TABLE public.person_credential_reviews
    ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.person_credential_review_checklist_items
    ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.person_credential_review_decisions
    ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.person_credential_review_audit_events
    ENABLE ROW LEVEL SECURITY;

-- Review access requires both general credential viewing and
-- the dedicated review permission. Background checks additionally
-- require their dedicated permission.

CREATE POLICY credential_reviews_select
ON public.person_credential_reviews
FOR SELECT TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.person_credentials pc
        WHERE pc.organization_id = person_credential_reviews.organization_id
          AND pc.person_id = person_credential_reviews.person_id
          AND pc.id = person_credential_reviews.credential_id
          AND (
              pc.category <> 'background_check'
              OR public.has_organization_permission(
                  (
                      SELECT pai.person_id
                      FROM public.person_auth_identities pai
                      WHERE pai.auth_user_id = auth.uid()
                  ),
                  pc.organization_id,
                  'credentials.background_checks.view'
              )
          )
    )
    AND public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'credentials.view'
    )
    AND public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'compliance.reviews.view'
    )
);

CREATE POLICY credential_reviews_insert
ON public.person_credential_reviews
FOR INSERT TO authenticated
WITH CHECK (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'credentials.manage'
    )
    AND public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'compliance.reviews.manage'
    )
);

CREATE POLICY credential_reviews_update
ON public.person_credential_reviews
FOR UPDATE TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'credentials.manage'
    )
    AND public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'compliance.reviews.manage'
    )
)
WITH CHECK (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'credentials.manage'
    )
    AND public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'compliance.reviews.manage'
    )
);

CREATE POLICY credential_review_checklist_select
ON public.person_credential_review_checklist_items
FOR SELECT TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.person_credential_reviews r
        WHERE r.organization_id = person_credential_review_checklist_items.organization_id
          AND r.id = person_credential_review_checklist_items.review_id
    )
    AND public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'compliance.reviews.view'
    )
);

CREATE POLICY credential_review_checklist_insert
ON public.person_credential_review_checklist_items
FOR INSERT TO authenticated
WITH CHECK (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'compliance.reviews.manage'
    )
);

CREATE POLICY credential_review_checklist_update
ON public.person_credential_review_checklist_items
FOR UPDATE TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'compliance.reviews.manage'
    )
)
WITH CHECK (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'compliance.reviews.manage'
    )
);

CREATE POLICY credential_review_decisions_select
ON public.person_credential_review_decisions
FOR SELECT TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'compliance.reviews.audit.view'
    )
);


CREATE POLICY credential_review_audit_select
ON public.person_credential_review_audit_events
FOR SELECT TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'compliance.reviews.audit.view'
    )
);



-- ============================================================
-- 7. GRANT PERMISSIONS TO EXISTING SYSTEM ADMINISTRATORS
-- ============================================================

INSERT INTO public.functional_role_permissions (
    organization_id, functional_role_id, permission_id
)
SELECT fr.organization_id, fr.id, p.id
FROM public.functional_roles fr
JOIN public.permissions p
    ON p.key IN (
        'compliance.reviews.view',
        'compliance.reviews.manage',
        'compliance.reviews.decide',
        'compliance.reviews.audit.view'
    )
WHERE fr.status = 'active'
  AND (
      fr.slug = 'system-administrator'
      OR fr.name = 'System Administrator'
  )
ON CONFLICT (organization_id, functional_role_id, permission_id)
DO NOTHING;

-- Future active System Administrator assignments receive
-- review permissions. Preserve existing credential provisioning.
CREATE OR REPLACE FUNCTION public.grant_system_admin_credential_permissions()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $function$
BEGIN
    IF NEW.status IS DISTINCT FROM 'active' THEN
        RETURN NEW;
    END IF;

    IF EXISTS (
        SELECT 1
        FROM public.functional_roles fr
        LEFT JOIN public.functional_role_catalog_roles rcr
            ON rcr.id = fr.catalog_role_id
        WHERE fr.organization_id = NEW.organization_id
          AND fr.id = NEW.functional_role_id
          AND fr.status = 'active'
          AND (
              fr.slug = 'system-administrator'
              OR fr.name = 'System Administrator'
              OR rcr.slug = 'system-administrator'
          )
    ) THEN
        INSERT INTO public.functional_role_permissions (
            organization_id, functional_role_id, permission_id
        )
        SELECT NEW.organization_id, NEW.functional_role_id, p.id
        FROM public.permissions p
        WHERE p.key IN (
            'credentials.view',
            'credentials.manage',
            'credentials.background_checks.view',
            'credentials.background_checks.manage',
            'people.personal_details.view',
            'people.personal_details.manage',
            'compliance.reviews.view',
            'compliance.reviews.manage',
            'compliance.reviews.decide',
            'compliance.reviews.audit.view'
        )
        ON CONFLICT (
            organization_id, functional_role_id, permission_id
        ) DO NOTHING;
    END IF;

    RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS
    grant_system_admin_credential_permissions_trigger
ON public.functional_role_assignments;

CREATE TRIGGER grant_system_admin_credential_permissions_trigger
AFTER INSERT OR UPDATE OF status, functional_role_id
ON public.functional_role_assignments
FOR EACH ROW
EXECUTE FUNCTION public.grant_system_admin_credential_permissions();

-- ============================================================
-- 8. HARDEN REVIEW ACCESS AND CONTROL DECISION SUBMISSION
-- ============================================================

-- Remove direct client writes to append-only history.
DROP POLICY IF EXISTS credential_review_decisions_insert
    ON public.person_credential_review_decisions;
DROP POLICY IF EXISTS credential_review_audit_insert
    ON public.person_credential_review_audit_events;

REVOKE INSERT, UPDATE, DELETE
    ON public.person_credential_review_decisions
    FROM PUBLIC, anon, authenticated;

REVOKE INSERT, UPDATE, DELETE
    ON public.person_credential_review_audit_events
    FROM PUBLIC, anon, authenticated;

GRANT SELECT
    ON public.person_credential_review_decisions,
       public.person_credential_review_audit_events
    TO authenticated;


-- Review creation: background checks need the additional
-- background-check management permission.
DROP POLICY IF EXISTS credential_reviews_insert
    ON public.person_credential_reviews;

CREATE POLICY credential_reviews_insert
ON public.person_credential_reviews
FOR INSERT TO authenticated
WITH CHECK (
    public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'credentials.manage'
    )
    AND public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.reviews.manage'
    )
    AND EXISTS (
        SELECT 1
        FROM public.person_credentials pc
        WHERE pc.organization_id =
              person_credential_reviews.organization_id
          AND pc.person_id = person_credential_reviews.person_id
          AND pc.id = person_credential_reviews.credential_id
          AND (
              pc.category <> 'background_check'
              OR public.has_organization_permission(
                  (SELECT pai.person_id
                   FROM public.person_auth_identities pai
                   WHERE pai.auth_user_id = auth.uid()),
                  pc.organization_id,
                  'credentials.background_checks.manage'
              )
          )
    )
);


-- Review updates: apply the same restriction before and after
-- the update, including if the linked credential is changed.
DROP POLICY IF EXISTS credential_reviews_update
    ON public.person_credential_reviews;

CREATE POLICY credential_reviews_update
ON public.person_credential_reviews
FOR UPDATE TO authenticated
USING (
    public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'credentials.manage'
    )
    AND public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.reviews.manage'
    )
    AND EXISTS (
        SELECT 1
        FROM public.person_credentials pc
        WHERE pc.organization_id =
              person_credential_reviews.organization_id
          AND pc.person_id = person_credential_reviews.person_id
          AND pc.id = person_credential_reviews.credential_id
          AND (
              pc.category <> 'background_check'
              OR public.has_organization_permission(
                  (SELECT pai.person_id
                   FROM public.person_auth_identities pai
                   WHERE pai.auth_user_id = auth.uid()),
                  pc.organization_id,
                  'credentials.background_checks.manage'
              )
          )
    )
)
WITH CHECK (
    public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'credentials.manage'
    )
    AND public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.reviews.manage'
    )
    AND EXISTS (
        SELECT 1
        FROM public.person_credentials pc
        WHERE pc.organization_id =
              person_credential_reviews.organization_id
          AND pc.person_id = person_credential_reviews.person_id
          AND pc.id = person_credential_reviews.credential_id
          AND (
              pc.category <> 'background_check'
              OR public.has_organization_permission(
                  (SELECT pai.person_id
                   FROM public.person_auth_identities pai
                   WHERE pai.auth_user_id = auth.uid()),
                  pc.organization_id,
                  'credentials.background_checks.manage'
              )
          )
    )
);


-- Checklist reads must be authorized against the linked credential.
DROP POLICY IF EXISTS credential_review_checklist_select
    ON public.person_credential_review_checklist_items;

CREATE POLICY credential_review_checklist_select
ON public.person_credential_review_checklist_items
FOR SELECT TO authenticated
USING (
    public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'credentials.view'
    )
    AND public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.reviews.view'
    )
    AND EXISTS (
        SELECT 1
        FROM public.person_credential_reviews r
        JOIN public.person_credentials pc
          ON pc.organization_id = r.organization_id
         AND pc.person_id = r.person_id
         AND pc.id = r.credential_id
        WHERE r.organization_id =
              person_credential_review_checklist_items.organization_id
          AND r.id = person_credential_review_checklist_items.review_id
          AND (
              pc.category <> 'background_check'
              OR public.has_organization_permission(
                  (SELECT pai.person_id
                   FROM public.person_auth_identities pai
                   WHERE pai.auth_user_id = auth.uid()),
                  pc.organization_id,
                  'credentials.background_checks.view'
              )
          )
    )
);


-- Checklist writes require credential and review management.
DROP POLICY IF EXISTS credential_review_checklist_insert
    ON public.person_credential_review_checklist_items;
DROP POLICY IF EXISTS credential_review_checklist_update
    ON public.person_credential_review_checklist_items;

CREATE POLICY credential_review_checklist_insert
ON public.person_credential_review_checklist_items
FOR INSERT TO authenticated
WITH CHECK (
    public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'credentials.manage'
    )
    AND public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.reviews.manage'
    )
    AND EXISTS (
        SELECT 1
        FROM public.person_credential_reviews r
        JOIN public.person_credentials pc
          ON pc.organization_id = r.organization_id
         AND pc.person_id = r.person_id
         AND pc.id = r.credential_id
        WHERE r.organization_id =
              person_credential_review_checklist_items.organization_id
          AND r.id = person_credential_review_checklist_items.review_id
          AND (
              pc.category <> 'background_check'
              OR public.has_organization_permission(
                  (SELECT pai.person_id
                   FROM public.person_auth_identities pai
                   WHERE pai.auth_user_id = auth.uid()),
                  pc.organization_id,
                  'credentials.background_checks.manage'
              )
          )
    )
);

CREATE POLICY credential_review_checklist_update
ON public.person_credential_review_checklist_items
FOR UPDATE TO authenticated
USING (
    public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'credentials.manage'
    )
    AND public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.reviews.manage'
    )
    AND EXISTS (
        SELECT 1
        FROM public.person_credential_reviews r
        JOIN public.person_credentials pc
          ON pc.organization_id = r.organization_id
         AND pc.person_id = r.person_id
         AND pc.id = r.credential_id
        WHERE r.organization_id =
              person_credential_review_checklist_items.organization_id
          AND r.id = person_credential_review_checklist_items.review_id
          AND (
              pc.category <> 'background_check'
              OR public.has_organization_permission(
                  (SELECT pai.person_id
                   FROM public.person_auth_identities pai
                   WHERE pai.auth_user_id = auth.uid()),
                  pc.organization_id,
                  'credentials.background_checks.manage'
              )
          )
    )
)
WITH CHECK (
    public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'credentials.manage'
    )
    AND public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.reviews.manage'
    )
    AND EXISTS (
        SELECT 1
        FROM public.person_credential_reviews r
        JOIN public.person_credentials pc
          ON pc.organization_id = r.organization_id
         AND pc.person_id = r.person_id
         AND pc.id = r.credential_id
        WHERE r.organization_id =
              person_credential_review_checklist_items.organization_id
          AND r.id = person_credential_review_checklist_items.review_id
          AND (
              pc.category <> 'background_check'
              OR public.has_organization_permission(
                  (SELECT pai.person_id
                   FROM public.person_auth_identities pai
                   WHERE pai.auth_user_id = auth.uid()),
                  pc.organization_id,
                  'credentials.background_checks.manage'
              )
          )
    )
);


-- Decision and audit history reads require permission to view
-- the underlying credential as well as audit history.
DROP POLICY IF EXISTS credential_review_decisions_select
    ON public.person_credential_review_decisions;
DROP POLICY IF EXISTS credential_review_audit_select
    ON public.person_credential_review_audit_events;

CREATE POLICY credential_review_decisions_select
ON public.person_credential_review_decisions
FOR SELECT TO authenticated
USING (
    public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'credentials.view'
    )
    AND public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.reviews.audit.view'
    )
    AND EXISTS (
        SELECT 1
        FROM public.person_credential_reviews r
        JOIN public.person_credentials pc
          ON pc.organization_id = r.organization_id
         AND pc.person_id = r.person_id
         AND pc.id = r.credential_id
        WHERE r.organization_id =
              person_credential_review_decisions.organization_id
          AND r.id = person_credential_review_decisions.review_id
          AND (
              pc.category <> 'background_check'
              OR public.has_organization_permission(
                  (SELECT pai.person_id
                   FROM public.person_auth_identities pai
                   WHERE pai.auth_user_id = auth.uid()),
                  pc.organization_id,
                  'credentials.background_checks.view'
              )
          )
    )
);

CREATE POLICY credential_review_audit_select
ON public.person_credential_review_audit_events
FOR SELECT TO authenticated
USING (
    public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'credentials.view'
    )
    AND public.has_organization_permission(
        (SELECT pai.person_id
         FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.reviews.audit.view'
    )
    AND EXISTS (
        SELECT 1
        FROM public.person_credential_reviews r
        JOIN public.person_credentials pc
          ON pc.organization_id = r.organization_id
         AND pc.person_id = r.person_id
         AND pc.id = r.credential_id
        WHERE r.organization_id =
              person_credential_review_audit_events.organization_id
          AND r.id = person_credential_review_audit_events.review_id
          AND (
              pc.category <> 'background_check'
              OR public.has_organization_permission(
                  (SELECT pai.person_id
                   FROM public.person_auth_identities pai
                   WHERE pai.auth_user_id = auth.uid()),
                  pc.organization_id,
                  'credentials.background_checks.view'
              )
          )
    )
);


-- Controlled decision submission. The reviewer identity comes
-- from the authenticated session, never from client input.
CREATE OR REPLACE FUNCTION public.submit_person_credential_review_decision(
    p_review_id UUID,
    p_decision TEXT,
    p_comments TEXT DEFAULT NULL,
    p_rejection_reason TEXT DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $function$
DECLARE
    v_reviewer_person_id UUID;
    v_organization_id UUID;
    v_owner_person_id UUID;
    v_credential_id UUID;
    v_category TEXT;
    v_review_status TEXT;
    v_decision_id UUID;
BEGIN
    IF p_decision IS NULL
       OR p_decision NOT IN ('approve', 'request_update', 'reject') THEN
        RAISE EXCEPTION 'Invalid credential review decision.';
    END IF;

    IF p_decision <> 'approve'
       AND length(trim(COALESCE(p_rejection_reason, ''))) = 0 THEN
        RAISE EXCEPTION
            'A reason is required when requesting an update or rejecting.';
    END IF;

    IF length(COALESCE(p_comments, '')) > 1000
       OR length(COALESCE(p_rejection_reason, '')) > 1000 THEN
        RAISE EXCEPTION 'Comments and reasons must not exceed 1000 characters.';
    END IF;

    SELECT pai.person_id
    INTO v_reviewer_person_id
    FROM public.person_auth_identities pai
    WHERE pai.auth_user_id = auth.uid();

    IF v_reviewer_person_id IS NULL THEN
        RAISE EXCEPTION
            'Signed-in account is not linked to a ChariTask person.';
    END IF;

    -- Obtain the organization without disclosing review status.
    SELECT r.organization_id
    INTO v_organization_id
    FROM public.person_credential_reviews r
    WHERE r.id = p_review_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Review not found or unavailable.';
    END IF;

    IF NOT public.has_organization_permission(
        v_reviewer_person_id, v_organization_id,
        'compliance.reviews.decide'
    ) OR NOT public.has_organization_permission(
        v_reviewer_person_id, v_organization_id,
        'credentials.manage'
    ) THEN
        RAISE EXCEPTION 'You do not have permission to decide this review.';
    END IF;

    -- Lock both rows to serialize decisions for the same credential.
    SELECT r.person_id, r.credential_id, r.status, pc.category
    INTO v_owner_person_id, v_credential_id, v_review_status, v_category
    FROM public.person_credential_reviews r
    JOIN public.person_credentials pc
      ON pc.organization_id = r.organization_id
     AND pc.person_id = r.person_id
     AND pc.id = r.credential_id
    WHERE r.id = p_review_id
      AND r.organization_id = v_organization_id
    FOR UPDATE OF r, pc;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Review not found or unavailable.';
    END IF;

    IF v_category = 'background_check'
       AND (
           NOT public.has_organization_permission(
               v_reviewer_person_id, v_organization_id,
               'credentials.background_checks.view'
           )
           OR NOT public.has_organization_permission(
               v_reviewer_person_id, v_organization_id,
               'credentials.background_checks.manage'
           )
       ) THEN
        RAISE EXCEPTION
            'You do not have permission to review background checks.';
    END IF;

    IF v_reviewer_person_id = v_owner_person_id THEN
        RAISE EXCEPTION 'You cannot review your own credential.';
    END IF;

    IF v_review_status NOT IN ('pending', 'in_review', 'needs_update') THEN
        RAISE EXCEPTION 'This review is no longer awaiting a decision.';
    END IF;

    IF p_decision = 'approve' AND EXISTS (
        SELECT 1
        FROM public.person_credential_review_checklist_items ci
        WHERE ci.organization_id = v_organization_id
          AND ci.review_id = p_review_id
          AND ci.is_required
          AND (
              NOT ci.is_complete
              OR ci.result = 'fail'
          )
    ) THEN
        RAISE EXCEPTION
            'Complete all required checklist items before approval.';
    END IF;

    INSERT INTO public.person_credential_review_decisions (
        organization_id,
        review_id,
        decided_by_person_id,
        decision,
        comments,
        rejection_reason
    )
    VALUES (
        v_organization_id,
        p_review_id,
        v_reviewer_person_id,
        p_decision,
        NULLIF(trim(p_comments), ''),
        CASE
            WHEN p_decision = 'approve' THEN NULL
            ELSE NULLIF(trim(p_rejection_reason), '')
        END
    )
    RETURNING id INTO v_decision_id;

    UPDATE public.person_credential_reviews
    SET status = CASE p_decision
            WHEN 'approve' THEN 'approved'
            WHEN 'request_update' THEN 'needs_update'
            WHEN 'reject' THEN 'rejected'
        END,
        updated_at = NOW()
    WHERE id = p_review_id
      AND organization_id = v_organization_id;

    IF p_decision IN ('approve', 'reject') THEN
        UPDATE public.person_credentials
        SET status = CASE
                WHEN v_category = 'background_check'
                     AND p_decision = 'approve' THEN 'cleared'
                WHEN v_category = 'background_check'
                     AND p_decision = 'reject' THEN 'not_cleared'
                WHEN p_decision = 'approve' THEN 'verified'
                ELSE 'rejected'
            END,
            reviewed_at = NOW(),
            reviewed_by_person_id = v_reviewer_person_id,
            updated_at = NOW()
        WHERE organization_id = v_organization_id
          AND person_id = v_owner_person_id
          AND id = v_credential_id;
    END IF;

    INSERT INTO public.person_credential_review_audit_events (
        organization_id,
        review_id,
        actor_person_id,
        event_type,
        details
    )
    VALUES (
        v_organization_id,
        p_review_id,
        v_reviewer_person_id,
        'decision_submitted',
        jsonb_build_object(
            'decision', p_decision,
            'decision_id', v_decision_id
        )
    );

    RETURN v_decision_id;
END;
$function$;

REVOKE ALL ON FUNCTION
    public.submit_person_credential_review_decision(UUID, TEXT, TEXT, TEXT)
    FROM PUBLIC;

REVOKE ALL ON FUNCTION
    public.submit_person_credential_review_decision(UUID, TEXT, TEXT, TEXT)
    FROM anon;


REVOKE EXECUTE ON FUNCTION
    public.submit_person_credential_review_decision(UUID, TEXT, TEXT, TEXT)
    FROM service_role;


GRANT EXECUTE ON FUNCTION
    public.submit_person_credential_review_decision(UUID, TEXT, TEXT, TEXT)
    TO authenticated;


-- Explicitly remove broad/default table privileges.
REVOKE ALL PRIVILEGES ON TABLE
    public.person_credential_reviews,
    public.person_credential_review_checklist_items,
    public.person_credential_review_decisions,
    public.person_credential_review_audit_events
FROM PUBLIC, anon, authenticated, service_role;

-- Review and checklist workflow: authenticated users must
-- still satisfy the existing RLS policies.
GRANT SELECT, INSERT, UPDATE ON TABLE
    public.person_credential_reviews,
    public.person_credential_review_checklist_items
TO authenticated;

-- Decision and audit history are read-only to application roles.
-- The SECURITY DEFINER decision function performs authorized writes.
GRANT SELECT ON TABLE
    public.person_credential_review_decisions,
    public.person_credential_review_audit_events
TO authenticated;

-- Keep service_role read-only on these workflow tables as well.
GRANT SELECT ON TABLE
    public.person_credential_reviews,
    public.person_credential_review_checklist_items,
    public.person_credential_review_decisions,
    public.person_credential_review_audit_events
TO service_role;


COMMIT;
