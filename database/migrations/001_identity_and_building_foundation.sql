-- BlueSky
-- Migration: 001_identity_and_building_foundation
-- Purpose: Establish identity and building foundations.
-- Source of truth: docs/mvp1/erd.md (version 1.1)

BEGIN;

CREATE EXTENSION IF NOT EXISTS btree_gist;

-- =========================================================
-- Identity
-- =========================================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(320) NOT NULL,
    email_verified_at TIMESTAMPTZ,
    status VARCHAR(30) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT ck_users_email
        CHECK (length(btrim(email)) > 0),
    CONSTRAINT ck_users_status
        CHECK (length(btrim(status)) > 0)
);

CREATE UNIQUE INDEX uq_users_email_lower
    ON users (lower(email));

COMMENT ON TABLE users IS
    'Account identity for BlueSky users. Authentication credentials are managed separately.';

-- =========================================================
-- Physical addresses
-- =========================================================

CREATE TABLE physical_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    country_code VARCHAR(2) NOT NULL,
    postal_code VARCHAR(20),
    city VARCHAR(120) NOT NULL,
    region VARCHAR(120),
    street_address VARCHAR(255) NOT NULL,
    address_line_2 VARCHAR(255),

    CONSTRAINT ck_physical_addresses_country_code
        CHECK (country_code ~ '^[A-Z]{2}$'),
    CONSTRAINT ck_physical_addresses_city
        CHECK (length(btrim(city)) > 0),
    CONSTRAINT ck_physical_addresses_street_address
        CHECK (length(btrim(street_address)) > 0)
);

COMMENT ON TABLE physical_addresses IS
    'Physical street addresses. One address may contain multiple buildings.';

-- =========================================================
-- Buildings
-- =========================================================

CREATE TABLE buildings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    physical_address_id UUID NOT NULL,
    building_plate_number VARCHAR(50) NOT NULL,
    name VARCHAR(150) NOT NULL,
    status VARCHAR(30) NOT NULL,
    timezone VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_buildings_physical_address
        FOREIGN KEY (physical_address_id)
        REFERENCES physical_addresses (id)
        ON DELETE RESTRICT,
    CONSTRAINT uq_buildings_address_plate
        UNIQUE (physical_address_id, building_plate_number),
    CONSTRAINT ck_buildings_plate_number
        CHECK (length(btrim(building_plate_number)) > 0),
    CONSTRAINT ck_buildings_name
        CHECK (length(btrim(name)) > 0),
    CONSTRAINT ck_buildings_status
        CHECK (length(btrim(status)) > 0),
    CONSTRAINT ck_buildings_timezone
        CHECK (length(btrim(timezone)) > 0)
);

COMMENT ON TABLE buildings IS
    'Managed residential buildings. Building plate number is unique within a physical address.';

-- =========================================================
-- Building entrances
-- =========================================================

CREATE TABLE building_entrances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL,
    name VARCHAR(120) NOT NULL,
    portal_access_code_secret_reference VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_building_entrances_building
        FOREIGN KEY (building_id)
        REFERENCES buildings (id)
        ON DELETE RESTRICT,
    CONSTRAINT ck_building_entrances_name
        CHECK (length(btrim(name)) > 0)
);

CREATE INDEX ix_building_entrances_building_id
    ON building_entrances (building_id);

COMMENT ON TABLE building_entrances IS
    'Entrances belonging to a building. Secret values are stored outside the database.';

-- =========================================================
-- Building administrator assignment history
-- =========================================================

CREATE TABLE building_admin_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL,
    user_id UUID NOT NULL,
    effective_from TIMESTAMPTZ NOT NULL,
    effective_to TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_building_admin_assignments_building
        FOREIGN KEY (building_id)
        REFERENCES buildings (id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_building_admin_assignments_user
        FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON DELETE RESTRICT,
    CONSTRAINT ck_building_admin_assignments_period
        CHECK (effective_to IS NULL OR effective_to > effective_from),
    CONSTRAINT ex_building_admin_assignments_no_overlap
        EXCLUDE USING gist (
            building_id WITH =,
            tstzrange(effective_from, effective_to, '[)') WITH &&
        )
);

CREATE INDEX ix_building_admin_assignments_user_id
    ON building_admin_assignments (user_id);

COMMENT ON TABLE building_admin_assignments IS
    'Current and historical building administrator assignments.';

-- =========================================================
-- Floors
-- =========================================================

CREATE TABLE floors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL,
    floor_label VARCHAR(50) NOT NULL,

    CONSTRAINT fk_floors_building
        FOREIGN KEY (building_id)
        REFERENCES buildings (id)
        ON DELETE RESTRICT,
    CONSTRAINT ck_floors_floor_label
        CHECK (length(btrim(floor_label)) > 0)
);

CREATE INDEX ix_floors_building_id
    ON floors (building_id);

COMMENT ON TABLE floors IS
    'Floors within a building. Floor-label format is intentionally not constrained.';

-- =========================================================
-- Apartments
-- =========================================================

CREATE TABLE apartments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    floor_id UUID NOT NULL,
    apartment_number VARCHAR(50) NOT NULL,
    status VARCHAR(30) NOT NULL,

    CONSTRAINT fk_apartments_floor
        FOREIGN KEY (floor_id)
        REFERENCES floors (id)
        ON DELETE RESTRICT,
    CONSTRAINT ck_apartments_number
        CHECK (length(btrim(apartment_number)) > 0),
    CONSTRAINT ck_apartments_status
        CHECK (length(btrim(status)) > 0)
);

CREATE INDEX ix_apartments_floor_id
    ON apartments (floor_id);

COMMENT ON TABLE apartments IS
    'Apartments on a floor. Apartment-number format is intentionally not constrained.';

COMMIT;
