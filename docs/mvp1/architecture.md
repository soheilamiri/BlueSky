
# BlueSky — MVP1 Architecture

**Version:** 1.0  
**Status:** Approved stack; proposed application structure  
**Date:** 2026-11-18

## 1. Architecture goals

MVP1 architecture should be:
- Simple to develop and maintain.
- Secure by default.
- Testable.
- Suitable for a multi-building SaaS application.
- Cost-conscious.
- Capable of gradual Azure adoption.

Avoid premature infrastructure complexity.

## 2. Approved technology stack

| Layer | Technology | Status |
|---|---|---|
| Backend | .NET 10 / ASP.NET Core | Approved |
| Frontend | React + TypeScript | Approved |
| Database | PostgreSQL | Approved |
| Local development | Docker Compose | Approved |

The exact frontend build tooling, Node.js version, authentication provider, hosting provider, and CI/CD platform remain open.

## 3. Proposed architecture style

**Proposed:** Modular monolith.

MVP1 should use one backend application with clearly separated business modules.

Do not introduce microservices or Kubernetes without a demonstrated requirement.

## 4. System context

~~~mermaid
flowchart LR
    PA[Platform Administrator]
    BA[Building Administrator]
    R[Resident]

    WEB[React Web Application]
    API[ASP.NET Core API]
    DB[(PostgreSQL)]
    FILES[(Object Storage)]
    EMAIL[Email Provider]

    PA --> WEB
    BA --> WEB
    R --> WEB

    WEB --> API
    API --> DB
    API --> FILES
    API --> EMAIL
~~~

## 5. Logical backend modules

### Identity and Access
- User accounts.
- Authentication integration.
- Roles and authorization policies.
- Email verification and password reset integration.

### Building Management
- Buildings.
- Floors.
- Apartments.
- Building Administrator assignment.

### Asset Management
- Parking spaces.
- Storage units.
- Asset assignment history.

### Contract Management
- Contract IDs.
- Contract validity and status.
- Apartment association.
- Contract holder association.

### Membership
- Membership requests.
- Contract verification.
- Approval and rejection.
- Membership revocation.

### Maintenance
- Categories.
- Maintenance requests.
- Request locations.
- Priorities and status transitions.
- Duplicate merging.
- Resolution records.

### File Management
- Photo metadata.
- File validation.
- Storage abstraction.
- Upload/download authorization.

### Notifications
- Maintenance-related notifications.
- Email verification notifications.
- Notification delivery tracking.

### Audit
- Administrative action history.
- Membership decisions.
- Contract and asset changes.
- Maintenance workflow changes.

These are logical modules, not separate deployable services.

## 6. Proposed container architecture

~~~mermaid
flowchart TB
    Browser[React + TypeScript]
    subgraph Backend[ASP.NET Core Modular Monolith]
        API[REST API]
        ID[Identity and Access]
        BUILD[Building Management]
        CONTRACT[Contracts and Membership]
        ASSET[Asset Management]
        MAINT[Maintenance]
        FILE[File Management]
        NOTIFY[Notifications]
        AUDIT[Audit]
        API --> ID
        API --> BUILD
        API --> CONTRACT
        API --> ASSET
        API --> MAINT
        API --> FILE
        API --> NOTIFY
        API --> AUDIT
    end
    DB[(PostgreSQL)]
    STORE[(Object Storage)]
    EMAIL[Email Provider]
    Browser --> API
    ID --> DB
    BUILD --> DB
    CONTRACT --> DB
    ASSET --> DB
    MAINT --> DB
    AUDIT --> DB
    FILE --> STORE
    NOTIFY --> EMAIL
~~~

## 7. Database architecture

PostgreSQL stores:
- User and membership records.
- Building and apartment data.
- Contracts and asset assignments.
- Maintenance requests and their histories.
- Attachment metadata.
- Notifications.
- Audit events.

Photo binaries should be stored separately from relational data.

Important database constraints should enforce:
- One active contract per apartment.
- Unique Contract IDs in the appropriate issuer scope.
- Valid foreign-key relationships.
- Building ownership relationships.

Use database transactions for operations that update multiple related records.

## 8. Authentication and authorization

