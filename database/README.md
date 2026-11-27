# BlueSky Database

## Database Engine

- PostgreSQL
- Database schema is maintained through version-controlled SQL migrations.

## Migration Structure

All migrations are stored in `database/migrations/`.

Naming convention:

`NNN_description.sql`

Current migrations:

- `001_identity_and_building_foundation.sql`
- `002_building_name_validation.sql`

Migrations are applied in ascending numerical order.

## Migration Rules

1. Migrations execute in ascending numerical order.
2. An applied migration must never be modified.
3. Schema changes require a new migration.
4. Every migration must be reviewed before execution.
5. Destructive operations require explicit justification.
6. Database constraints must enforce critical business invariants.
7. All timestamps representing absolute points in time use `TIMESTAMPTZ`.
8. Primary keys use UUID unless a documented exception exists.

## Testing

Migrations must be tested against PostgreSQL before being considered validated.

A migration is not considered successful merely because its SQL file was created.

## Rollback

Rollback procedures must be documented for migrations that introduce changes requiring recovery.

Production rollback must not destroy business records or historical data.

## Current Database Baseline

The current MVP1 database foundation includes the following tables:

1. `users`
2. `physical_addresses`
3. `buildings`
4. `building_entrances`
5. `building_admin_assignments`
6. `floors`
7. `apartments`

### Verified Schema Properties

The current database has been inspected and the following properties verified:

- UUID primary keys with `gen_random_uuid()` defaults.
- Foreign-key relationships with `ON DELETE RESTRICT`.
- Case-insensitive unique user email addresses.
- Unique building plate numbers within the same physical address.
- Check constraints for required text fields.
- Exclusion constraint preventing overlapping administrator assignments for the same building.
- `TIMESTAMPTZ` for absolute timestamps.
- Expected indexes for primary keys, foreign-key lookups, and uniqueness rules.
- Building names are mandatory and cannot be empty or whitespace-only.

### Verification Limitations

- Migration history records were inserted manually during database reconciliation. They do not independently prove successful execution of each migration.
- Valid IANA timezone values are not currently enforced by a database constraint.
- The exclusion constraint prevents overlapping administrator assignments but does not guarantee continuous administrator coverage for every building.
- The database has not yet completed a full automated migration-from-empty-database test.

The schema baseline is structurally verified, subject to the limitations above.