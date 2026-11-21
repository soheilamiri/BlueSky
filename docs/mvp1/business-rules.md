
# BlueSky — MVP1 Business Rules

**Version:** 1.1  
**Status:** Confirmed decisions and open questions  
**Date:** 2026-11-21

## 1. Status definitions

- **Confirmed:** Explicitly approved for MVP1.
- **Proposed:** Recommended, but not approved.
- **Open:** Requires a decision.

## 2. Roles and building management

| ID | Business rule | Status |
|---|---|---|
| BR-001 | MVP1 has Platform Administrator, Building Administrator, and Resident roles. | Confirmed |
| BR-002 | Each building has exactly one Building Administrator. | Confirmed |
| BR-003 | Platform Administrator manually creates buildings and assigns administrators. | Confirmed |
| BR-004 | Self-service building creation is excluded. | Confirmed |
| BR-005 | Sub-administrators, delegation, and additional building staff roles are excluded. | Confirmed |
| BR-006 | A building must have exactly one active Building Administrator assignment. | Confirmed |
| BR-007 | A Building Administrator replacement must close the previous assignment and create the new assignment atomically. | Confirmed |
| BR-008 | Historical administrator assignments must be retained with their effective dates. | Confirmed |
| BR-009 | Two Building Administrator assignments for the same building must never overlap. | Confirmed |

## 3. Building structure and assets

| ID | Business rule | Status |
|---|---|---|
| BR-010 | Building hierarchy is Building → Floor → Apartment. | Confirmed |
| BR-011 | Building Administrator manages floors and apartments. | Confirmed |
| BR-012 | Parking spaces are independent assets. | Confirmed |
| BR-013 | Storage units are independent assets. | Confirmed |
| BR-014 | Every contract belongs to exactly one apartment. | Confirmed |
| BR-015 | An apartment may have only one active contract at a time. | Confirmed |
| BR-016 | A contract may have zero, one, or multiple parking assignments. | Confirmed |
| BR-017 | A contract may have zero, one, or multiple storage assignments. | Confirmed |
| BR-018 | Building Administrator manages asset assignments. | Confirmed |

## 4. Contracts and membership

| ID | Business rule | Status |
|---|---|---|
| BR-020 | Contract IDs are issued and maintained by the management company. | Confirmed |
| BR-021 | Every new contract receives a new Contract ID. | Confirmed |
| BR-022 | Contract IDs are never reused. | Confirmed |
| BR-023 | Expired or revoked contracts cannot authorize new membership. | Confirmed |
| BR-024 | Historical contract records must be preserved. | Confirmed |
| BR-025 | Exactly one contract holder is supported per contract. | Confirmed |
| BR-038 | One resident account may hold multiple contracts. | Confirmed |
| BR-026 | Spouse and household accounts are excluded from MVP1. | Confirmed |
| BR-027 | Registration and building membership are separate processes. | Confirmed |
| BR-028 | Contract ID must be verified against management records. | Confirmed |
| BR-029 | Contract ID alone does not grant building access. | Confirmed |
| BR-030 | Membership statuses are Pending, Approved, Rejected, and Revoked. | Confirmed |
| BR-031 | Building access requires both an Approved membership and an eligible contract. Contract expiry or revocation removes building access. | Confirmed |
| BR-032 | The user account may remain active after membership revocation. | Confirmed |
| BR-033 | National ID collection is not a default MVP1 requirement. | Confirmed |
| BR-034 | A Contract ID may have at most one Approved membership at a time. | Confirmed |
| BR-035 | Rejected and revoked membership attempts must be retained as historical records. | Confirmed |
| BR-036 | Multiple historical membership attempts may reference the same Contract ID. | Confirmed |
| BR-037 | The system must enforce at most one Approved membership per Contract ID, including during concurrent approval attempts. | Confirmed |

**Confirmed:** Contract expiry or revocation removes building access immediately. The membership record remains Approved as historical status; every access decision must also verify that the contract is eligible and active.
## 5. Maintenance requests

