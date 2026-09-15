# 18 — Parent Flutter Implementation Blueprint (Phase 1A Planning Only)

> [!IMPORTANT]
> **STRICT PLANNING GOVERNANCE BASELINE — ZERO IMPLEMENTATION ENFORCEMENT**:
> This document serves as the authoritative, engineering-grade **Implementation Blueprint** for the **Parent Experience (Phase 1A)** of the TrueLern unified AIO mobile application.
> - **Status**: `[COMPLETED — PLANNING ONLY]`
> - **Flutter Code**: `[NOT STARTED]` (No Dart files, widgets, routes, models, or pubspec edits exist or are authorized).
> - **Backend Code**: `[NOT STARTED]` (No backend changes, API inventions, or schema changes).
> - **Student Phase 1B**: `[NOT STARTED]` (Quarantined for subsequent phase).
> - **Authoritative API Base**: `https://truelern.visital.in/api` (`docs/api/TrueLern-API.postman_collection.json`). *The obsolete domain `360api.vnvision.in` is forbidden.*
> - **Locked Planning Baseline**: 30 Parent Artifacts (6 `PARENT`, 19 `SHARED`, 2 `PARENT LEARNER/CHILD CONTEXT`, 3 `OVERLAY` | 27 Navigable Screens, 3 Overlays | 20 Ready for Implementation Planning, 3 Needs Confirmation, 6 Backend Dependency, 1 Out of Scope).

---

## 1. Readiness & Implementation Boundary Standard

To maintain strict engineering integrity, three distinct readiness tiers are enforced throughout this blueprint:

1. **`PLANNING READY`**: The design artifact is identified, UX flow is established, functional PRD relationship is verified, and required API contract exists in the Postman collection (or item is purely static/client-side). Implementation planning is unblocked.
2. **`IMPLEMENTATION READY`**: All design tokens, exportable assets, widget layouts, data contracts, and dependency prerequisites are physically available to write code without making assumptions or inventing contracts.
3. **`RUNTIME VERIFIED`**: The implemented Flutter feature has been compiled, executed on an Android physical/virtual device, and validated end-to-end against live backend responses from `https://truelern.visital.in/api`.

> [!WARNING]
> **Hard Principle**: *Contract verification does NOT equal runtime verification.*
> While 20 artifacts are `[READY FOR IMPLEMENTATION PLANNING]`, authenticated runtime execution remains strictly **`[BLOCKED — PRODUCTION LOGIN HTTP 500]`**. No bypasses, fake JWTs, or mock logins are permitted.

---

## 2. Screen-by-Screen Master Implementation Blueprint (30 Artifacts)

The following table establishes the definitive, artifact-by-artifact implementation blueprint for all 30 Parent-scoped Figma items.

