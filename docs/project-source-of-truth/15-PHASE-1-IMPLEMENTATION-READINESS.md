# 15 — Phase 1 Implementation Readiness (Parent Experience — Corrected)

> [!IMPORTANT]
> **GOVERNANCE & STRICT READINESS STANDARDS**:
> This readiness classification is strictly confined to the **Parent Experience** (including genuinely shared screens).
> All Student-only screens have been removed and quarantined for Phase 1B.
>
> A screen is classified **`READY`** only when:
> 1. Exact Parent Figma node/frame is identified on `Parent(full app)_TreLern`
> 2. Parent or SHARED role is established with evidence
> 3. PRD relationship is clear
> 4. User flow is established
> 5. Required API contract is verified in Postman OR screen is purely static/local
> 6. No unresolved product decision or missing mutation blocks the feature

---

## 1. Readiness Summary by Category (Parent Scope Only)

| Category | Total Screens | READY | NEEDS CONFIRMATION | BACKEND DEPENDENCY | OUT OF SCOPE |
|---|:---:|:---:|:---:|:---:|:---:|
| **Public & Onboarding Flow** | 8 | 2 | 1 | 5 | 0 |
| **Parent Core Oversight & Hub** | 2 | 2 | 0 | 0 | 0 |
| **Billing & Financial Ledger** | 3 | 2 | 1 | 0 | 0 |
| **Shared Oversight (Classes & Homework)**| 5 | 5 | 0 | 0 | 0 |
| **Account, Settings & Security** | 6 | 4 | 0 | 1 | 1 |
| **Marketing & Lead Intake** | 2 | 2 | 0 | 0 | 0 |
| **Offline Utility** | 1 | 0 | 1 | 0 | 0 |
| **Total Scoped Screens** | **30** | **20** | **3** | **6** | **1** |

---

## 2. Granular Screen-by-Screen Implementation Readiness Table