| ID | Business rule | Status |
|---|---|---|
| BR-040 | A request includes description, category, location, and optional photos. | Confirmed |
| BR-041 | Residents can report apartment/private-area problems. | Confirmed |
| BR-042 | Residents can report common-area problems. | Confirmed |
| BR-043 | Common-area requests do not require an apartment number. | Confirmed |
| BR-044 | Reported problem location is separate from registered apartment. | Confirmed |
| BR-045 | Building Administrator manages the maintenance lifecycle. | Confirmed |
| BR-046 | Rejection requires a reason. | Confirmed |
| BR-047 | Only Building Administrator assigns or changes priority. | Confirmed |
| BR-048 | Priority levels are Low, Normal, High, and Urgent; Urgent is reserved exclusively for immediate safety risk. | Confirmed |
| BR-049 | Residents can view the priority of their own requests. | Confirmed |
| BR-050 | Original request submission content is immutable after submission. | Confirmed |
| BR-051 | Residents cannot edit or delete the original submission. | Confirmed |
| BR-052 | Residents can add append-only comments and photos to non-terminal requests. | Confirmed |
| BR-053 | Every supplementary update preserves author and timestamp and is visible to authorized residents under merge-sharing rules. | Confirmed |
| BR-054 | Building Administrators can add append-only comments and photos to non-terminal requests; no internal notes are supported. | Confirmed |
| BR-055 | Administrative audit events are separate from resident-visible request history and are never exposed to residents. | Confirmed |
| BR-056 | Every maintenance request must have exactly one reported problem location. | Confirmed |
| BR-057 | A private-area location must reference the relevant apartment. | Confirmed |
| BR-058 | A common-area location must identify a valid common-area type. | Confirmed |
| BR-059 | A common-area location must not require an apartment reference. | Confirmed |
| BR-074 | Residents may report private-area problems only in their own contracted apartment or common-area problems. | Confirmed |
| BR-075 | Residents cannot report problems inside another resident's private apartment. | Confirmed |
| BR-076 | Residents cannot cancel maintenance requests in MVP1. | Confirmed |
| BR-077 | Resolved requests cannot be reopened in MVP1; recurring problems require a new request. | Confirmed |
| BR-078 | Duplicate requests may be merged only while the duplicate is not Resolved or Rejected. | Confirmed |

## 6. Request status and merging

Current status vocabulary:

- Submitted
- Under Review
- Approved
- In Progress
- Resolved
- Rejected
- Merged

| ID | Business rule | Status |
|---|---|---|
| BR-060 | Building Administrator can merge duplicate requests. | Confirmed |
| BR-061 | One request becomes the master request. | Confirmed |
| BR-062 | Duplicate requests are linked to the master. | Confirmed |
| BR-063 | Original request IDs and histories are preserved. | Confirmed |
| BR-064 | Original attachments remain associated with their submissions. | Confirmed |
| BR-065 | Merged is a terminal state for a duplicate request. | Confirmed |
| BR-066 | All resident-visible details of a master request are shared with every resident linked to that master through a duplicate merge. | Confirmed |
| BR-067 | Shared master-request details include its original description, original photos, status, priority, resident-visible master updates, and resolution details. | Confirmed |
| BR-068 | Only resident-visible updates belonging to the master request are shared with linked residents. | Confirmed |
| BR-069 | Updates belonging to duplicate requests remain private to their respective submitters and authorized administrators. | Confirmed |
| BR-070 | Administrative audit events and security metadata are never shared with residents, including residents linked through duplicate merging. | Confirmed |
| BR-071 | Master-request submitter identity and contact information remain private to other residents. | Confirmed |
| BR-072 | Original descriptions, photos, and updates belonging to duplicate requests remain private to their respective submitters and authorized administrators. | Confirmed |
| BR-073 | Administrative audit records and security metadata are never visible to residents through shared request access. | Confirmed |

### Status transition rules

The following MVP1 lifecycle constraints are confirmed. Other status changes must be implemented only through the defined administrator workflow operations, not arbitrary client updates.

**Confirmed MVP1 transition constraints:**
- Duplicate requests may be merged only from Submitted, Under Review, Approved, or In Progress.
- Resolved, Rejected, and Merged are terminal states.
- Residents cannot cancel requests.
- Resolved requests cannot be reopened; a recurring problem is submitted as a new request.
- The master request retains its current status when a duplicate is merged.

A Merged request is terminal for the duplicate record. A duplicate may be merged only from Submitted, Under Review, Approved, or In Progress. Resolved and Rejected requests cannot be merged. The master request retains its own status and history.

## 7. Maintenance categories