| ID | Figma Node | Screen / Artifact | Role | UI Type | Navigation Entry | Figma Reference | API Dependency | Request/Data Contract | Required States | Child Context | Dependencies | Implementation Readiness | Runtime Gate |
|---|---|---|:---:|:---:|---|---|---|---|---|:---:|---|:---:|:---:|
| **SCR-01** | `Splash Screen` | Splash Screen | **SHARED** | NAVIGABLE SCREEN | App Launch / Bootstrap | `69:2` Row 1 Frame 1 | `GET /api/v1/public/portal-config` | Query: `portalId=student-portal` | Initial, Loading, Error, Retry, Loaded | Not Required | Local secure storage token check | `PLANNING READY` | `[RUNTIME VERIFIED]` |
| **SCR-02** | `Onboarding (1, 2, 3)` | Onboarding Intro | **SHARED** | NAVIGABLE SCREEN | Post-Splash (if first run) | `69:2` Row 1 Frame 2 | None (Static presentation) | N/A | Initial, Loaded | Not Required | `SharedPreferences` onboarding flag | `PLANNING READY` | `[N/A — STATIC]` |
| **SCR-03** | `Student/Parent Login` | Login Screen | **SHARED** | NAVIGABLE SCREEN | Post-Splash / Unauthenticated | `69:2` Row 1 Frame 3 | `POST /api/auth/login` | Body: `{ email, password }` | Initial, Loading, Loaded, Error | Not Required | Secure keystore token storage | `PLANNING READY` | **`[BLOCKED — LOGIN 500]`** |
| **SCR-04** | `Student/Parent Verify Code` | Verify Code (OTP) | **SHARED** | NAVIGABLE SCREEN | Push from Login/Register | `69:2` Row 1 Frame 4 | `POST /api/auth/otp/verify` | Missing in contract | Initial, Loading, Error, Retry | Not Required | Backend SMS/Email OTP service | `BACKEND DEPENDENCY` | `[BLOCKED — NO API]` |
| **SCR-05** | `Student Interests` | Interests Setup | **PARENT LEARNER/CHILD CONTEXT** | NAVIGABLE SCREEN | Onboarding Step 5 | `69:2` Row 1 Frame 5 | None in contract | Missing in contract | Initial, Loading, Loaded, Error | **Learner Context Input** | Intake workflow specification | `NEEDS CONFIRMATION` | `[BLOCKED — NO API]` |
| **SCR-06** | `Student Account Details` | Account Details | **PARENT** | NAVIGABLE SCREEN | Onboarding Step 6 | `69:2` Row 1 Frame 6 | `PUT /api/parent/profile` | Missing in contract | Initial, Loading, Loaded, Error | Not Required | Backend profile mutation endpoint | `BACKEND DEPENDENCY` | `[BLOCKED — NO API]` |
| **SCR-07** | `Student Child Details` | Child Details Setup | **PARENT LEARNER/CHILD CONTEXT** | NAVIGABLE SCREEN | Onboarding Step 7 | `69:2` Row 1 Frame 7 | `POST /api/parent/children` | Missing in contract | Initial, Loading, Loaded, Error | **Child Registration** | Backend ward creation endpoint | `BACKEND DEPENDENCY` | `[BLOCKED — NO API]` |
| **SCR-08** | `Student Almost Ready` | Almost Ready / Location | **PARENT** | NAVIGABLE SCREEN | Onboarding Step 8 | `69:2` Row 1 Frame 8 | `PUT /api/parent/timezone` | Missing in contract | Initial, Loading, Loaded, Error | Not Required | Backend timezone mutation API | `BACKEND DEPENDENCY` | `[BLOCKED — NO API]` |
| **SCR-09** | `Parent Dashboard` | Parent Dashboard | **PARENT** | NAVIGABLE SCREEN | Main Shell: Tab 1 | `69:2` Row 2 Frame 1 | `GET /api/parent/children/:id/dashboard` | Path: `:childStudentId` | Initial, Loading, Loaded, Error, Retry, No child, Active child | **MANDATORY CONTEXT** | Valid active child ID from SCR-11 | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-11** | `My Children` | My Children Hub | **PARENT** | NAVIGABLE SCREEN | App Bar Switcher / Drawer | `69:2` Row 2 Frame 3 | `GET /api/parent/children` | Bearer Token | Initial, Loading, Loaded, Empty (No child), Multiple children, Error | **Context Provider** | Auth session | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-13** | `Class Schedule` | My Classes / Timetable | **SHARED** | NAVIGABLE SCREEN | Main Shell: Tab 2 | `69:2` Row 2 Frame 4 | `GET /api/live-classes` | Query: `sort=startDate&order=asc` | Initial, Loading, Loaded, Empty (No classes), Error, Retry | **FILTER CONTEXT** | Filtered by active child cohort | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-14** | `Class Details` | Class Details | **SHARED** | NAVIGABLE SCREEN | Push from SCR-13 card | `69:2` Row 2 Frame 5 | `GET /api/live-classes/:id` | Path: `:liveClassId` | Initial, Loading, Loaded, Error, Retry | Filtered by Child | Valid `liveClassId` | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-17** | `Offline Dashboard` | Offline Dashboard | **SHARED** | NAVIGABLE SCREEN | Auto-fallback on network drop | `69:2` Row 2 Frame 8 | None (Local SQLite/Hive) | Local cached DTOs | Initial, Loaded, Offline, Retry | Cached Context | Caching specification & scope | `NEEDS CONFIRMATION` | `[N/A — LOCAL]` |
| **SCR-18** | `Assignments` | Assignments Hub | **SHARED** | NAVIGABLE SCREEN | Main Shell: Tab 3 | `69:2` Row 2 Frame 9 | `GET /api/assignments` | Query: `status=pending|submitted|graded` | Initial, Loading, Loaded, Empty, Error, Retry | **FILTER CONTEXT** | Filtered by active child | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-19** | `Assignment Details` | Assignment Details | **SHARED** | NAVIGABLE SCREEN | Push from SCR-18 card | `69:2` Row 2 Frame 10 | `GET /api/assignments/:id` | Path: `:assignmentId` | Initial, Loading, Loaded, Error, Retry | Filtered by Child | Valid `assignmentId` | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-22** | `Teacher Feedback (Revised)`| Teacher Feedback | **SHARED** | NAVIGABLE SCREEN | Push from SCR-19 graded | `69:2` Row 2 Frame 12 | `GET /api/assignments/:id` | Path: `:assignmentId` (eval payload) | Initial, Loading, Loaded, Empty, Error | Filtered by Child | Evaluated homework submission | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-24** | `Learning Progress (New)` | Learning Progress | **SHARED** | NAVIGABLE SCREEN | Push from SCR-09 widget | `69:2` Row 2 Frame 14 | `GET /api/attendance/summary` | Query: `student={{studentId}}` | Initial, Loading, Loaded, Error, Retry | **MANDATORY CONTEXT** | Active child student ID | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-26** | `Profile` | User Profile | **SHARED** | NAVIGABLE SCREEN | Main Shell: Tab 5 / Drawer | `69:2` Row 3 Frame 1 | `GET /api/students/:id` / Parent | Bearer Token | Initial, Loading, Loaded, Error | Not Required | Active auth session | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-27** | `Messages` | Messages / Inquiries | **SHARED** | NAVIGABLE SCREEN | [BLOCKED — OUT OF SCOPE] | `69:2` Row 3 Frame 2 | `GET/POST /api/messages` | Missing in contract | Initial, Error | Not Required | PRD v1 freeze exclusion | `OUT OF SCOPE` | `[BLOCKED — NO API]` |
| **SCR-28** | `Notifications` | Notifications Feed | **SHARED** | NAVIGABLE SCREEN | App Bar Bell Icon | `69:2` Row 3 Frame 3 | `GET /api/notifications/inbox` | Query: `limit=20&page=1` | Initial, Loading, Loaded, Empty, Error, Retry | Not Required | Bearer Token | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-29** | `Security & Privacy` | Security & Privacy | **SHARED** | NAVIGABLE SCREEN | Push from SCR-26 Settings | `69:2` Row 3 Frame 4 | `POST /api/auth/change-password` | Body: `{ oldPassword, newPassword }`| Initial, Loading, Loaded, Error | Not Required | Bearer Token | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-30** | `Login Methods` | Login Methods | **SHARED** | NAVIGABLE SCREEN | Push from SCR-29 | `69:2` Row 3 Frame 5 | `GET /api/auth/methods` | Missing in contract | Initial, Loading, Loaded, Error | Not Required | Backend social OAuth integration | `BACKEND DEPENDENCY` | `[BLOCKED — NO API]` |
| **SCR-31** | `Login & Devices` | Login & Devices | **SHARED** | NAVIGABLE SCREEN | Push from SCR-29 | `69:2` Row 3 Frame 6 | `GET/DELETE /api/auth/devices` | Missing in contract | Initial, Loading, Loaded, Error | Not Required | Backend device session store | `BACKEND DEPENDENCY` | `[BLOCKED — NO API]` |
| **SCR-32** | `Invoices` | Invoices List | **PARENT** | NAVIGABLE SCREEN | Main Shell: Tab 4 / Drawer | `69:2` Row 3 Frame 7 | `GET /api/finance/invoices` | Query: `limit=10` | Initial, Loading, Loaded, Empty, Error, Retry | **FILTER CONTEXT** | Filterable by child context | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-33** | `Invoice Detail` | Invoice Detail | **PARENT** | NAVIGABLE SCREEN | Push from SCR-32 item | `69:2` Row 3 Frame 8 | `GET /api/finance/invoices/:id` | Path: `:invoiceId` | Initial, Loading, Loaded, Error, Retry | Context Bound | Valid `invoiceId` | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-34** | `Payment Successful` | Payment Successful | **OVERLAY** | SUCCESS STATE / DIALOG | Dialog on SCR-33 completion | `69:2` Row 3 Frame 9 | `GET /api/finance/receipts` | Query: `limit=10` | Initial, Loaded, Error | Context Bound | Payment callback verification | `NEEDS CONFIRMATION` | `[NEEDS AUTH TEST]` |
| **SCR-35** | `Hamburger Drawer — Default`| Hamburger Drawer | **OVERLAY** | DRAWER | App Bar Leading Hamburger | `69:2` Row 3 Frame 10 | None (UI Container) | N/A | Initial, Loaded, Active child selected | **Displays Child Switcher**| Parent UI Shell Controller | `PLANNING READY` | `[N/A — UI SHELL]` |
| **SCR-36** | `Account Settings` | Account Settings | **SHARED** | NAVIGABLE SCREEN | Push from Drawer / Settings | `69:2` Row 3 Frame 11 | `GET /api/notifications/preferences` | Bearer Token | Initial, Loading, Loaded, Error | Not Required | Bearer Token | `PLANNING READY` | `[NEEDS AUTH TEST]` |
| **SCR-37** | `Demo Booking (1 & 2)` | Demo Booking Form | **SHARED** | NAVIGABLE SCREEN | Public Flow / Drawer Link | `69:2` Row 3 Frame 12 | `POST /api/public/lead` | Body: `{ fullName, email, phone... }` | Initial, Loading, Loaded, Error | Not Required | Public network access | `PLANNING READY` | `[RUNTIME VERIFIED]` |
| **SCR-38** | `Demo Booking 3 (Confirmed)`| Demo Booking Confirmed | **OVERLAY** | MODAL | Modal on SCR-37 200 OK | `69:2` Row 3 Frame 13 | None (UI State Card) | Payload from SCR-37 `leadId` | Loaded | Not Required | Successful lead submission | `PLANNING READY` | `[N/A — UI STATE]` |

