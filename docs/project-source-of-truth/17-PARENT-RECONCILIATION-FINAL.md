# 17 — Parent Master Reconciliation Specification (Phase 1A Final Governance Pass)

> [!IMPORTANT]
> **STRICT GOVERNANCE & RECONCILIATION BASELINE**:
> This document establishes the definitive, mathematical, and evidence-based reconciliation of the **Parent Experience** within the unified TrueLern AIO mobile application.
>
> **Role Definitions**:
> - **`PARENT`**: Dedicated screen used exclusively in the Parent portal / guardian account experience.
> - **`SHARED`**: Functional screen used by both Parent and Student (verified by PRD/Figma).
> - **`PARENT LEARNER/CHILD CONTEXT`**: Parent-operated screen specifically capturing or managing learner/child information.
> - **`OVERLAY`**: Visual overlay (modal, drawer, or dialog state) presented on top of a host screen without an independent navigation route.
>
> **Terminology & Status Definitions**:
> - **`[READY FOR IMPLEMENTATION PLANNING]`**: The design artifact is identified on `Parent(full app)_TreLern`, PRD role is verified, user flow is established, and required API contract exists in Postman (or item is purely static). *Does NOT imply runtime verified.*
> - **`[NEEDS CONFIRMATION]`**: Design or product workflow requires explicit stakeholder confirmation before technical decisions are made.
> - **`[BACKEND DEPENDENCY]`**: Feature requires a backend capability or mutation endpoint currently missing from the Postman API collection.
> - **`[OUT OF SCOPE]`**: Feature is explicitly excluded by the PRD Core Freeze.
> - **`[RUNTIME BLOCKED]`**: Endpoint exists in the contract, but production execution currently fails (e.g. login 500 error).
>
> **Zero Implementation Enforcement**: No Flutter widgets, Dart models, or backend code have been modified or created.

---

## 1. Master Parent Reconciliation Table (30 Scoped Figma Artifacts)

