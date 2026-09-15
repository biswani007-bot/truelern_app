# 16 — Parent Master Navigation Flow Architecture

> [!IMPORTANT]
> **GOVERNANCE & ARCHITECTURAL SCOPE**:
> This document details the complete navigation architecture for the **Parent Experience** within the unified TrueLern AIO Flutter application.
> Reconciled against:
> 1. Authoritative Figma Page: `Parent(full app)_TreLern` (Node Reference `69:2`)
> 2. TrueLern PRD Core Freeze (`docs/PRD.md`)
> 3. TrueLern Production API Contract (`docs/api/TrueLern-API.postman_collection.json`)

---

## 1. Parent Flow Lifecycle State Machine

The Parent experience navigates through five sequential architectural phases:

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────────┐
│ 1. Launch / Auth│ ──> │ 2. Child Context │ ──> │ 3. Parent Dashboard │
│ • Splash        │     │ • Multi-Ward Hub │     │ • Attendance %      │
│ • Login (JWT)   │     │ • Active Ward Sel│     │ • Next Live Class   │
│ • Token Refresh │     │ • Ward Switcher  │     │ • Assignments & Fees│
└─────────────────┘     └──────────────────┘     └──────────┬──────────┘
                                                            │
         ┌──────────────────────────────────────────────────┴────────────────────────────────┐
         │                                                                                   │
         ▼                                                                                   ▼
┌───────────────────────┐                                                   ┌─────────────────────────────────┐
│ 4. Primary Navigation │                                                   │ 5. Secondary & Deep Detail Flows│
│ • Dashboard Tab       │                                                   │ • Invoices & Receipts           │
│ • Classes / Timetable │                                                   │ • Invoice Itemized Breakdown    │
│ • Homework Center     │                                                   │ • Homework Review & Remarks     │
│ • Profile & Settings  │                                                   │ • Notifications Inbox           │
└───────────────────────┘                                                   │ • Hamburger Drawer Menu         │
                                                                            └─────────────────────────────────┘