| ID | Business rule | Status |
|---|---|---|
| BR-080 | Categories are configurable per building. | Confirmed |
| BR-081 | Default categories are provided. | Confirmed |
| BR-082 | Other / Not sure is always available. | Confirmed |
| BR-083 | Building Administrator can create and edit categories. | Confirmed |
| BR-084 | Building Administrator can enable, disable, and reorder categories. | Confirmed |
| BR-085 | Historical requests preserve their original category. | Confirmed |
| BR-086 | Categories referenced by historical requests should be disabled rather than deleted. | Confirmed |

Initial categories:
1. Elevator and lifts
2. Plumbing and water
3. Electrical systems
4. Heating and ventilation
5. Cleaning and common areas
6. Structural and general maintenance
7. Other / Not sure

## 8. Attachments and notifications

| ID | Business rule | Status |
|---|---|---|
| BR-090 | Multiple photos are supported. | Confirmed |
| BR-091 | Video uploads are excluded. | Confirmed |
| BR-092 | JPEG, PNG, and WebP are the accepted image formats. | Confirmed |
| BR-093 | Original submission and each subsequent update may contain at most five photos, each no larger than 10 MB. | Confirmed |
| BR-094 | Accepted photo formats are JPEG, PNG, and WebP. | Confirmed |
| BR-095 | Notifications are limited to maintenance-related events. | Confirmed |
| BR-096 | General messaging and announcements are excluded. | Confirmed |
| BR-097 | Notifications must not expose administrative audit data or other residents' private data. | Confirmed |
| BR-098 | Uploaded files must be validated using file content, not only filename or declared MIME type. | Confirmed |
| BR-099 | Attachments must not be publicly accessible by default. | Confirmed |
| BR-110 | Every attachment retrieval must perform backend authorization. | Confirmed |
| BR-111 | MVP1 maintenance notifications are delivered by email. | Confirmed |
| BR-112 | Email notifications are generated for submission, approval/rejection, priority changes, work starting, merging, and resolution. | Confirmed |
| BR-114 | A new Urgent request or a priority change to Urgent immediately emails the Building Administrator only. | Confirmed |
| BR-115 | Residents cannot disable essential maintenance emails in MVP1. | Confirmed |
| BR-116 | Maintenance email events are written to a PostgreSQL Outbox in the same transaction as the business change and sent asynchronously after commit. | Confirmed |
| BR-117 | Outbox delivery uses five automatic attempts with delays of 1, 5, 15, and 60 minutes; Failed notifications may be manually retried by the Building Administrator for that building. | Confirmed |
| BR-118 | Notification payloads contain minimal identifiers/metadata; the worker loads current recipient data at processing time. | Confirmed |
| BR-119 | Ineligible recipients are marked Skipped with a reason and are not automatically retried. | Confirmed |
| BR-120 | Each delivery attempt records the email address captured at attempt start; a later retry resolves the current address again. | Confirmed |
| BR-121 | Notification monitoring and manual retry are restricted to the Building Administrator of the associated building. | Confirmed |
| BR-113 | Resolution photos are optional. | Confirmed |

## 9. Security and audit

| ID | Business rule | Status |
|---|---|---|
| BR-100 | Contract IDs must not be visible to other residents. | Confirmed |
| BR-101 | Contract verification attempts should be auditable. | Confirmed |
| BR-102 | Membership decisions should be auditable. | Confirmed |
| BR-103 | Backend authorization is mandatory. | Confirmed |
| BR-104 | Building-level data isolation is mandatory. | Confirmed |
| BR-105 | Resident-level access restrictions are mandatory. | Confirmed |
| BR-106 | Important administrative and maintenance actions are audited. | Confirmed |
| BR-107 | Exact audit-event retention period remains open; notification events and delivery attempts are retained for 24 months from original event creation. | Confirmed |

## 10. Deferred decisions

1. Can one parking space be assigned to multiple active contracts?
2. Can one storage unit be assigned to multiple active contracts?
3. What are the exact data and audit retention periods?
4. Which email delivery provider will be used?

These decisions do not block the MVP1 maintenance workflow baseline. Do not silently expand scope to resolve them.

## 11. Implementation requirements

- Enforce confirmed rules in backend logic.
- Use database constraints for important data invariants where practical.
- Never rely on frontend checks as the only authorization control.
- Preserve historical records.
- Record changes to important business data.
- Update this document when a business decision changes.

## 12. Related documentation

- [MVP1 Scope](mvp1-scope.md)
- [Feature Catalogue](feature-catalogue.md)
- [Architecture](architecture.md)
- [ERD](erd.md)
