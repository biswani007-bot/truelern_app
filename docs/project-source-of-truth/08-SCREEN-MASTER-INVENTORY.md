# 08 — Screen Master Inventory (Parent Scope Reconciliation)

> [!IMPORTANT]
> **GOVERNANCE & AUDIT SOURCE**:
> This inventory reconciles candidate screens against actual frames and layers inspected on the authoritative Figma page:
> - **Figma File**: `TrueLern` (File Key: `CiZoTN0EnITFG3e7SFwXrU`)
> - **Primary Page**: `Parent(full app)_TreLern` (Figma Node Reference: `69:2`)
> - **API Source**: `https://truelern.visital.in/api` (`docs/api/TrueLern-API.postman_collection.json`)
> - **PRD Source**: Frozen Core PRD (`docs/PRD.md`)
>
> **UI Type Distinction**: Screens that are modal dialogs, drawers, or state overlays are explicitly tagged to prevent generating unnecessary Flutter routes.

---

## Screen Inventory Table (Parent Scope & Shared Utilities)

| ID | Screen Name | Role | Actual Figma Source / Name | UI Type | Navigable Route | Functional Purpose | API Required | API Status | Planning Readiness | Runtime Status |
|---|---|:---:|---|:---:|:---:|---|---|:---:|:---:|:---:|
| **SCR-01** | Splash Screen | **SHARED** | `Splash Screen` | NAVIGABLE SCREEN | `/splash` | App bootstrap & version check | `GET /api/v1/public/portal-config` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[RUNTIME VERIFIED]` |
| **SCR-02** | Onboarding Intro | **SHARED** | `Onboarding (1, 2, 3)` | NAVIGABLE SCREEN | `/onboarding` | Cohort value proposition carousel | None (Static) | None | `[READY FOR IMPLEMENTATION PLANNING]` | `[N/A — STATIC]` |
| **SCR-03** | Login Screen | **SHARED** | `Student/Parent Login` | NAVIGABLE SCREEN | `/login` | Primary email/password authentication | `POST /api/auth/login` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | **`[BLOCKED — LOGIN 500]`** |
| **SCR-04** | Verify Code (OTP) | **SHARED** | `Student/Parent Verify Code` | NAVIGABLE SCREEN | `/verify-code` | Phone 2FA verification code input | `POST /api/auth/otp/verify` | `[BACKEND DEPENDENCY]` | `[BACKEND DEPENDENCY]` | `[BLOCKED — NO API]` |
| **SCR-05** | Interests Setup | **PARENT LEARNER/CHILD CONTEXT** | `Student Interests` | NAVIGABLE SCREEN | `/onboarding/interests` | Learner grade and subject intake | None in Collection | None | `[NEEDS CONFIRMATION]` | `[BLOCKED — NO API]` |
| **SCR-06** | Account Details | **PARENT** | `Student Account Details` | NAVIGABLE SCREEN | `/onboarding/account` | Guardian contact info setup | `PUT /api/parent/profile` | `[BACKEND DEPENDENCY]` | `[BACKEND DEPENDENCY]` | `[BLOCKED — NO API]` |
| **SCR-07** | Child Details Setup | **PARENT LEARNER/CHILD CONTEXT** | `Student Child Details` | NAVIGABLE SCREEN | `/onboarding/child-details` | Ward profile registration / linking | `POST /api/parent/children` | `[BACKEND DEPENDENCY]` | `[BACKEND DEPENDENCY]` | `[BLOCKED — NO API]` |
| **SCR-08** | Almost Ready / Location | **PARENT** | `Student Almost Ready` | NAVIGABLE SCREEN | `/onboarding/location` | Timezone selection for class times | `PUT /api/parent/timezone` | `[BACKEND DEPENDENCY]` | `[BACKEND DEPENDENCY]` | `[BLOCKED — NO API]` |
| **SCR-09** | Parent Dashboard | **PARENT** | `Parent Dashboard` | NAVIGABLE SCREEN | `/parent/dashboard` | Active ward learning metrics hub | `GET /api/parent/children/:id/dashboard` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-11** | My Children Hub | **PARENT** | `My Children` | NAVIGABLE SCREEN | `/parent/children` | Multi-ward directory & switcher | `GET /api/parent/children` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-13** | My Classes / Timetable | **SHARED** | `Class Schedule` | NAVIGABLE SCREEN | `/classes` | Child cohort live class schedule | `GET /api/live-classes` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-14** | Class Details | **SHARED** | `Class Details` | NAVIGABLE SCREEN | `/classes/:id` | Class agenda, instructor info | `GET /api/live-classes/:id` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-17** | Offline Dashboard | **SHARED** | `Offline Dashboard` | NAVIGABLE SCREEN | `/offline` | Cached offline fallback display | None (Local Storage) | None | `[NEEDS CONFIRMATION]` | `[N/A — LOCAL]` |
| **SCR-18** | Assignments Hub | **SHARED** | `Assignments` | NAVIGABLE SCREEN | `/assignments` | Child homework monitoring list | `GET /api/assignments` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-19** | Assignment Details | **SHARED** | `Assignment Details` | NAVIGABLE SCREEN | `/assignments/:id` | Homework rubric & due date | `GET /api/assignments/:id` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-22** | Teacher Feedback | **SHARED** | `Teacher Feedback (Revised)`| NAVIGABLE SCREEN | `/assignments/:id/feedback` | Graded marks and teacher comments | `GET /api/assignments/:id` (eval payload)| `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-24** | Learning Progress | **SHARED** | `Learning Progress (New)` | NAVIGABLE SCREEN | `/progress` | Attendance percentage & log | `GET /api/attendance/summary` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-26** | User Profile | **SHARED** | `Profile` | NAVIGABLE SCREEN | `/profile` | Account overview & user identity | `GET /api/students/:id` / Parent | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-27** | Messages / Inquiries | **SHARED** | `Messages` | NAVIGABLE SCREEN | `[BLOCKED]` | Direct 1-on-1 teacher inquiry | `GET/POST /api/messages` | `[PRD CONFLICT]` | `[OUT OF SCOPE]` | `[BLOCKED — NO API]` |
| **SCR-28** | Notifications Feed | **SHARED** | `Notifications` | NAVIGABLE SCREEN | `/notifications` | In-app alerts and announcements | `GET /api/notifications/inbox` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-29** | Security & Privacy | **SHARED** | `Security & Privacy` | NAVIGABLE SCREEN | `/settings/security` | Password change & security preferences | `POST /api/auth/change-password` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-30** | Login Methods | **SHARED** | `Login Methods` | NAVIGABLE SCREEN | `/settings/login-methods`| Configured login/social options | `GET /api/auth/methods` | `[BACKEND DEPENDENCY]` | `[BACKEND DEPENDENCY]` | `[BLOCKED — NO API]` |
| **SCR-31** | Login & Devices | **SHARED** | `Login & Devices` | NAVIGABLE SCREEN | `/settings/devices` | Active device token revocation | `GET/DELETE /api/auth/devices` | `[BACKEND DEPENDENCY]` | `[BACKEND DEPENDENCY]` | `[BLOCKED — NO API]` |
| **SCR-32** | Invoices List | **PARENT** | `Invoices` | NAVIGABLE SCREEN | `/finance/invoices` | Tuition fee statement & balance | `GET /api/finance/invoices` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-33** | Invoice Detail | **PARENT** | `Invoice Detail` | NAVIGABLE SCREEN | `/finance/invoices/:id` | Itemized tuition fees & payment trigger | `GET /api/finance/invoices/:id` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-34** | Payment Successful | **OVERLAY** | `Payment Successful` | SUCCESS STATE / DIALOG | `NO (DIALOG OVERLAY)`| Tuition payment confirmation card | `GET /api/finance/receipts` | `[VERIFIED]` | `[NEEDS CONFIRMATION]` | `[NEEDS AUTH TEST]` |
| **SCR-35** | Hamburger Drawer | **OVERLAY** | `Hamburger Drawer — Default`| DRAWER OVERLAY | `NO (DRAWER SHELL)` | Side navigation menu container | None (UI Container) | None | `[READY FOR IMPLEMENTATION PLANNING]` | `[N/A — UI SHELL]` |
| **SCR-36** | Account Settings | **SHARED** | `Account Settings` | NAVIGABLE SCREEN | `/settings/account` | Alert and notification toggles | `GET /api/notifications/preferences` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[NEEDS AUTH TEST]` |
| **SCR-37** | Demo Booking Form | **SHARED** | `Demo Booking (1 & 2)` | NAVIGABLE SCREEN | `/demo-booking` | Prospective trial class booking form | `POST /api/public/lead` | `[VERIFIED]` | `[READY FOR IMPLEMENTATION PLANNING]` | `[RUNTIME VERIFIED]` |
| **SCR-38** | Demo Booking Confirmed | **OVERLAY** | `Demo Booking 3 (Confirmed)`| MODAL OVERLAY | `NO (MODAL CARD)` | Trial booking confirmation card | None (UI State) | None | `[READY FOR IMPLEMENTATION PLANNING]` | `[N/A — UI STATE]` |