---

## 3. UI State Blueprint & Behavioral Specifications

For data-driven Parent screens, the user interface will cycle through specific, justified states:

```
[Initial] ──► [Loading (Shimmer/Spinner)] ──► [Loaded (Content Presentation)]
                     │                                 │
                     ▼                                 ▼
              [Error Banner/Card]            [Empty State Presentation]
                     │
                     ▼
          [Retry Action Button]
```

### 3.1 State Behavioral Mapping

1. **`Initial State`**:
   - Controller/Notifier is instantiated. Local storage/tokens are queried.
   - Screen renders empty themed background scaffold with standard app bar to prevent layout jarring.
2. **`Loading State`**:
   - Full screen skeleton shimmer matching card geometries (e.g. 3 assignment cards for SCR-18, metric metric card grids for SCR-09).
   - Interactive controls (buttons, inputs) are disabled with opacity `0.6` to prevent duplicate submissions.
3. **`Loaded State`**:
   - Real data rendered into theme-compliant components with smooth fade transition (`200ms ease-in`).
   - Pull-to-refresh (`RefreshIndicator`) activated for on-demand sync.
4. **`Empty State`**:
   - Displayed when the endpoint returns an empty array (`[]`) or zero metrics.
   - Must render a curated SVG illustration, a bold title (e.g. *"No Upcoming Classes"*), a subtle supporting description, and where applicable an action button (e.g. *"Browse Courses"*).
