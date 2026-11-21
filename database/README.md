# BlueSky Database

## Database Engine

- PostgreSQL
- Database schema is maintained through version-controlled SQL migrations.

## Migration Structure

All migrations are stored in `database/migrations/`.

Naming convention:

`NNN_description.sql`

Examples:

- `001_identity_and_building_foundation.sql`
- `002_contract_management.sql`
- `003_resident_memberships.sql`

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
