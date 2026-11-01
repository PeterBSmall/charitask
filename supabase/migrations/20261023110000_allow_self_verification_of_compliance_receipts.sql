
BEGIN;

-- Allow the staff member who received paperwork to verify it.
-- Receipt verification remains separate from compliance status.

ALTER TABLE public.person_compliance_receipt_submissions
    DROP CONSTRAINT IF EXISTS person_compliance_receipt_review_state_check;

ALTER TABLE public.person_compliance_receipt_submissions
    ADD CONSTRAINT person_compliance_receipt_review_state_check
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
        )
    );

-- Replace the existing review function, retaining permission checks
-- and the requirement that only pending receipts can be reviewed.
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
BEGIN
    IF p_decision IS NULL OR p_decision NOT IN ('approved', 'rejected') THEN
        RAISE EXCEPTION 'Decision must be approved or rejected.';
    END IF;

    IF p_review_notes IS NOT NULL AND length(p_review_notes) > 1000 THEN
        RAISE EXCEPTION 'Review notes cannot exceed 1000 characters.';
    END IF;

    SELECT pai.person_id
    INTO v_reviewer_person_id
    FROM public.person_auth_identities pai
    WHERE pai.auth_user_id = auth.uid();

    IF v_reviewer_person_id IS NULL THEN
        RAISE EXCEPTION 'Signed-in account is not linked to a ChariTask person.';
    END IF;

    SELECT r.organization_id
    INTO v_organization_id
    FROM public.person_compliance_receipt_submissions r
    WHERE r.id = p_receipt_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Receipt not found or unavailable.';
    END IF;

    IF NOT public.has_organization_permission(
        v_reviewer_person_id,
        v_organization_id,
        'compliance.receipts.review'
    ) THEN
        RAISE EXCEPTION 'You do not have permission to review compliance receipts.';
    END IF;

    -- Lock the pending receipt so concurrent reviews cannot overwrite one another.
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
        review_notes = NULLIF(btrim(p_review_notes), ''),
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

COMMIT;