5. **`Error State`**:
   - Network failure, timeout, or HTTP 4xx/5xx responses render a user-friendly error card rather than raw technical exception text.
   - Displays clear error message (e.g. *"Unable to load class schedule"*).
6. **`Retry State / Action`**:
   - An explicit "Try Again" button executes the Riverpod provider refresh (`ref.invalidate(...)`).
7. **`No Child / Multiple Children / Active Child States`**:
   - Detailed in Section 4 below.
8. **`Offline State`**:
   - Displayed *only* when network drops on cached-capable screens (`SCR-17`). Displays persistent top banner: *"You are offline. Showing cached data from [Timestamp]"*.

---

## 4. Parent Child-Context Blueprint

The Parent experience is structurally hierarchical: a single guardian account oversees one or more enrolled children.

```
┌────────────────────────────────────────────────────────┐
│                   GUARDIAN ACCOUNT                     │
│               (Authenticated Session)                  │
└──────────────────────────┬─────────────────────────────┘
                           │
             ┌─────────────┴─────────────┐
             ▼                           ▼
    ┌─────────────────┐         ┌─────────────────┐
    │  Child A (Ward) │         │  Child B (Ward) │
    │ studentId: 101  │         │ studentId: 102  │
    └────────┬────────┘         └────────┬────────┘
             │ (Active Context)
             ▼
 ┌────────────────────────────────────────────────────────┐
 │                   PARENT PERSPECTIVE                   │
 │  - SCR-09 Dashboard (Metrics for Child A)              │
 │  - SCR-13 Class Schedule (Timetable for Child A)       │
 │  - SCR-18 Assignments (Homework for Child A)           │
 │  - SCR-24 Progress & Attendance (Logs for Child A)     │
 │  - SCR-32 Invoices (Tuition Ledger for Child A)        │
 └────────────────────────────────────────────────────────┘
```

### 4.1 Child Context Rules & Verification

1. **Context Establishment**:
   - Post-authentication, the app triggers `GET /api/parent/children`.
   - The returned array contains linked wards: `[ { studentId, firstName, lastName, avatar, grade } ]`.
   - The app stores the list in `parentChildrenProvider` and sets `activeChildIdProvider` to `data[0].studentId` by default.
2. **Context Selectors in UI**:
   - **App Bar Switcher**: A dropdown chip in the top app bar displaying the child's avatar, first name, and a downward chevron (`SCR-09`, `SCR-11`, `SCR-13`, `SCR-18`).
   - **Hamburger Drawer**: A dedicated child switcher card at the top of `SCR-35` showing all linked children with checkmarks.
3. **Context-Dependent Screens**:
   - `SCR-09: Parent Dashboard` (`/api/parent/children/:childStudentId/dashboard`)
   - `SCR-13: Class Schedule` (Filtered by cohort of active child)
   - `SCR-18: Assignments` (Filtered by active child enrollment)
   - `SCR-24: Learning Progress` (`/api/attendance/summary?student={{childStudentId}}`)
   - `SCR-32: Invoices` (Filtered by active child tuition fee records)
4. **Zero Children State (`No Child`)**:
   - If `GET /api/parent/children` returns an empty array, the dashboard locks tabs and renders an onboarding prompt: *"No ward linked. Contact your admissions counselor or tap below."*
   - Note: Self-linking via mobile (`SCR-07`) is currently blocked by missing `POST /api/parent/children` endpoint.
