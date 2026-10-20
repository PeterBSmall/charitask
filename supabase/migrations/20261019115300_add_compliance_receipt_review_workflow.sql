-- ChariTask: Compliance receipt and independent review workflow.
-- Receipt alone never establishes compliance.
-- Existing compliance records are not modified by this migration.

BEGIN;

-- 1. Permissions
INSERT INTO public.permissions (key, name, description, module)
VALUES
    (
        'compliance.receipts.view',
        'View Compliance Receipts',
        'View paperwork receipt submissions and their review status.',
        'compliance'
    ),
    (
        'compliance.receipts.receive',
        'Record Compliance Receipt',
        'Record paperwork received at an organizational location.',
        'compliance'
    ),
    (
        'compliance.receipts.review',
        'Review Compliance Receipt',
        'Approve or reject paperwork receipts submitted by another person.',
        'compliance'
    )
ON CONFLICT (key) DO NOTHING;

-- 2. Receipt submissions
CREATE TABLE public.person_compliance_receipt_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    person_id UUID NOT NULL,
    compliance_requirement_id UUID NOT NULL,
    receiving_location_id UUID NOT NULL,

    received_by_person_id UUID NOT NULL,
    received_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Administrative receipt information only.
    -- Do not store background-check reports, diagnoses, or clinical notes.
    receipt_notes TEXT CHECK (receipt_notes IS NULL OR length(receipt_notes) <= 1000),

status TEXT NOT NULL DEFAULT 'pending_review'
        CHECK (
            status IN (
                'pending_review',
                'approved',
                'rejected'
            )
        ),

    reviewed_by_person_id UUID,
    reviewed_at TIMESTAMPTZ,
    review_notes TEXT CHECK (review_notes IS NULL OR length(review_notes) <= 1000),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT person_compliance_receipt_person_fkey
        FOREIGN KEY (organization_id, person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT person_compliance_receipt_requirement_fkey
        FOREIGN KEY (organization_id, compliance_requirement_id)
        REFERENCES public.compliance_requirements (organization_id, id),

    CONSTRAINT person_compliance_receipt_location_fkey
        FOREIGN KEY (organization_id, receiving_location_id)
        REFERENCES public.locations (organization_id, id),

    CONSTRAINT person_compliance_receipt_receiver_fkey
        FOREIGN KEY (organization_id, received_by_person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT person_compliance_receipt_reviewer_fkey
        FOREIGN KEY (organization_id, reviewed_by_person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT person_compliance_receipt_review_state_check
        CHECK (
            (
                status = 'pending_review'
                AND reviewed_by_person_id IS NULL
                AND reviewed_at IS NULL
            )
            OR
            (
                status IN ('approved', 'rejected')
                AND reviewed_by_person_id IS NOT NULL
                AND reviewed_at IS NOT NULL
                AND reviewed_by_person_id <> received_by_person_id
            )
        )
);

CREATE INDEX person_compliance_receipt_org_status_idx
    ON public.person_compliance_receipt_submissions
       (organization_id, status, received_at DESC);

CREATE INDEX person_compliance_receipt_person_idx
    ON public.person_compliance_receipt_submissions
       (organization_id, person_id, compliance_requirement_id);

CREATE INDEX person_compliance_receipt_location_idx
    ON public.person_compliance_receipt_submissions
       (organization_id, receiving_location_id, received_at DESC);

-- 3. Row-level security
ALTER TABLE public.person_compliance_receipt_submissions
    ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public.person_compliance_receipt_submissions FROM anon;

GRANT SELECT
    ON public.person_compliance_receipt_submissions
    TO authenticated;

-- Do not allow clients to directly insert, update, or delete receipt rows.
-- Writes will be performed through permission-checked database functions.
REVOKE INSERT, UPDATE, DELETE
    ON public.person_compliance_receipt_submissions
    FROM authenticated;

CREATE POLICY person_compliance_receipt_select_policy
ON public.person_compliance_receipt_submissions
FOR SELECT
TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'compliance.receipts.view'
    )
    OR public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'compliance.receipts.review'
    )
);

-- 4. Record a receipt using the signed-in person's identity.
CREATE OR REPLACE FUNCTION public.submit_person_compliance_receipt(
    p_organization_id UUID,
    p_person_id UUID,
    p_compliance_requirement_id UUID,
    p_receiving_location_id UUID,
    p_receipt_notes TEXT DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $function$
DECLARE
    v_receiver_person_id UUID;
    v_receipt_id UUID;
BEGIN
    SELECT pai.person_id
    INTO v_receiver_person_id
    FROM public.person_auth_identities pai
    WHERE pai.auth_user_id = auth.uid();

    IF v_receiver_person_id IS NULL THEN
        RAISE EXCEPTION 'Signed-in account is not linked to a ChariTask person.';
    END IF;

    IF NOT public.has_organization_permission(
        v_receiver_person_id,
        p_organization_id,
        'compliance.receipts.receive'
    ) THEN
        RAISE EXCEPTION 'You do not have permission to record compliance receipts.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM public.locations l
        WHERE l.organization_id = p_organization_id
          AND l.id = p_receiving_location_id
          AND l.status = 'active'
          AND l.archived_at IS NULL
    ) THEN
        RAISE EXCEPTION 'Receiving location is not active in this organization.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM public.compliance_requirements cr
        WHERE cr.organization_id = p_organization_id
          AND cr.id = p_compliance_requirement_id
          AND cr.is_active = TRUE
    ) THEN
        RAISE EXCEPTION 'Compliance requirement is not active in this organization.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM public.persons p
        WHERE p.organization_id = p_organization_id
          AND p.id = p_person_id
          AND p.archived_at IS NULL
    ) THEN
        RAISE EXCEPTION 'Person is not active in this organization.';
    END IF;

    INSERT INTO public.person_compliance_receipt_submissions (
        organization_id,
        person_id,
        compliance_requirement_id,
        receiving_location_id,
        received_by_person_id,
        receipt_notes
    )
    VALUES (
        p_organization_id,
        p_person_id,
        p_compliance_requirement_id,
        p_receiving_location_id,
        v_receiver_person_id,
        p_receipt_notes
    )
    RETURNING id INTO v_receipt_id;

    RETURN v_receipt_id;