| Screen ID | Frame Name on Figma Canvas | Role | PRD Relationship | Implementation Status | Granular Dependency / Blocker Description |
|---|---|:---:|---|:---:|---|
| **SCR-01** | `Splash Screen` | **SHARED** | Bootstrap & Maintenance Check | **`READY`** | Backed by `GET /api/v1/public/portal-config`. Verified. |
| **SCR-02** | `Onboarding (1, 2, 3)` | **SHARED** | Value Proposition Walkthrough | **`READY`** | Static client presentation carousel. |
| **SCR-03** | `Student/Parent Login` | **SHARED** | Primary Authentication Gate | **`READY (PLANNING)`** / **`BLOCKED (RUNTIME)`** | Contract is verified (`POST /api/auth/login`). Runtime testing blocked by backend 500 error. |
| **SCR-04** | `Student/Parent Verify Code` | **SHARED** | Phone 2FA / Code Verification | **`BACKEND DEPENDENCY`** | Missing backend OTP mutation endpoint (`POST /api/auth/otp/verify`). |
| **SCR-05** | `Student Interests` | **PARENT LEARNER/CHILD CONTEXT** | Learner Subject Selection | **`NEEDS CONFIRMATION`** | Parent enters child's grade/section dropdowns during intake; API unbuilt. |
| **SCR-06** | `Student Account Details` | **PARENT** | Guardian Profile Setup | **`BACKEND DEPENDENCY`** | Missing backend profile mutation endpoint (`PUT /api/parent/profile`). |
| **SCR-07** | `Student Child Details` | **PARENT LEARNER/CHILD CONTEXT** | Ward Linking / Self-Registration | **`BACKEND DEPENDENCY`** | Missing ward creation API (`POST /api/parent/children`). |
| **SCR-08** | `Student Almost Ready` | **PARENT** | Cohort Schedule Timezone Setup | **`BACKEND DEPENDENCY`** | Missing user timezone update API (`PUT /api/parent/timezone`). |
| **SCR-09** | `Parent Dashboard` | **PARENT** | High-level metrics for active ward | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `GET /api/parent/children/:id/dashboard`. |
| **SCR-11** | `My Children` | **PARENT** | Multi-child directory & switcher | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `GET /api/parent/children`. |
| **SCR-13** | `Class Schedule (Timetable)` | **SHARED** | Ward Live Class Schedule | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `GET /api/live-classes`. |
| **SCR-14** | `Class Details` | **SHARED** | Class agenda, teacher info, handouts | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `GET /api/live-classes/:id`. |
| **SCR-17** | `Offline Dashboard` | **SHARED** | Cached offline UX artboard | **`NEEDS CONFIRMATION`** | Artboard exists on canvas; client caching rules need confirmation. |
| **SCR-18** | `Assignments` | **SHARED** | Ward homework list | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `GET /api/assignments`. |
| **SCR-19** | `Assignment Details` | **SHARED** | Homework rubric and instructions | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `GET /api/assignments/:id`. |
| **SCR-22** | `Teacher Feedback (Revised)` | **SHARED** | Graded marks and instructor remarks | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `/api/assignments/:id` evaluation payload. |
| **SCR-24** | `Learning Progress (New)` | **SHARED** | Child attendance log & progress ring | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `GET /api/attendance/summary`. |
| **SCR-26** | `Profile` | **SHARED** | Guardian identity & contact details | **`READY FOR IMPLEMENTATION PLANNING`** | Display supported by active user object. |
| **SCR-27** | `Messages / Inquiries` | **SHARED** | Direct teacher inquiry / chat | **`OUT OF SCOPE`** | PRD v1 freeze excludes chat; backend lacks chat microservice. |
| **SCR-28** | `Notifications` | **SHARED** | In-app alerts feed | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `GET /api/notifications/inbox` & mark-read API. |
| **SCR-29** | `Security & Privacy` | **SHARED** | Password change & security | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `POST /api/auth/change-password`. |
| **SCR-30** | `Login Methods` | **SHARED** | Configured social auth options | **`BACKEND DEPENDENCY`** | Missing backend social OAuth endpoints. |
| **SCR-31** | `Login & Devices` | **SHARED** | Active device session revocation | **`BACKEND DEPENDENCY`** | Missing session revocation API (`/api/auth/devices`). |
| **SCR-32** | `Invoices` | **PARENT** | Tuition fee statements & balance | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `GET /api/finance/invoices` & child finance API. |
| **SCR-33** | `Invoice Detail` | **PARENT** | Itemized fee breakdown & tax summary | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `GET /api/finance/invoices/:id`. |
| **SCR-34** | `Payment Successful` | **OVERLAY** | Payment confirmation & receipt | **`NEEDS CONFIRMATION`** | Receipt read API exists; payment execution/callback mechanism unresolved. |
| **SCR-35** | `Hamburger Drawer — Default` | **OVERLAY** | Side menu quick navigation | **`READY FOR IMPLEMENTATION PLANNING`** | Client navigation shell container. |
| **SCR-36** | `Account Settings` | **SHARED** | Alert & notification toggles | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `GET /api/notifications/preferences`. |
| **SCR-37** | `Demo Booking (1 & 2)` | **SHARED** | Prospective parent trial booking | **`READY FOR IMPLEMENTATION PLANNING`** | Backed by `POST /api/public/lead`. |
| **SCR-38** | `Demo Booking Confirmed` | **OVERLAY** | Trial booking confirmation modal | **`READY FOR IMPLEMENTATION PLANNING`** | Modal confirmation state backed by `leadId`. |

---

## 3. Quarantined Student Screens (Deferred to Phase 1B)
The following screens from the Figma canvas are strictly excluded from Phase 1A counts and deferred to Phase 1B:
1. `SCR-10: Student Dashboard`
2. `SCR-12: Current Program`
3. `SCR-15: Ready to Join (Revised)`
4. `SCR-16: Live Classroom`
5. `SCR-20: Assignment Submission`
6. `SCR-21: Assignment Submitted (Revised)`
7. `SCR-23: Topic Detail (New)`
8. `SCR-25: Achievements`

---

## 4. Final Governance Gate Lock Status

```
============================================================
TRUELEARN AIO FLUTTER — GOVERNANCE GATE LOCK STATUS
============================================================
PHASE 1A — PARENT:
[LOCKED — APPROVED PLANNING BASELINE]

PHASE 1B — STUDENT:
[NOT STARTED]

FLUTTER IMPLEMENTATION:
[NOT STARTED]

BACKEND IMPLEMENTATION:
[NOT STARTED]
============================================================
```