5. **Context Switch Propagation**:
   - Updating `activeChildIdProvider` automatically triggers cascade invalidation of all dependent family providers via Riverpod, guaranteeing zero stale data leakage across siblings.

---

## 5. Navigation Blueprint & Routing Hierarchy

The application navigation architecture enforces strict hierarchy based on [16-PARENT-MASTER-NAVIGATION-FLOW.md](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/16-PARENT-MASTER-NAVIGATION-FLOW.md):

```
                       [SCR-01 Splash]
                              │
               ┌──────────────┴──────────────┐
               ▼ (First Run)                 ▼ (Unauthenticated)
     [SCR-02 Onboarding]            [SCR-03 Login]
               │                             │
               └──────────────┬──────────────┘
                              │ (Auth Success)
                              ▼
                [Parent Main Shell (Stateful)]
                 ├── Bottom Nav Tab 1: [SCR-09 Dashboard] ──► [SCR-24 Progress]
                 ├── Bottom Nav Tab 2: [SCR-13 Timetable] ──► [SCR-14 Details]
                 ├── Bottom Nav Tab 3: [SCR-18 Assignments] ──► [SCR-19 Details] ──► [SCR-22 Feedback]
                 ├── Bottom Nav Tab 4: [SCR-32 Invoices] ──► [SCR-33 Invoice Detail] ──► [SCR-34 Dialog Overlay]
                 └── Bottom Nav Tab 5: [SCR-26 Profile] ──► [SCR-29 Security] ──► [SCR-30 / SCR-31]
                              │
               ┌──────────────┴──────────────┐
               ▼                             ▼
   [SCR-35 Hamburger Drawer]      [SCR-28 Notifications Inbox]
   (Slides from leading edge)     (Pushed from top app bar)
```

### 5.1 Route Hierarchy Specifications

- **Splash (`SCR-01`)**: Launch entry point. Exit: Routes to `/login` or `/parent/dashboard` based on token presence.
- **Login (`SCR-03`)**: Replaces history. Back button exits app.
- **Main Shell**: Persistent bottom navigation bar with 5 primary tabs:
  - Tab 1: `/parent/dashboard` (`SCR-09`)
  - Tab 2: `/classes` (`SCR-13`)
  - Tab 3: `/assignments` (`SCR-18`)
  - Tab 4: `/finance/invoices` (`SCR-32`)
  - Tab 5: `/profile` (`SCR-26`)
- **Overlays**:
  - `SCR-34: Payment Successful`: Triggered as a modal `showDialog()` on top of `/finance/invoices/:id`.
  - `SCR-35: Hamburger Drawer`: Managed by `Scaffold.of(context).openDrawer()`.
  - `SCR-38: Demo Booking Confirmed`: Triggered as a modal dialog on top of `/demo-booking`.

---

## 6. Design System Blueprint

Based on the verified audit in [14-FIGMA-DESIGN-SYSTEM-AUDIT.md](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/14-FIGMA-DESIGN-SYSTEM-AUDIT.md):

### 6.1 Typography Hierarchy (Google Fonts — Inter)
- **Display / H1**: 28px / Bold (700) / Line-height: 36px (Dashboard greetings, splash titles)
- **H2 / Title**: 20px / SemiBold (600) / Line-height: 28px (Section headers, card titles)
- **H3 / Subtitle**: 16px / SemiBold (600) / Line-height: 24px (List titles, modal headers)
- **Body Regular**: 14px / Regular (400) / Line-height: 20px (General content, descriptions)
- **Body Bold**: 14px / SemiBold (600) / Line-height: 20px (Emphasized text, key attributes)
- **Caption / Small**: 12px / Regular (400) / Line-height: 16px (Timestamps, metadata, chips)

### 6.2 Curated Color Palette
- **Brand Primary**: `#0D3578` (TrueLern Deep Blue)
- **Brand Accent**: `#1E60D4` (Interactive Royal Blue)
- **Background Main**: `#F8FAFC` (Clean Slate 50)
- **Card / Surface**: `#FFFFFF` (Pure White)
- **Text Primary**: `#0F172A` (Slate 900)
- **Text Secondary**: `#64748B` (Slate 500)
- **Text Placeholder**: `#94A3B8` (Slate 400)
- **Border / Divider**: `#E2E8F0` (Slate 200)
- **Success / Paid**: `#10B981` (Emerald 500)
- **Warning / Pending**: `#F59E0B` (Amber 500)
- **Error / Failed**: `#EF4444` (Rose 500)

### 6.3 Shape, Elevation, & Component Specs
- **Radius**: Cards: `12px` or `16px`; Buttons: `8px` or `12px`; Inputs: `8px`; Badges: `999px` (fully rounded pill).
- **Elevation / Shadows**: Soft layered drop shadow `0px 4px 12px rgba(15, 23, 42, 0.06)`. No heavy black shadows.
- **Buttons**:
  - Primary: Solid `#0D3578`, white text, height: 48px, horizontal padding: 24px.
  - Secondary: Outlined 1.5px `#E2E8F0`, text `#0F172A`, height: 48px.
