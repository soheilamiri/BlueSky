BEGIN;

-- Backfill existing buildings that have NULL or blank names.
UPDATE buildings
SET name = 'Building-' || upper(substr(
    replace(gen_random_uuid()::text, '-', ''),
    1,
    6
))
WHERE name IS NULL
   OR length(btrim(name)) = 0;

-- Make the building name mandatory.
ALTER TABLE buildings
ALTER COLUMN name SET NOT NULL;

-- Add the validation constraint only if it is not already present.
-- Migration 001 may already have created it in a fresh installation.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ck_buildings_name'
          AND conrelid = 'public.buildings'::regclass
    ) THEN
        ALTER TABLE public.buildings
        ADD CONSTRAINT ck_buildings_name
        CHECK (length(btrim(name)) > 0);
    END IF;
END
$$;

COMMIT;
