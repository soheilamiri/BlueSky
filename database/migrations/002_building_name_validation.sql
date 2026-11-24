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

-- Reject empty or whitespace-only names.
ALTER TABLE buildings
ADD CONSTRAINT ck_buildings_name
CHECK (length(btrim(name)) > 0);

COMMIT;