- **Inputs**: Height: 48px, border 1px `#E2E8F0`, focused border 1.5px `#1E60D4`, fill `#FFFFFF`.

---

## 7. Asset & Iconography Blueprint

| Asset Category | Description | Source / Location in Figma | Flutter Delivery Mechanism |
|---|---|---|---|
| **Branding / Logo** | TrueLern crest and typographic logo | Row 1 Splash & Onboarding | Local SVG asset (`assets/brand/logo.svg`) |
| **Navigation Icons** | Home, Timetable, Assignments, Invoices, Profile, Bell, Menu | Row 2 & 3 navigation bars | Flutter `LucideIcons` or local SVG vector set |
| **Avatars** | Default student and parent avatar placeholders | Row 2 Dashboard & Switcher | Local asset fallback + Network Cached Image |
| **Onboarding Visuals**| 3 Value proposition illustrations | Row 1 Frame 2 | Local SVG/PNG assets (`assets/onboarding/`) |
| **Financial Badges** | Paid badge, pending badge, overdue badge | Row 3 Invoices Frame 7 & 8 | Dynamic Flutter vector container badges |
| **Success Asset** | Checkmark illustration for payment success | Row 3 Frame 9 Overlay | Local SVG vector (`assets/illustrations/success.svg`)|
| **Empty State Assets**| Empty homework, empty schedule, offline illustrations | Designed per design audit | Local SVG vector suite (`assets/empty_states/`) |

---

## 8. Parent API Implementation Matrix

```
Contract Reference: docs/api/TrueLern-API.postman_collection.json
Production Base URL: https://truelern.visital.in/api
```

| Screen ID | HTTP | Endpoint Path | Auth | Key Request Params / Body | Expected Response Shape | Runtime Status |
|---|:---:|---|:---:|---|---|:---:|
| **SCR-01** | `GET` | `/v1/public/portal-config` | No | `?portalId=student-portal` | `{ maintenanceMode: bool, minAppVersion: str }` | `[RUNTIME VERIFIED]` |
| **SCR-03** | `POST`| `/auth/login` | No | `{ email: str, password: str }` | `{ accessToken: str, refreshToken: str, user: obj }` | **`[BLOCKED — LOGIN 500]`** |
| **SCR-09** | `GET` | `/parent/children/:id/dashboard` | Bearer | Path: `:childStudentId` | `{ attendanceRate: num, upcomingClassesCount: int... }` | `[NEEDS AUTH TEST]` |
| **SCR-11** | `GET` | `/parent/children` | Bearer | None | `[ { studentId: str, firstName: str, grade: str } ]` | `[NEEDS AUTH TEST]` |
| **SCR-13** | `GET` | `/live-classes` | Bearer | `?limit=10&sort=startDate&order=asc`| `[ { id: str, topic: str, startDate: str, instructor: obj } ]` | `[NEEDS AUTH TEST]` |
| **SCR-14** | `GET` | `/live-classes/:id` | Bearer | Path: `:liveClassId` | `{ id: str, topic: str, agenda: str, resources: [] }` | `[NEEDS AUTH TEST]` |
| **SCR-18** | `GET` | `/assignments` | Bearer | `?limit=10&status=published` | `[ { id: str, title: str, dueDate: str, maxMarks: num } ]` | `[NEEDS AUTH TEST]` |
| **SCR-19** | `GET` | `/assignments/:id` | Bearer | Path: `:assignmentId` | `{ id: str, title: str, instructions: str, rubric: [] }` | `[NEEDS AUTH TEST]` |
| **SCR-22** | `GET` | `/assignments/:id` | Bearer | Path: `:assignmentId` | `{ marksObtained: num, maxMarks: num, feedback: str }` | `[NEEDS AUTH TEST]` |
| **SCR-24** | `GET` | `/attendance/summary` | Bearer | `?student={{childStudentId}}` | `{ attendanceRate: num, totalClasses: int, present: int }`| `[NEEDS AUTH TEST]` |
| **SCR-26** | `GET` | `/students/:id` / Profile | Bearer | Token User ID | `{ name: str, email: str, phone: str, role: "PARENT" }` | `[NEEDS AUTH TEST]` |
| **SCR-28** | `GET` | `/notifications/inbox` | Bearer | `?limit=20&page=1` | `[ { id: str, title: str, message: str, isRead: bool } ]` | `[NEEDS AUTH TEST]` |
| **SCR-29** | `POST`| `/auth/change-password` | Bearer | `{ oldPassword: str, newPassword: str }` | `{ success: bool, message: str }` | `[NEEDS AUTH TEST]` |
| **SCR-32** | `GET` | `/finance/invoices` | Bearer | `?limit=10` | `[ { id: str, invoiceNumber: str, amount: num, status } ]` | `[NEEDS AUTH TEST]` |
| **SCR-33** | `GET` | `/finance/invoices/:id` | Bearer | Path: `:invoiceId` | `{ invoiceNumber: str, lineItems: [], total: num }` | `[NEEDS AUTH TEST]` |
| **SCR-34** | `GET` | `/finance/receipts` | Bearer | `?limit=10` | `[ { receiptNumber: str, amount: num, pdfUrl: str } ]` | `[NEEDS AUTH TEST]` |
| **SCR-36** | `GET` | `/notifications/preferences` | Bearer | None | `{ emailAlerts: bool, pushAlerts: bool, smsAlerts: bool }` | `[NEEDS AUTH TEST]` |
| **SCR-37** | `POST`| `/public/lead` | No | `{ fullName, email, phone... }` | `{ success: bool, data: { leadId: str } }` | `[RUNTIME VERIFIED]` |