```

---

## 2. Detailed Navigation Flows

### 2.1 Launch & Authentication Flow
1. **App Bootstrap (`SCR-01: Splash Screen`)**:
   - Checks backend maintenance via `GET /api/v1/public/portal-config?portalId=student-portal`.
   - Reads secure storage for cached JWT `accessToken` and `refreshToken`.
   - **Branch A**: No valid token found → Pushes `SCR-03: Login Screen`.
   - **Branch B**: Valid token present + User role `PARENT` → Fetches `GET /api/parent/children` → Transitions directly to `SCR-09: Parent Dashboard`.
2. **Parent Login (`SCR-03: Login Screen`)**:
   - User enters email and password.
   - Submits `POST /api/auth/login`.
   - *Current Blocker*: Returns `HTTP 500 INTERNAL_SERVER_ERROR` on production. Authenticated runtime testing blocked.
   - On success: Persists JWT tokens in secure storage. Validates `user.role == 'PARENT'`.
   - Routes to **Child Context Initialization**.

### 2.2 Child Context Selection & Switching Flow
The Parent application fundamentally operates in the context of an **Active Selected Child** (`childStudentId`):
1. **Initialization (`SCR-11: My Children Hub`)**:
   - Invokes `GET /api/parent/children`.
   - If parent has **1 child**: Automatically sets this child as active context and proceeds to Dashboard.
   - If parent has **multiple children**: Checks local storage for `last_active_child_id`. If none, defaults to `children[0]`.
2. **Context Switching**:
   - Accessible via:
     - Top App Bar child avatar badge on `SCR-09: Parent Dashboard`.
     - "My Children" item in the `Hamburger Drawer`.
   - Tapping an inactive child executes `setActiveChild(studentId)`.
   - Invalidates all downstream Riverpod providers (`parentDashboardProvider`, `childAttendanceProvider`, `childFinanceProvider`).
   - Reloads Dashboard with smooth UI transition.
3. **Add New Child (`SCR-07: Child Details Setup`)**:
   - Design shows an "+ Add Child" button at the bottom of `My Children`.
   - `[BACKEND DEPENDENCY]`: Postman API contract only has `GET /api/parent/children`. No mobile self-registration or self-linking endpoint exists. Flow must remain disabled until backend implements `POST /api/parent/children`.

### 2.3 Primary Bottom Navigation Architecture
When in authenticated Parent context, the shell displays the persistent 4-tab bottom navigation bar:
- **Tab 1: Dashboard (`SCR-09: Parent Dashboard`)**:
  - Top header: Active child picker avatar + "Hi, Parent! Let's check on [Child Name]'s learning".
  - Hero card: Next live class countdown with child batch topic and "Join Live Class" indicator.
  - Metrics row: Attendance Percentage ring (`94%`), Enrolled Modules completed.
  - Active tasks card: Pending assignments count with due date urgency badges.
  - Financial alert banner: Outstanding tuition balance with quick "Pay Balance" button.
- **Tab 2: Classes / Timetable (`SCR-13: My Classes`)**:
  - Synchronous cohort timetable filtered for the active child's enrolled batch (`GET /api/live-classes`).
  - Allows parent to see schedule, teacher names, and session status (`COMPLETED`, `UPCOMING`, `LIVE`).
  - Tapping a class pushes `SCR-14: Class Details`.
- **Tab 3: Assignments (`SCR-18: Assignments Hub`)**:
  - Filterable by `Pending`, `Submitted`, and `Graded`.
  - Shows child's homework submissions.
  - Tapping an item pushes `SCR-19: Assignment Details` or `SCR-22: Teacher Feedback`.
- **Tab 4: Profile / Settings (`SCR-26: User Profile`)**:
  - Parent account details, linked children count, and security controls.

### 2.4 Financial & Billing Deep Navigation Flow
1. **Invoice Overview (`SCR-32: Invoices List`)**:
   - Triggered from Dashboard "Total Balance Due" card or Hamburger Drawer "Invoices & Fees".
   - Calls `GET /api/finance/invoices?limit=10` and `GET /api/parent/children/:id/finance`.
   - Top card: Big balance banner (`$299.00 Total Balance Due`).
   - Filter tabs: `All`, `Unpaid`, `Paid`.
   - Tapping any invoice row pushes `SCR-33: Invoice Detail`.
2. **Itemized Invoice Detail (`SCR-33: Invoice Detail`)**:
   - Calls `GET /api/finance/invoices/:id`.
   - Displays itemized breakdown: Tuition Fee, Tech Support Fee, Taxes (GST/VAT), Total Amount.
   - Due date countdown.
   - Primary CTA: "Pay Balance".
   - Secondary CTA: "Download PDF Invoice".
3. **Payment Checkout & Confirmation (`SCR-34: Payment Successful`)**:
   - In accordance with PRD and API contracts, payment on mobile is routed via web checkout or `GET /api/auth/handoff`.
   - On successful transaction callback: Navigates to `SCR-34: Payment Successful`.
   - Displays animated green checkmark, Transaction ID, amount paid, and "View Receipt" CTA.

### 2.5 Secondary Menus & Drawer Flows
1. **Hamburger Drawer (`SCR-35: Hamburger Drawer — Default`)**:
   - Opens via left menu button on top app bar.
   - Drawer Header: Guardian Avatar, Full Name, Email.
   - Quick Child Switcher: Horizontal avatar list of linked wards.
   - Destination Items:
     - Dashboard (`/parent/dashboard`)
     - My Children (`/parent/children`)
     - Classes & Timetable (`/classes`)
     - Assignments (`/assignments`)
     - Invoices & Fees (`/finance/invoices`)
     - In-App Messages `[BACKEND DEPENDENCY — Excluded from PRD v1]`
     - Notifications (`/notifications`)
     - Account Settings (`/settings/account`)
     - Security & Privacy (`/settings/security`)
   - Drawer Footer:
     - "Log Out" button: Calls `POST /api/auth/logout`, clears tokens, and pushes `/login`.

### 2.6 Account Security & Device Management Flows
- **Security & Privacy (`SCR-29`)**: Change password via `POST /api/auth/change-password`.
- **Login Methods (`SCR-30`)**: `[BACKEND DEPENDENCY — Social logins not in API]`.
- **Login & Devices (`SCR-31`)**: `[BACKEND DEPENDENCY — Active session revocation API not in API]`.

---

## 3. Session Expiration & Refresh Flow

1. Every HTTP request automatically passes through the `AuthInterceptor`.
2. When the backend returns `401 Unauthorized`:
   - Interceptor pauses queued requests.
   - Attempts token refresh via `POST /api/auth/refresh` using the secure `refreshToken`.
   - If refresh succeeds: Replays queued requests with new `accessToken`.
   - If refresh fails (or returns 401/403):
     - Clears secure storage.
     - Displays session expiration toast: `"Session expired. Please log in again."`
     - Pushes `SCR-03: Login Screen` clearing navigation stack.
