
# BlueSky — MVP1 Feature Catalogue

**Version:** 1.1  
**Status:** MVP1 planning baseline  
**Date:** 2026-11-21

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
| F-017 | Membership access eligibility | Remove building access when contract expires or is revoked while preserving the historical Approved membership status | Must | System/Admin |
| F-018 | Default categories | Provide initial maintenance categories | Must | System |
| F-019 | Category management | Create, edit, enable, disable, reorder | Must | Building Admin |
| F-020 | Request submission | Submit description, category, exactly one location, and optional photos | Must | Resident |
| F-021 | Request location | Require exactly one private-area or common-area problem location per request | Must | Resident |
| F-022 | Photo upload | Original submission supports up to five JPEG, PNG, or WebP photos, maximum 10 MB each | Must | Resident |
| F-023 | Request review | Review submitted requests | Must | Building Admin |
| F-024 | Request approval/rejection | Approve or reject with reason | Must | Building Admin |
| F-025 | Priority management | Assign and change priority | Must | Building Admin |
| F-026 | Status tracking | Track request lifecycle | Must | Resident/Admin |
| F-027 | Append-only request updates | Residents and Building Administrators add comments, photos, or both to non-terminal requests; no editing, deletion, threads, or chat | Must | Resident/Admin |
| F-028 | Resident-visible request history | Record status transitions and priority changes in chronological history; keep administrative audit events separate | Must | System |
| F-029 | Resolution | Record resolution and resolve request | Must | Building Admin |
| F-030 | Duplicate merging | Merge duplicates while preserving history | Must | Building Admin |
| F-031 | Shared master request | Share all resident-visible details of the master request with residents linked through duplicate merging, while protecting identities, duplicate submissions, and administrative audit data | Must | System |
| F-032 | Notifications | Send request-related notifications | Must | System |
| F-033 | Audit history | Record important administrative actions | Must | System |
| F-034 | Building authorization | Enforce building-level data isolation | Supporting | System |
| F-035 | Resident authorization | Enforce resident-level data isolation | Supporting | System |
| F-036 | Attachment authorization | Authorize attachment retrieval | Supporting | System |
| F-037 | Historical preservation | Preserve contracts, assignments, and request history | Supporting | System |
| F-038 | Automated testing | Test business rules and access controls | Supporting | Development |
| F-039 | Observability | Structured logs and health checks | Supporting | Operations |\n| F-040 | Urgent notification | Immediately email the Building Administrator when a request becomes Urgent | Must | System |\n| F-041 | Notification Outbox | Persist event and business change atomically; deliver asynchronously with retry and idempotency controls | Supporting | System |\n| F-042 | Notification monitoring | Building Administrator views delivery state and manually retries Failed notifications for their building | Must | Building Admin |

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
- Every resident linked to a master request through duplicate merging
  can access all resident-visible details of that master request.
- The master request's original description and photos are visible
  to linked residents.
- Linked residents can view the master's status, priority, resident-visible
  updates, and resolution details.
- The identities and contact information of other residents remain private.
- Original descriptions, photos, and updates belonging to duplicate
  requests remain private to their respective submitters and authorized
  administrators.
- Internal notes, audit records, and security metadata are never exposed
  through shared access.
- Linked residents can access master-request attachments only after
  backend authorization.
- Linked residents cannot access duplicate-request attachments belonging
  to other residents.
- A maintenance request cannot be created without exactly one problem location.
- A maintenance request cannot be associated with multiple problem locations.
- Each resident account may hold multiple contracts, but each contract has exactly one holder.
- Each photo must be JPEG, PNG, or WebP and no larger than 10 MB; the original submission and each subsequent update may contain up to five photos.
- Maintenance notifications use email for submission, approval/rejection, priority changes, work start, merge, and resolution.
- A common-area location does not require an apartment reference.

### Identity and membership
- An unverified email cannot complete membership activation.
- Contract ID submission creates pending membership, not automatic access.
- Only the authorized Building Administrator can approve or reject membership.
- Expired or revoked contracts cannot authorize new membership.
- Concurrent approval attempts for different membership requests referencing
  the same Contract ID cannot create more than one Approved membership.
- Rejected and revoked membership attempts remain available for authorized
  administrative review.
- A historical rejected or revoked membership does not, by itself, prevent
  a later eligible membership from being approved.

### Building and contracts
- A contract must reference exactly one apartment.
- The system prevents two active contracts for one apartment.
- A contract may have no parking or storage assignments.
- A contract may have multiple parking and storage assignments.

### Maintenance
- A resident can report a private-area problem only in their own contracted apartment.
- Residents cannot report problems inside another resident's private apartment.
- Residents cannot cancel maintenance requests.
- Resolved requests cannot be reopened; a recurring issue requires a new request.
- Duplicate requests may be merged only while the duplicate is not Resolved or Rejected.
- Resolution photos are optional.
- Common-area requests do not require an apartment number.
- Residents cannot assign or change priority.
- Rejection requires an explanation.
- Residents cannot edit the original submission after review begins.
- Residents can still add supplementary updates.
- Resident-visible request history is append-only; administrative audit events are never exposed through resident APIs or notifications.
- Merging preserves original request IDs, histories, and attachments.
- Shared progress must not expose other residents' private information.

## 5. Deferred decisions

The following are outside the remaining MVP1 product decisions and must not expand MVP1 implementation:

1. Exact audit and data retention periods.
2. Notification delivery provider implementation details beyond email as the MVP1 channel.
3. Whether parking or storage assets may have overlapping active assignments.

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