---

## 9. Authentication Blueprint

1. **Token Persistence**:
   - Access and Refresh tokens stored exclusively in `FlutterSecureStorage` (encrypted via AES/Keystore on Android, Keychain on iOS).
   - Tokens must never be written to plaintext `SharedPreferences` or logged to console.
2. **Session Interceptor**:
   - `Dio` HTTP client configures an `AuthInterceptor`.
   - Attaches `Authorization: Bearer <accessToken>` to all authenticated requests.
   - Intercepts HTTP 401 responses and triggers automated refresh token rotation (`POST /api/auth/refresh`).
3. **Hard Runtime Gate**:
   - `POST /api/auth/login` currently returns `HTTP 500` on production for test credentials (`parent@truelern.com`).
   - **Enforcement**: No mock tokens, fake users, bypass flags, or hardcoded JWTs are allowed in the Flutter codebase. Authenticated testing remains gated until the backend resolves this issue.

---

## 10. Dependency & Risk Registers

### 10.1 Backend Dependency Register (6 Blocked Items)

| Screen ID | Required Capability | Missing Endpoint | Impact on Flutter Implementation | Required Action |
|---|---|---|---|---|
| **SCR-04** | SMS/Email 2FA OTP | `POST /api/auth/otp/verify` | Cannot verify mobile phone login | Backend team must deploy SMS/Email gateway service |
| **SCR-06** | Guardian Profile Update | `PUT /api/parent/profile` | Parent cannot edit contact info | Backend team must publish profile mutation contract |
| **SCR-07** | Ward Self-Registration | `POST /api/parent/children` | Parent cannot register/link new child | Backend team must create ward linking endpoint |
| **SCR-08** | Timezone Configuration | `PUT /api/parent/timezone` | Parent cannot set class timezone | Backend team must publish user timezone update API |
| **SCR-30** | Social OAuth Integration| `GET /api/auth/methods` | Cannot render Google/Apple login | Backend team must integrate OAuth identity providers |
| **SCR-31** | Device Session Revocation| `GET/DELETE /api/auth/devices`| Cannot view or revoke active devices | Backend team must implement session tracking table |

### 10.2 Needs-Confirmation Register (3 Items)

| Screen ID | Screen Name | Why Confirmation Is Needed | Current State & Unknowns | Decision Required from Stakeholder |
|---|---|---|---|---|
| **SCR-05** | `Student Interests` | Unclear if mobile self-intake is permitted or if admissions handles placement. | Dropdowns exist in Figma ("Pre-Primary"). No API exists in Postman. | Confirm whether intake questionnaire is active in mobile v1. |
| **SCR-17** | `Offline Dashboard` | Artboard exists on canvas, but caching specs are undefined in PRD. | Offline artboard present. Cache duration, size limits, and entity sync unknown. | Define caching engine (Hive vs SQLite), TTL, and sync strategy. |
| **SCR-34** | `Payment Successful`| Mobile payment execution callback mechanism is unverified. | Figma shows receipt dialog; Postman has read receipts, but no mobile gateway. | Specify gateway: Web checkout redirect, Razorpay, or Stripe SDK. |

### 10.3 Out-of-Scope Register (1 Item)
- **SCR-27: Messages / Inquiries**: Explicitly excluded by PRD v1 Core Freeze ("Discussion Forum / Chat excluded"). Backend has no chat REST or WebSocket service. Screen is permanently excluded from Phase 1A implementation.

---

## 11. Implementation Dependency Order (Phased Sequence)

When implementation is formally authorized, execution must proceed strictly through these 12 stages:

```
[Stage 1: Core Foundation] ──► [Stage 2: Design Tokens] ──► [Stage 3: Shell & Nav]
                                                                     │
┌────────────────────────────────────────────────────────────────────┘
▼
[Stage 4: Network & Interceptors] ──► [Stage 5: Auth & Session Gate]
                                                    │
┌───────────────────────────────────────────────────┘
▼
[Stage 6: Child Context Store] ──► [Stage 7: Parent Dashboard Hub]
                                                    │
┌───────────────────────────────────────────────────┘
▼
[Stage 8: Academics & Timetable] ──► [Stage 9: Assignments & Feedback]
                                                    │
┌───────────────────────────────────────────────────┘
▼
[Stage 10: Invoices & Finance] ──► [Stage 11: Settings & Drawer] ──► [Stage 12: E2E Verification]
```

