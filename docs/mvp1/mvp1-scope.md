
# BlueSky — MVP1 Scope

**Version:** 1.0  
**Status:** MVP1 baseline  
**Date:** 2026-11-18

## 1. Purpose

MVP1 delivers a residential building maintenance and complaints management platform.

Residents can submit and track maintenance requests. Building Administrators manage building information, resident membership, maintenance categories, and maintenance workflows.

A Platform Administrator creates buildings and assigns their Building Administrator.

## 2. Product roadmap

| Release | Scope | Included in MVP1 |
|---|---|---|
| MVP1 | Maintenance and complaints | Yes |
| MVP2 | Payments and financial transparency | No |
| MVP3 | Communication and announcements | No |
| MVP4 | Building services, smart living, IoT | No |

MVP1 includes notifications related to maintenance requests only. It does not include general messaging or announcements.

## 3. User roles

### Platform Administrator
- Creates buildings manually.
- Assigns one Building Administrator to each building.
- Manages platform-level configuration.

### Building Administrator
- Manages building floors and apartments.
- Manages parking and storage assets.
- Manages contracts and resident membership.
- Manages maintenance categories.
- Reviews and processes maintenance requests.
- Records resolutions and merges duplicate requests.

MVP1 supports exactly one Building Administrator per building.

### Resident
- Registers with email and password.
- Verifies their email address.
- Requests membership using building and Contract ID information.
- Submits maintenance requests.
- Tracks their own maintenance requests.
- Accesses resident-visible details of master requests to which they become linked through duplicate merging.
- Adds supplementary information to requests.

Each contract has exactly one contract holder. One resident account may hold multiple contracts.

## 4. In-scope features

### 4.1 Identity and membership
- Email/password registration.
- Email verification.
- Login and password reset.
- Resident membership request.
- Contract ID verification by Building Administrator.
- Membership approval and rejection.
- Contract expiry or revocation immediately removes building access. The Approved membership record remains as historical status; access checks also require an eligible active contract.

Registration and building membership are separate processes.

### 4.2 Building and asset management
Building hierarchy:

`Building → Floor → Apartment`

Building Administrator manages:
- Floors
- Apartments
- Parking spaces
- Storage units
- Contracts

Parking and storage are independent assets, not apartment attributes.

Each contract:
- Belongs to exactly one apartment.
- Has one contract holder.
- Can have zero or multiple parking assignments.
- Can have zero or multiple storage assignments.

An apartment can have only one active contract at a time.

### 4.3 Maintenance management
Every maintenance request must have exactly one reported problem location.
The location must represent either a private area or a common area.
A common-area request does not require an apartment reference.

Residents can submit requests containing:
- Description
- Category
- Exactly one problem location
- Zero to five optional photo attachments, each no larger than 10 MB (JPEG, PNG, or WebP)

Requests can concern:
- The resident's own contracted apartment/private area.
- Common areas such as corridors, elevators, staircases, parking areas, and building entrances.

Residents cannot report problems inside another resident's private apartment in MVP1.

A common-area request does not require an apartment number.

Building Administrators can:
- Review requests.
- Approve or reject requests.
- Merge duplicates while the duplicate request is not Resolved or Rejected.
- Provide a rejection reason.
- Assign and change priority.
- Update request status.
- Add internal notes.
- Record resolution details.
- Merge duplicate requests.

### 4.4 Categories
Initial categories:
1. Elevator and lifts
2. Plumbing and water
3. Electrical systems
4. Heating and ventilation
5. Cleaning and common areas
6. Structural and general maintenance
7. Other / Not sure

Building Administrators can create, edit, enable, disable, and reorder categories.

Historical requests retain their original category information.

### 4.5 Notifications and audit
MVP1 sends maintenance-related email notifications for request submission, approval or rejection, priority changes, work starting, duplicate merging, and resolution. The in-app request history remains the authoritative record. Audit records are retained for important administrative and workflow actions.

Residents cannot cancel requests, and administrators cannot reopen resolved requests in MVP1. A recurring problem must be submitted as a new request.

Internal notes must never be visible to residents.

## 5. Out of scope

The following are excluded from MVP1:

- Online payments and accounting.
- Financial reporting.
- General announcements.
- Community messaging and direct chat.
- Contractor accounts.
- Multiple Building Administrators per building.
- Sub-administrators and delegation.
- Household or family accounts.
- Video uploads.
- IoT and smart-building integrations.
- Self-service building creation.
- Native mobile applications.

These features may be considered in later releases.

## 6. MVP1 acceptance criteria

MVP1 is functionally ready when:

1. Platform Administrator can create a building.
2. Platform Administrator can assign its Building Administrator.
3. Building Administrator can manage floors and apartments.
4. Building Administrator can manage independent parking and storage assets.
5. Building Administrator can create and manage contracts.
6. The system prevents multiple active contracts for one apartment.
7. Residents can register and verify their email.
8. Residents can request membership using a Contract ID.
9. Building Administrator can approve or reject membership.
10. Approved residents can submit maintenance requests.
11. Every maintenance request has exactly one reported problem location; common-area requests do not require an apartment reference.
12. Residents can submit maintenance requests without photos or attach up to five JPEG, PNG, or WebP photos, each no larger than 10 MB.
13. Building Administrator can manage request status and priority; requests cannot be cancelled by residents or reopened after resolution.
14. Rejected requests require a reason.
15. Duplicate requests can be merged without losing history.
16. Residents cannot access other residents' identities, contact information,
or private duplicate-request submissions. They can access the
resident-visible details of master requests to which they are linked
through duplicate merging.
17. Internal notes remain administrator-only.
18. Relevant notifications and audit records are generated.
19. Critical business rules and authorization boundaries have automated tests.
20. A resident account can hold multiple contracts, but each contract has exactly one holder.
21. Residents can report only their own private apartment or common areas.
22. Duplicate requests can be merged only before they are Resolved or Rejected.
23. Resolved and Rejected requests are terminal; residents cannot cancel requests.
24. Resolution photos are optional.
25. The system enforces a maximum of five photos per submission and 10 MB per photo, accepting JPEG, PNG, and WebP.
26. Maintenance lifecycle notifications are sent by email for the approved event set.

## 7. Scope management

Any proposed feature must be classified as:

- MVP1 Must
- MVP1 Supporting
- Later MVP
- Out of Scope

A scope change requires an explicit product decision and updates to affected documentation.

## 8. Related documentation

- [Feature Catalogue](feature-catalogue.md)
- [Business Rules](business-rules.md)
- [Architecture](architecture.md)
- [Entity Relationship Model](erd.md)
