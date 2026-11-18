
# BlueSky — MVP1 Business Rules

**Version:** 1.0  
**Status:** Confirmed decisions and open questions  
**Date:** 2026-11-18

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
| BR-026 | Spouse and household accounts are excluded from MVP1. | Confirmed |
| BR-027 | Registration and building membership are separate processes. | Confirmed |
| BR-028 | Contract ID must be verified against management records. | Confirmed |
| BR-029 | Contract ID alone does not grant building access. | Confirmed |
| BR-030 | Membership statuses are Pending, Approved, Rejected, and Revoked. | Confirmed |
| BR-031 | Contract expiry or revocation removes associated building access. | Confirmed |
| BR-032 | The user account may remain active after membership revocation. | Confirmed |
| BR-033 | National ID collection is not a default MVP1 requirement. | Confirmed |

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
| BR-048 | Priority levels are High, Medium, and Low. | Confirmed |
| BR-049 | Residents can view the priority of their own requests. | Confirmed |
| BR-050 | Residents may edit the original request before review begins. | Confirmed |
| BR-051 | After review begins, original submission becomes immutable to the resident. | Confirmed |
| BR-052 | Residents can add supplementary descriptions and photos after review begins. | Confirmed |
| BR-053 | Supplementary updates preserve author and timestamp. | Confirmed |
| BR-054 | Building Administrator can add internal notes. | Confirmed |
| BR-055 | Internal notes are never visible to residents. | Confirmed |

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
| BR-066 | Relevant master progress is shared with affected residents. | Confirmed |
| BR-067 | Other residents' names, contact details, descriptions, and photos remain private. | Confirmed |
| BR-068 | Circular merges must be prevented. | Confirmed |
| BR-069 | Reopening resolved requests is not yet decided. | Open |
| BR-070 | Resident cancellation is not yet decided. | Open |

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
| BR-092 | JPEG, PNG, and WebP are proposed image formats. | Proposed |
| BR-093 | Maximum file size and photo count are not decided. | Open |
| BR-094 | Notifications are limited to maintenance-related events. | Confirmed |
| BR-095 | General messaging and announcements are excluded. | Confirmed |
| BR-096 | Notifications must not expose internal notes or other residents' private data. | Confirmed |

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
| BR-107 | Exact audit and data retention periods are not decided. | Open |

## 10. Open questions

Do not silently convert these into confirmed rules:

1. Can one user hold multiple contracts?
2. Can one parking space be assigned to multiple active contracts?
3. Can one storage unit be assigned to multiple active contracts?
4. Can a resident report a problem inside another resident's private apartment?
5. Can a resident cancel a submitted request?
6. Can an administrator reopen a resolved request?
7. Are resolution photos required?
8. What are the maximum photo count and file size?
9. What notification provider and channels will be used?
10. What are the data and audit retention periods?

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
