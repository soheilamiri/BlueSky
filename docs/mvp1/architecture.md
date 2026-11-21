
# BlueSky — MVP1 Architecture

**Version:** 1.1  
**Status:** Approved stack; proposed application structure  
**Date:** 2026-11-21

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
    API --> DB
    WORKER[Notification Worker] --> DB
    WORKER --> EMAIL
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
- PostgreSQL-backed Outbox events.
- Background email delivery worker.
- Delivery attempts, retries, manual retry, and monitoring.

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
        NOTIFY[Notifications + Outbox Worker]
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
    NOTIFY --> DB
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

Resident-visible request history and updates are separate from administrative audit events. Audit events and security metadata must never be returned in resident-facing API responses.

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

Production storage provider remains open. MVP1 photo policy: JPEG, PNG, and WebP; maximum five photos on the original submission and on each subsequent update; maximum 10 MB per photo. Validate file content, not only extension or declared MIME type.

## 11. Notifications

MVP1 uses a PostgreSQL-backed Outbox pattern and a background worker for email delivery.

### Transaction and delivery flow

1. The API performs the business operation.
2. In the same PostgreSQL transaction, it persists the business change and a minimal Outbox event.
3. After commit, a background worker claims pending events and loads current recipient/request data.
4. The worker verifies account status and notification eligibility, captures the current email address for the attempt, and sends through the configured email provider.
5. Every delivery attempt and outcome is persisted separately from the Outbox event.

Email delivery is asynchronous and must never be part of the transaction that commits a maintenance or contract operation. Provider failure must not roll back the business action.

### Approved behavior

- Maintenance email events: request submitted, approved, rejected, priority changed, work started, merged, and resolved.
- A new Urgent request or a change to Urgent triggers an immediate email to the Building Administrator only. Residents receive no additional urgent email.
- Contract lifecycle emails: 60-day expiration reminder, expiration confirmation, early revocation, and successful renewal.
- Resident notification preferences are not configurable in MVP1; essential maintenance emails cannot be disabled.
- The Outbox payload contains only event metadata and identifiers, not rendered content or unnecessary personal data.
- The worker loads current recipient data at processing time. The email address captured at the start of an attempt remains that attempt's recipient. A retry loads the latest address.
- If a recipient is no longer eligible, mark the delivery Skipped with a reason; do not automatically retry it.
- Automatic retry: five attempts total, with delays of 1, 5, 15, and 60 minutes after failures. After the fifth failed attempt, mark Failed.
- A Building Administrator may manually retry Failed notifications for their own building. Preserve prior attempts; manual retry begins a new retry cycle and creates an audit event.
- A simple administrator-only monitoring page shows notification ID, event type, related request, recipient email, status, attempt count, last attempt, and last error. It supports viewing details/attempts and retrying Failed notifications.
- Outbox events and delivery attempts are retained for 24 months from original event creation. Manual retry does not reset retention.
- The in-app maintenance request history remains the authoritative record. No general chat, messaging, or separate notification inbox is introduced.

The email provider remains an implementation choice. Delivery attempts must be idempotent where supported and must not expose portal access codes, internal audit data, or another resident's private information.

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
- Contract rules.
- Membership rules.
- Request status transitions according to the approved MVP1 rules: duplicate merging is permitted only before the duplicate is Resolved or Rejected; Resolved and Rejected are terminal; resident cancellation and reopening are not supported.

### Integration tests
- PostgreSQL constraints.
- Database transactions.
- Repository behavior.

### API tests
- Authentication.
- Role authorization.
- Building isolation.
- Resident request ownership.

### Security and authorization tests
- Cross-building access attempts.
- Access to another resident's private requests.
- A linked resident can access resident-visible master-request details.
- An unlinked resident cannot access master-request details.
- A linked resident cannot access another resident's duplicate submission.
- Master attachment access is independently authorized.
- Duplicate-request attachment access is independently restricted.
- Administrative audit events and security metadata cannot be retrieved through shared request access.
- Concurrent membership approval cannot create multiple Approved
  memberships for the same Contract ID.
- Unauthorized attachment retrieval.

### End-to-end tests
- Resident registration and membership.
- Request submission.
- Administrator request processing.
- Duplicate merging.
- Resident cannot cancel; resolved requests cannot be reopened.
- Duplicate merge eligibility is enforced for Submitted, Under Review, Approved, and In Progress duplicate requests.

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
| ADR-011 | PostgreSQL Outbox and background notification worker | Approved |

## 16. Related documentation

- [MVP1 Scope](mvp1-scope.md)
- [Feature Catalogue](feature-catalogue.md)
- [Business Rules](business-rules.md)
- [ERD](erd.md)
