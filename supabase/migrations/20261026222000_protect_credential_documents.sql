-- ChariTask: Protect credential document integrity.
-- Prevent background-check attachments at the database level.
-- Preserve the existing private Storage cleanup workflow.

BEGIN;

-- Serialize document insertion against category changes by locking
-- the parent credential row before accepting a document record.
CREATE OR REPLACE FUNCTION
public.prevent_background_check_document_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $function$
DECLARE
    credential_category TEXT;
BEGIN
    SELECT pc.category
      INTO credential_category
      FROM public.person_credentials pc
     WHERE pc.organization_id = NEW.organization_id
       AND pc.person_id = NEW.person_id
       AND pc.id = NEW.credential_id
     FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Credential not found for document'
            USING ERRCODE = '23503';
    END IF;

    IF credential_category = 'background_check' THEN
        RAISE EXCEPTION
            'Supporting documents are not permitted for background checks'
            USING ERRCODE = '23514';
    END IF;

    RETURN NEW;
END;
$function$;


DROP TRIGGER IF EXISTS
    prevent_background_check_document_insert_trigger
ON public.person_credential_documents;

CREATE TRIGGER
    prevent_background_check_document_insert_trigger
BEFORE INSERT
ON public.person_credential_documents
FOR EACH ROW
EXECUTE FUNCTION
    public.prevent_background_check_document_insert();

DROP TRIGGER IF EXISTS
    prevent_background_check_document_update_trigger
ON public.person_credential_documents;

CREATE TRIGGER
    prevent_background_check_document_update_trigger
BEFORE UPDATE OF organization_id, person_id, credential_id
ON public.person_credential_documents
FOR EACH ROW
EXECUTE FUNCTION
    public.prevent_background_check_document_insert();



-- A credential cannot become a background check while documents
-- are attached. The row update lock serializes this check against
-- the document trigger above.
CREATE OR REPLACE FUNCTION
public.prevent_background_check_category_with_documents()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $function$
BEGIN
    IF NEW.category = 'background_check'
       AND OLD.category IS DISTINCT FROM NEW.category
       AND EXISTS (
           SELECT 1
             FROM public.person_credential_documents d
            WHERE d.organization_id = OLD.organization_id
              AND d.person_id = OLD.person_id
              AND d.credential_id = OLD.id
       )
    THEN
        RAISE EXCEPTION
            'Remove supporting documents before changing a credential to background_check'
            USING ERRCODE = '23514';
    END IF;

    RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS
    prevent_background_check_category_with_documents_trigger
ON public.person_credentials;

CREATE TRIGGER
    prevent_background_check_category_with_documents_trigger
BEFORE UPDATE OF category
ON public.person_credentials
FOR EACH ROW
EXECUTE FUNCTION
    public.prevent_background_check_category_with_documents();

COMMIT;