The authentication provider and token/session strategy are not yet selected.

Required authorization boundaries:

### Platform Administrator
Can perform platform-level building provisioning and administrator assignment.

### Building Administrator
Can manage only the assigned building.

### Resident
Residents can:

- Access their own private maintenance requests.
- Access resident-visible details of master requests to which
  they are linked through duplicate merging.
- Access master-request attachments when authorized.

Residents must not:

- Access other residents' identities or contact information.
- Access duplicate-request submissions belonging to other residents.
- Access internal notes.
- Access audit records or security metadata.

Backend authorization must enforce these restrictions for both
API responses and attachment downloads.

## 9. API design

**Proposed:**
- REST API.
- Versioned base path: `/api/v1`.
- OpenAPI documentation.
- Request/response DTOs separate from database entities.
- Consistent validation and error responses.
- Pagination for collection endpoints.
- Explicit authorization policies.

Internal notes must never be returned in resident-facing API responses.

The final API contract will be created during implementation.

## 10. File storage

**Proposed:** Use a storage abstraction.

Local development can use local-compatible storage. Production can use an object storage service.

Security requirements:
- Validate actual file content.
- Enforce configured file-size and count limits.
- Use non-public storage by default.
- Authorize every download.
- Avoid exposing storage keys.
- Preserve original attachment associations when requests are merged.

Production storage provider and file limits remain open.

## 11. Notifications

MVP1 requires maintenance-related notifications.

Suggested events:
- Request submitted.
- Request approved or rejected.
- Priority changed.
- Work started.
- Request merged.
- Request resolved.

The notification provider and reliable delivery mechanism remain open.

Notification failure should not silently undo a successfully committed maintenance request.

- Notification delivery must track its delivery status.
- Failed notification delivery should support retry handling.
- External email delivery must not be part of the transaction that
  commits a maintenance request or workflow change.
- Notification payloads must not expose internal notes or private
  information belonging to other residents.

## 12. Local development

Docker Compose is approved for local development.

Expected components:
- Backend API.
- React frontend.
- PostgreSQL.
- Development file storage.

Production secrets must never be committed to Git.

## 13. Testing strategy

### Unit tests
- Business rules.
- Request status transitions.
- Contract rules.
- Membership rules.

- A linked resident can access master-request details.
- An unlinked resident cannot access master-request details.
- A linked resident cannot access another resident's duplicate submission.
- Master attachment access is independently authorized.
- Duplicate-request attachment access is independently restricted.
- Internal notes cannot be retrieved through shared request access.
- Concurrent membership approval cannot create multiple Approved
  memberships for the same Contract ID.

### Integration tests
- PostgreSQL constraints.
- Database transactions.
- Repository behavior.

### API tests
- Authentication.
- Role authorization.
- Building isolation.
- Resident request ownership.

### Security tests
- Cross-building access attempts.
- Access to another resident's requests.
- Internal note exposure.
- Unauthorized attachment retrieval.

### End-to-end tests
- Resident registration and membership.
- Request submission.
- Administrator request processing.
- Duplicate merging.

## 14. Observability and operations

MVP1 should include:
- Structured logs.
- Request/correlation IDs.
- Health endpoints.
- Error tracking.
- Database backup and restore procedures.
- Basic service health visibility.

Specific SLOs, RPO/RTO, retention, and monitoring providers remain open.

## 15. Architecture decision register

| ID | Decision | Status |
|---|---|---|
| ADR-001 | .NET 10 / ASP.NET Core | Approved |
| ADR-002 | React + TypeScript | Approved |
| ADR-003 | PostgreSQL | Approved |
| ADR-004 | Docker Compose for local development | Approved |
| ADR-005 | Modular monolith | Proposed |
| ADR-006 | REST API under /api/v1 | Proposed |
| ADR-007 | Object storage for photos | Proposed |
| ADR-008 | Authentication provider | Open |
| ADR-009 | Production hosting and Azure services | Open |
| ADR-010 | Notification provider | Open |

## 16. Related documentation

- [MVP1 Scope](mvp1-scope.md)
- [Feature Catalogue](feature-catalogue.md)
- [Business Rules](business-rules.md)
- [ERD](erd.md)