END;
$function$;

REVOKE ALL ON FUNCTION public.submit_person_compliance_receipt(
    UUID, UUID, UUID, UUID, TEXT
) FROM PUBLIC;

REVOKE ALL ON FUNCTION public.submit_person_compliance_receipt(
    UUID, UUID, UUID, UUID, TEXT
) FROM anon;

GRANT EXECUTE ON FUNCTION public.submit_person_compliance_receipt(
    UUID, UUID, UUID, UUID, TEXT
) TO authenticated;

-- 5. Independently review a receipt.
-- This records a receipt decision only; it does not mark compliance satisfied.
CREATE OR REPLACE FUNCTION public.review_person_compliance_receipt(
    p_receipt_id UUID,
    p_decision TEXT,
    p_review_notes TEXT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $function$
DECLARE
    v_reviewer_person_id UUID;
    v_organization_id UUID;
    v_receiver_person_id UUID;
BEGIN
    IF p_decision IS NULL OR p_decision NOT IN ('approved', 'rejected') THEN
        RAISE EXCEPTION 'Decision must be approved or rejected.';
    END IF;

    SELECT pai.person_id
    INTO v_reviewer_person_id
    FROM public.person_auth_identities pai
    WHERE pai.auth_user_id = auth.uid();

    IF v_reviewer_person_id IS NULL THEN
        RAISE EXCEPTION 'Signed-in account is not linked to a ChariTask person.';
    END IF;

    -- Look up the receipt without revealing its current status.
    SELECT r.organization_id, r.received_by_person_id
    INTO v_organization_id, v_receiver_person_id
    FROM public.person_compliance_receipt_submissions r
    WHERE r.id = p_receipt_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Receipt not found or unavailable.';
    END IF;

    -- Check permission before disclosing the receipt's review state.
    IF NOT public.has_organization_permission(
        v_reviewer_person_id,
        v_organization_id,
        'compliance.receipts.review'
    ) THEN
        RAISE EXCEPTION 'You do not have permission to review compliance receipts.';
    END IF;

    IF v_reviewer_person_id = v_receiver_person_id THEN
        RAISE EXCEPTION 'You cannot review a receipt that you submitted.';
    END IF;

    -- Lock the receipt and re-check its state to prevent concurrent reviews.
    PERFORM 1
    FROM public.person_compliance_receipt_submissions r
    WHERE r.id = p_receipt_id
      AND r.status = 'pending_review'
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Receipt not found or is no longer awaiting review.';
    END IF;

    UPDATE public.person_compliance_receipt_submissions
    SET status = p_decision,
        reviewed_by_person_id = v_reviewer_person_id,
        reviewed_at = NOW(),
        review_notes = p_review_notes,
        updated_at = NOW()
    WHERE id = p_receipt_id
      AND status = 'pending_review';
END;
$function$;

REVOKE ALL ON FUNCTION public.review_person_compliance_receipt(
    UUID, TEXT, TEXT
) FROM PUBLIC;

REVOKE ALL ON FUNCTION public.review_person_compliance_receipt(
    UUID, TEXT, TEXT
) FROM anon;

GRANT EXECUTE ON FUNCTION public.review_person_compliance_receipt(
    UUID, TEXT, TEXT
) TO authenticated;


-- 6. Grant receipt permissions to existing System Administrators.
INSERT INTO public.functional_role_permissions (
    organization_id,
    functional_role_id,
    permission_id
)
SELECT fr.organization_id, fr.id, p.id
FROM public.functional_roles fr
JOIN public.permissions p
    ON p.key IN (
        'compliance.receipts.view',
        'compliance.receipts.receive',
        'compliance.receipts.review'
    )
LEFT JOIN public.functional_role_catalog_roles rcr
    ON rcr.id = fr.catalog_role_id
WHERE fr.status = 'active'
  AND (
      fr.slug = 'system-administrator'
      OR fr.name = 'System Administrator'
      OR rcr.slug = 'system-administrator'
  )
ON CONFLICT (organization_id, functional_role_id, permission_id)
DO NOTHING;

-- 7. Grant receipt permissions to future System Administrator assignments.
CREATE OR REPLACE FUNCTION
public.grant_system_admin_compliance_receipt_permissions()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
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
            organization_id,
            functional_role_id,
            permission_id
        )
        SELECT NEW.organization_id, NEW.functional_role_id, p.id
        FROM public.permissions p
        WHERE p.key IN (
            'compliance.receipts.view',
            'compliance.receipts.receive',
            'compliance.receipts.review'
        )
        ON CONFLICT (
            organization_id,
            functional_role_id,
            permission_id
        ) DO NOTHING;
    END IF;

    RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS
grant_system_admin_compliance_receipt_permissions_trigger
ON public.functional_role_assignments;

CREATE TRIGGER
grant_system_admin_compliance_receipt_permissions_trigger
AFTER INSERT OR UPDATE OF status, functional_role_id
ON public.functional_role_assignments
FOR EACH ROW
EXECUTE FUNCTION
public.grant_system_admin_compliance_receipt_permissions();
COMMIT;
