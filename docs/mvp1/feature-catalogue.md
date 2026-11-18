
# BlueSky — MVP1 Feature Catalogue

**Version:** 1.0  
**Status:** MVP1 planning baseline  
**Date:** 2026-11-18

## 1. Priority definitions

- **Must:** Required for MVP1.
- **Supporting:** Required technical or quality capability.
- **Excluded:** Not part of MVP1.
- **Open:** Requires a future decision.

## 2. Feature catalogue

| ID | Feature | Description | Priority | Actor |
|---|---|---|---|---|
| F-001 | User registration | Register using email and password | Must | Resident |
| F-002 | Email verification | Verify email address | Must | Resident |
| F-003 | Authentication | Login and password reset | Must | All |
| F-004 | Building provisioning | Create a building manually | Must | Platform Admin |
| F-005 | Administrator assignment | Assign one Building Administrator | Must | Platform Admin |
| F-006 | Floor management | Create and maintain floors | Must | Building Admin |
| F-007 | Apartment management | Create and maintain apartments | Must | Building Admin |
| F-008 | Parking management | Manage independent parking assets | Must | Building Admin |
| F-009 | Storage management | Manage independent storage assets | Must | Building Admin |
| F-010 | Contract management | Create and maintain contracts | Must | Building Admin |
| F-011 | Contract-apartment relationship | One apartment per contract; one active contract per apartment | Must | System |
| F-012 | Contract-parking relationship | Zero or multiple parking assignments | Must | System |
| F-013 | Contract-storage relationship | Zero or multiple storage assignments | Must | System |
| F-014 | Membership request | Resident submits building and Contract ID | Must | Resident |
| F-015 | Contract verification | Verify contract against management records | Must | Building Admin |
| F-016 | Membership approval | Approve or reject membership | Must | Building Admin |
| F-017 | Membership revocation | Remove access after contract expiry/revocation | Must | System/Admin |
| F-018 | Default categories | Provide initial maintenance categories | Must | System |
| F-019 | Category management | Create, edit, enable, disable, reorder | Must | Building Admin |
| F-020 | Request submission | Submit description, category, exactly one location, and optional photos | Must | Resident |
| F-021 | Request location | Require exactly one private-area or common-area problem location per request | Must | Resident || F-022 | Photo upload | Optionally upload multiple photos to a request | Must | Resident |
| F-023 | Request review | Review submitted requests | Must | Building Admin |
| F-024 | Request approval/rejection | Approve or reject with reason | Must | Building Admin |
| F-025 | Priority management | Assign and change priority | Must | Building Admin |
| F-026 | Status tracking | Track request lifecycle | Must | Resident/Admin |
| F-027 | Supplementary updates | Add text and photos after submission | Must | Resident |
| F-028 | Internal notes | Add private administrator notes | Must | Building Admin |
| F-029 | Resolution | Record resolution and resolve request | Must | Building Admin |
| F-030 | Duplicate merging | Merge duplicates while preserving history | Must | Building Admin |
| F-031 | Shared master request | Share all resident-visible details of the master request with residents linked through duplicate merging, while protecting identities, duplicate submissions, internal notes, and audit data | Must | System |
| F-032 | Notifications | Send request-related notifications | Must | System |
| F-033 | Audit history | Record important administrative actions | Must | System |
| F-034 | Building authorization | Enforce building-level data isolation | Supporting | System |
| F-035 | Resident authorization | Enforce resident-level data isolation | Supporting | System |
| F-036 | Attachment authorization | Authorize attachment retrieval | Supporting | System |
| F-037 | Historical preservation | Preserve contracts, assignments, and request history | Supporting | System |
| F-038 | Automated testing | Test business rules and access controls | Supporting | Development |
| F-039 | Observability | Structured logs and health checks | Supporting | Operations |

## 3. Excluded features

| ID | Feature | Reason |
|---|---|---|
| X-001 | Payments and accounting | MVP2 |
| X-002 | General announcements | MVP3 |
| X-003 | Direct messaging/chat | Not MVP1 |
| X-004 | Contractor portal | Not MVP1 |
| X-005 | Multiple Building Administrators | One administrator per building in MVP1 |
| X-006 | Video attachments | Photos only |
| X-007 | IoT integration | MVP4 |
| X-008 | Self-service building registration | Platform provisioning only |
| X-009 | Household accounts | One contract holder per contract |

## 4. Critical acceptance criteria
- Every resident linked to a merged request can access all resident-visible
  details of the master request.
- The master request's original description and photos are visible to
  linked residents.
- The identities and contact information of other residents remain private.
- Original descriptions, photos, and updates from duplicate requests remain
  private to their respective submitters and authorized administrators.
- Internal notes and audit records are never exposed through shared access.

### Identity and membership
- An unverified email cannot complete membership activation.
- Contract ID submission creates pending membership, not automatic access.
- Only the authorized Building Administrator can approve or reject membership.
- Expired or revoked contracts cannot authorize new membership.

### Building and contracts
- A contract must reference exactly one apartment.
- The system prevents two active contracts for one apartment.
- A contract may have no parking or storage assignments.
- A contract may have multiple parking and storage assignments.

### Maintenance
- Common-area requests do not require an apartment number.
- Residents cannot assign or change priority.
- Rejection requires an explanation.
- Residents cannot edit the original submission after review begins.
- Residents can still add supplementary updates.
- Internal notes are never exposed through resident APIs or notifications.
- Merging preserves original request IDs, histories, and attachments.
- Shared progress must not expose other residents' private information.
- A Contract ID cannot have more than one Approved membership at a time.
- Rejected and revoked membership attempts remain available for authorized
  administrative review.
- A historical rejected or revoked membership does not, by itself, prevent
  a later eligible membership from being approved.

## 5. Open feature details

The following are not yet finalized:

1. Whether resolved requests can be reopened.
2. Whether residents can cancel submitted requests.
3. Whether residents may report problems inside another resident's private apartment.
4. Whether resolution photos are required.
5. Maximum photo count.
6. Maximum photo file size.
7. Notification provider and delivery channels.
8. Audit and data retention periods.

## 6. Traceability

Every feature should eventually link to:
- Business rule IDs.
- User stories.
- Acceptance criteria.
- API endpoints.
- Database entities and constraints.
- Automated tests.
- Development issues or pull requests.

Example:

`F-011 → BR-015 → Contract table constraint → API validation → Integration test`

## 7. Related documentation

- [MVP1 Scope](mvp1-scope.md)
- [Business Rules](business-rules.md)
- [Architecture](architecture.md)
- [ERD](erd.md)