- **Stage 1 — Core Foundation**: Flutter project setup, Riverpod architecture scaffolding, linter rules, asset folder structure.
- **Stage 2 — Design System**: Theme tokens, typography, custom buttons, text fields, cards, shimmer loaders.
- **Stage 3 — App Shell & Navigation**: GoRouter configuration, persistent bottom nav scaffold, app bar header.
- **Stage 4 — Network Layer**: Dio HTTP client, base URL configuration, error envelope parsing, interceptor stack.
- **Stage 5 — Authentication**: Splash bootstrap (`SCR-01`), Login form (`SCR-03`), token persistence, session guards.
- **Stage 6 — Parent Child-Context Engine**: `activeChildIdProvider`, child switcher UI, empty ward handler (`SCR-11`).
- **Stage 7 — Parent Dashboard**: Metrics card grid, attendance card, upcoming classes widget (`SCR-09`, `SCR-24`).
- **Stage 8 — Academics & Timetable**: Live class timetable, agenda overview, handouts (`SCR-13`, `SCR-14`).
- **Stage 9 — Assignments & Feedback**: Homework list by status, rubric viewer, teacher marks display (`SCR-18`, `SCR-19`, `SCR-22`).
- **Stage 10 — Billing & Finance**: Invoices list, itemized tax invoice detail, receipt display (`SCR-32`, `SCR-33`, `SCR-34`).
- **Stage 11 — Settings & Drawer**: Hamburger drawer overlay (`SCR-35`), profile (`SCR-26`), alerts inbox (`SCR-28`), preferences (`SCR-36`).
- **Stage 12 — Verification Gate**: Visual regression against Figma, contract integration testing, runtime verification gate pass.

---

## 12. Future Verification & Testing Blueprint

Future implementation validation must satisfy the 9 testing layers mandated in [07-TESTING-VERIFICATION-RULES.md](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/07-TESTING-VERIFICATION-RULES.md):
1. **Figma Visual Parity**: Pixel-level comparison with canvas `Parent(full app)_TreLern` (margins, paddings, colors, font weights).
2. **Navigation Stack**: Back-button hardware handling, deep linking, tab state preservation (`PageStorageKey`).
3. **API Contract Verification**: Unit test schema validation asserting DTO deserialization against Postman samples.
4. **Runtime Verification**: Live HTTP execution against `https://truelern.visital.in/api` on physical/virtual Android device.
5. **Loading State Check**: Skeleton shimmer appearance during slow network throttle (3G simulation).
6. **Empty State Check**: Rendering of empty vector illustration when endpoint returns empty list.
7. **Error Handling**: Graceful error card presentation with retry trigger on HTTP 500 / timeouts.
8. **Auth Token Security**: Verifying tokens are securely encrypted and cleared on logout.
9. **Child Context Isolation**: Verifying zero cross-contamination of academic records when toggling between wards.

---

## 13. Implementation Hard Stop Conditions

Flutter implementation must **IMMEDIATELY HALT** if any of the following events occur:

1. **Figma Ambiguity**: A UI layout, button action, or flow is unrepresented or conflicting in the design canvas.
2. **Missing API Contract**: A feature requires an endpoint not documented in `TrueLern-API.postman_collection.json`.
3. **API Invention Temptation**: Any scenario where a developer would create a synthetic mock endpoint or fake response envelope.
4. **Runtime Failure on Live Endpoint**: A verified contract returns unexpected status codes or crashes in runtime testing.
5. **Authentication Blocker Unresolved**: Attempting to implement authenticated flows before `POST /api/auth/login` is operational on production.
6. **Child Context Absence**: Attempting to build academic/financial screens without verified `childStudentId` resolution.
7. **Scope Creep**: Any attempt to add features from Student Phase 1B or outside the frozen PRD.

> **Remedy**: Document the exact blocker in the project issue tracker and request architectural guidance. Never write workaround code.

---

## 14. Governance Gate Lock Declaration

```
============================================================
TRUELEARN AIO FLUTTER — GOVERNANCE GATE LOCK STATUS
============================================================
PHASE 1A — PARENT:
[LOCKED — APPROVED PLANNING BASELINE]

PARENT FLUTTER IMPLEMENTATION BLUEPRINT:
[COMPLETED — PLANNING ONLY]

FLUTTER IMPLEMENTATION:
[NOT STARTED]

BACKEND IMPLEMENTATION:
[NOT STARTED]

PHASE 1B — STUDENT:
[NOT STARTED]
============================================================
```