| ID | Figma Node | Name | Role | UI Type | PRD | API | Planning Status | Runtime Status | Dependency |
|---|---|---|:---:|:---:|---|---|:---:|:---:|---|
| **SCR-01** | `Splash Screen` | Splash Screen | **SHARED** | NAVIGABLE SCREEN | App Bootstrap & Version Check | `GET /api/v1/public/portal-config` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[RUNTIME VERIFIED]` | Local secure storage for token inspection. |
| **SCR-02** | `Onboarding (1, 2, 3)` | Onboarding Intro | **SHARED** | NAVIGABLE SCREEN | Public Cohort Value Prop Carousel | None (Static Carousel) | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[N/A — STATIC]` | Pure client presentation. |
| **SCR-03** | `Student/Parent Login` | Login Screen | **SHARED** | NAVIGABLE SCREEN | Primary Authentication Gate | `POST /api/auth/login` | **`[READY FOR IMPLEMENTATION PLANNING]`** | **`[BLOCKED — LOGIN 500]`** | Contract verified in Folder 02. Runtime testing blocked by server 500. |
| **SCR-04** | `Student/Parent Verify Code` | Verify Code (OTP) | **SHARED** | NAVIGABLE SCREEN | Phone 2FA / Code Verification | `POST /api/auth/otp/verify` | **`[BACKEND DEPENDENCY]`** | `[BLOCKED — NO API]` | Missing SMS/Email OTP gateway in backend. |
| **SCR-05** | `Student Interests` | Interests Setup | **PARENT LEARNER/CHILD CONTEXT** | NAVIGABLE SCREEN | Learner Grade & Subject Intake | None in API Contract | **`[NEEDS CONFIRMATION]`** | `[BLOCKED — NO API]` | Parent enters child's grade/section dropdowns during intake; API unbuilt. |
| **SCR-06** | `Student Account Details` | Account Details | **PARENT** | NAVIGABLE SCREEN | Guardian Contact Setup | `PUT /api/parent/profile` | **`[BACKEND DEPENDENCY]`** | `[BLOCKED — NO API]` | Parent enters guardian name/email; profile mutation API unbuilt. |
| **SCR-07** | `Student Child Details` | Child Details Setup | **PARENT LEARNER/CHILD CONTEXT** | NAVIGABLE SCREEN | Ward Profile Linking / Setup | `POST /api/parent/children` | **`[BACKEND DEPENDENCY]`** | `[BLOCKED — NO API]` | Parent enters ward name/age/grade; ward creation API unbuilt. |
| **SCR-08** | `Student Almost Ready` | Almost Ready / Location | **PARENT** | NAVIGABLE SCREEN | Timezone Setup for Classes | `PUT /api/parent/timezone` | **`[BACKEND DEPENDENCY]`** | `[BLOCKED — NO API]` | Parent sets timezone; user timezone mutation API unbuilt. |
| **SCR-09** | `Parent Dashboard` | Parent Dashboard | **PARENT** | NAVIGABLE SCREEN | Ward Oversight Dashboard | `GET /api/parent/children/:id/dashboard` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Requires `childStudentId` context from SCR-11. |
| **SCR-11** | `My Children` | My Children Hub | **PARENT** | NAVIGABLE SCREEN | Multi-Ward Directory & Switcher | `GET /api/parent/children` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Read API supported; "+ Add Child" blocked. |
| **SCR-13** | `Class Schedule` | My Classes / Timetable | **SHARED** | NAVIGABLE SCREEN | Child Live Class Timetable | `GET /api/live-classes` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Timetable filtered by active child's cohort. |
| **SCR-14** | `Class Details` | Class Details | **SHARED** | NAVIGABLE SCREEN | Class Agenda, Teacher Info | `GET /api/live-classes/:id` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Read-only session overview. |
| **SCR-17** | `Offline Dashboard` | Offline Dashboard | **SHARED** | NAVIGABLE SCREEN | Offline UX Fallback | None (Local Storage) | **`[NEEDS CONFIRMATION]`** | `[N/A — LOCAL]` | Artboard exists; cache scope & duration undefined. |
| **SCR-18** | `Assignments` | Assignments Hub | **SHARED** | NAVIGABLE SCREEN | Ward Homework Monitoring List | `GET /api/assignments` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Filterable by status (Pending, Submitted, Graded). |
| **SCR-19** | `Assignment Details` | Assignment Details | **SHARED** | NAVIGABLE SCREEN | Homework Rubric & Due Date | `GET /api/assignments/:id` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Read-only for Parent. |
| **SCR-22** | `Teacher Feedback (Revised)`| Teacher Feedback | **SHARED** | NAVIGABLE SCREEN | Review Graded Remarks | `GET /api/assignments/:id` (eval payload)| **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Graded submission evaluation view. |
| **SCR-24** | `Learning Progress (New)` | Learning Progress | **SHARED** | NAVIGABLE SCREEN | Child Attendance Log & Rate | `GET /api/attendance/summary` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Progress ring and attendance history. |
| **SCR-26** | `Profile` | User Profile | **SHARED** | NAVIGABLE SCREEN | Account Details & Identity | `GET /api/students/:id` / Parent | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Read supported; editing requires mutation API. |
| **SCR-27** | `Messages` | Messages / Inquiries | **SHARED** | NAVIGABLE SCREEN | Direct Teacher Chat | `GET/POST /api/messages` | **`[OUT OF SCOPE]`** | `[BLOCKED — NO API]` | Excluded by PRD v1 freeze; no chat API exists. |
| **SCR-28** | `Notifications` | Notifications Feed | **SHARED** | NAVIGABLE SCREEN | In-App Alert Inbox | `GET /api/notifications/inbox` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Inbox feed with mark-as-read action. |
| **SCR-29** | `Security & Privacy` | Security & Privacy | **SHARED** | NAVIGABLE SCREEN | Password Change & Security | `POST /api/auth/change-password` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Bearer token required. |
| **SCR-30** | `Login Methods` | Login Methods | **SHARED** | NAVIGABLE SCREEN | Configured Login Options | `GET /api/auth/methods` | **`[BACKEND DEPENDENCY]`** | `[BLOCKED — NO API]` | Social auth not built in backend. |
| **SCR-31** | `Login & Devices` | Login & Devices | **SHARED** | NAVIGABLE SCREEN | Active Device Revocation | `GET/DELETE /api/auth/devices` | **`[BACKEND DEPENDENCY]`** | `[BLOCKED — NO API]` | Device session table unbuilt in backend. |
| **SCR-32** | `Invoices` | Invoices List | **PARENT** | NAVIGABLE SCREEN | Tuition Fee Ledger | `GET /api/finance/invoices` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Shows balance banner and invoice list. |
| **SCR-33** | `Invoice Detail` | Invoice Detail | **PARENT** | NAVIGABLE SCREEN | Itemized Fee & Tax Breakdown | `GET /api/finance/invoices/:id` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Line items, taxes, and payment trigger. |
| **SCR-34** | `Payment Successful` | Payment Successful | **OVERLAY** | SUCCESS STATE / DIALOG | Transaction Confirmation | `GET /api/finance/receipts` | **`[NEEDS CONFIRMATION]`** | `[NEEDS AUTH TEST]` | Receipt read exists; payment callback mechanism undefined. |
| **SCR-35** | `Hamburger Drawer — Default`| Hamburger Drawer | **OVERLAY** | DRAWER | Side Menu Global Navigation | None (UI Container) | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[N/A — UI SHELL]` | Global side navigation drawer overlay. |
| **SCR-36** | `Account Settings` | Account Settings | **SHARED** | NAVIGABLE SCREEN | Alert & Delivery Toggles | `GET /api/notifications/preferences` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[NEEDS AUTH TEST]` | Notification preferences toggles. |
| **SCR-37** | `Demo Booking (1 & 2)` | Demo Booking Form | **SHARED** | NAVIGABLE SCREEN | Prospective Trial Booking | `POST /api/public/lead` | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[RUNTIME VERIFIED]` | Public lead intake form verified 200 OK. |
| **SCR-38** | `Demo Booking 3 (Confirmed)`| Demo Booking Confirmed | **OVERLAY** | MODAL | Trial Booking Confirmation | None (UI State) | **`[READY FOR IMPLEMENTATION PLANNING]`** | `[N/A — UI STATE]` | Modal confirmation card on canvas. |

---

## 2. Mathematical Reconciliation & Classification Audit

### 2.1 Role Breakdown
* **`PARENT` (Parent-Only)**: **6 artifacts** (`SCR-06`, `SCR-08`, `SCR-09`, `SCR-11`, `SCR-32`, `SCR-33`)
* **`SHARED` (Both Parent & Student)**: **19 artifacts** (`SCR-01`, `SCR-02`, `SCR-03`, `SCR-04`, `SCR-13`, `SCR-14`, `SCR-17`, `SCR-18`, `SCR-19`, `SCR-22`, `SCR-24`, `SCR-26`, `SCR-27`, `SCR-28`, `SCR-29`, `SCR-30`, `SCR-31`, `SCR-36`, `SCR-37`)
* **`PARENT LEARNER/CHILD CONTEXT`**: **2 artifacts** (`SCR-05`, `SCR-07`)
* **`OVERLAY`**: **3 artifacts** (`SCR-34`, `SCR-35`, `SCR-38`)

$$\text{Role Check: } 6\ (\text{PARENT}) + 19\ (\text{SHARED}) + 2\ (\text{LEARNER/CHILD CONTEXT}) + 3\ (\text{OVERLAY}) = \mathbf{30\ Scoped\ Figma\ Artifacts}$$

### 2.2 UI-Type Breakdown
* **Navigable Full Screens**: **27 screens** (Pushed routes on navigation stack)
* **Modal / Drawer / Sheet / State Overlays**: **3 artifacts**
  * `SCR-34: Payment Successful` (Success state / dialog overlay on top of Invoice flow; no separate route)
  * `SCR-35: Hamburger Drawer — Default` (Side-sheet sliding navigation drawer container; not a pushed route)
  * `SCR-38: Demo Booking Confirmed` (Centered modal dialog card overlay on `/demo-booking`; not a pushed route)

$$\text{UI-Type Check: } 27\ (\text{Navigable Screens}) + 3\ (\text{Overlays}) = \mathbf{30\ Scoped\ Figma\ Artifacts}$$

### 2.3 Planning Status Breakdown
* **`[READY FOR IMPLEMENTATION PLANNING]`**: **20 artifacts** (18 Navigable Screens + 2 Overlays: `SCR-35`, `SCR-38`)
* **`[NEEDS CONFIRMATION]`**: **3 artifacts** (2 Navigable Screens: `SCR-05`, `SCR-17` + 1 Overlay: `SCR-34`)
* **`[BACKEND DEPENDENCY]`**: **6 artifacts** (6 Navigable Screens: `SCR-04`, `SCR-06`, `SCR-07`, `SCR-08`, `SCR-30`, `SCR-31`)
* **`[OUT OF SCOPE]`**: **1 artifact** (1 Navigable Screen: `SCR-27`)

$$\text{Status Check: } 20\ (\text{READY}) + 3\ (\text{NEEDS CONFIRMATION}) + 6\ (\text{BACKEND DEP}) + 1\ (\text{OUT OF SCOPE}) = \mathbf{30\ Artifacts}$$

### 2.4 Detailed Audit of SCR-05 (Student Interests)
- **Actor & Intake Sequence**: Located on canvas `Parent(full app)_TreLern` in Row 1, between `Verify Code` (SCR-04) and `Student Account Details` (SCR-06).
- **Design Content**: Screen header reads "Interests", subtitle states *"Choose the role/grade that matches your requirement and add details."* Contains dropdowns for grade ("Pre-Primary") and section.
- **Context Evidence**: Immediately followed by `Student Account Details` (which prompts for **"Parent Name"** and **"Your Full Name"**) and `Student Child Details` (which prompts for **"Child Name"**, **"Age"**, **"Grade"**).
- **Actor Conclusion**: The actor is the **Parent** setting up the account and specifying the **Learner/Child** educational interests.
- **Classification**: Classified as **`PARENT LEARNER/CHILD CONTEXT`**. Planning status remains **`[NEEDS CONFIRMATION]`** because no backend intake API exists in Postman and PRD does not establish mobile self-intake.

---

## 3. Remaining Unresolved Product Decisions (Strictly Preserved)

1. **Payment Execution Mechanism (`SCR-32`, `SCR-33`, `SCR-34`)**:
   - Figma establishes "Pay Balance" button and "Payment Successful" confirmation dialog.
   - Postman API contract provides `GET /api/finance/invoices/:id` (read) and `GET /api/finance/receipts` (read), but contains **no mobile payment gateway initiation endpoint**.
   - *Status*: **`[NEEDS CONFIRMATION]`** — Do NOT decide between web checkout redirect (`/api/auth/handoff`), Razorpay SDK, Stripe SDK, or native payment sheet without written client specification.
2. **Parent & Child Onboarding Ownership (`SCR-05` to `SCR-08`)**:
   - Figma Row 1 shows intake sequence collecting guardian details, child details, grade, and timezone.
   - PRD Section "Admissions" specifies that student admission and batch allocation follow counselor/CRM conversion.
   - Backend auth API provides no parent self-registration or self-linking endpoints.
   - *Status*: **`[NEEDS CONFIRMATION]`** — Confirm whether the mobile app supports open guardian sign-up and ward creation, or if parent accounts are strictly provisioned by admissions counselors.
3. **Offline Mode Specification (`SCR-17`)**:
   - Figma provides an `Offline Dashboard` artboard showing cached status.
   - PRD does not define offline data caching duration, storage size thresholds, or synchronized offline entities.
   - *Status*: **`[NEEDS CONFIRMATION]`** — Do NOT select Hive, SQLite, or cache expiration timers without approved requirements.
4. **Chat & Messaging (`SCR-27`)**:
   - Figma displays a `Messages` list screen.
   - PRD Section "Version 1 Exclusions" explicitly lists Discussion Forum / Chat as excluded from the v1 core freeze.
   - *Status*: **`[OUT OF SCOPE]`** — Remains excluded unless a formal Scope Change Request is approved.

---

## 4. Final Parent Governance Lock Status

```
============================================================
TRUELEARN AIO FLUTTER — GOVERNANCE GATE LOCK STATUS
============================================================
PARENT PHASE 1A:
[LOCKED — APPROVED PLANNING BASELINE]

PHASE 1B — STUDENT:
[NOT STARTED]

FLUTTER IMPLEMENTATION:
[NOT STARTED]

BACKEND IMPLEMENTATION:
[NOT STARTED]
============================================================
```
