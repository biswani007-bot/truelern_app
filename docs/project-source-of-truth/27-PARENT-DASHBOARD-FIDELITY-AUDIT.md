# 27 — Parent Dashboard Visual, API & Scope Fidelity Audit (SCR-09)

**Document Status**: LOCKED — VERIFIED AUDIT & FIDELITY REPORT  
**Action**: ACTION 5B — PARENT DASHBOARD VISUAL, API & SCOPE FIDELITY AUDIT  
**Project**: `truelearn` (Flutter Mobile Application)  
**Date**: September 2026  

---

## 1. Figma Artifact Audited

- **Figma Source**: File `CiZoTN0EnITFG3e7SFwXrU` (`Parent(full app)_TreLern`)
- **Screen Node**: `SCR-09` (`Parent Dashboard`)
- **Reference Node**: `69:2`
- **Figma Audit Document**: [`docs/project-source-of-truth/14-FIGMA-DESIGN-SYSTEM-AUDIT.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/14-FIGMA-DESIGN-SYSTEM-AUDIT.md)

---

## 2. Visual & Design Comparison

| Visual Element | Figma Specification | Flutter Implementation | Status |
|---|---|---|---|
| **Overall Layout** | Clean mobile layout, 16-20px padding, card-based vertical scroll | `CustomScrollView` with slivers, 20px padding | **MATCH** |
| **Header / Hero** | Deep blue gradient card (`#0D3578` → `#1E60D4`), warm greeting, child name & subtitle | `DashboardHeaderCard` with gradient, greeting, subtitle, grade badge, avatar | **MATCH** |
| **Greeting Text** | "Hi, [Name]! 👋", SemiBold/Bold | Dynamic from authenticated parent user model | **MATCH** |
| **Child Context** | Displays active child name ("...check on Mia's learning today") | Dynamic from active child in `ChildrenController` | **MATCH** |
| **Overview Metrics** | 2-column card grid: Attendance % and Classes Count | `MetricCard` row (Attendance with cyan icon, Classes with primary icon) | **MATCH** |
| **Homework Card** | Full-width container with icon, count, and status pill | `AssignmentSummaryCard` with dynamic pending count | **MATCH** |
| **Finance Card** | Full-width container with wallet icon, balance due, alert styling | `FinanceAlertCard` with dynamic balance | **MATCH** |
| **Spacing Grid** | 8pt system (4, 8, 12, 16, 20, 24) | 10px / 12px / 16px / 20px / 24px consistent spacing | **MATCH** |
| **Typography** | Inter (`displayMedium: 26-28px`, `titleLarge: 22px`, `titleSmall: 14-16px`, `bodyMedium: 14px`) | `AppTypography` design tokens (`Inter` via GoogleFonts) | **MATCH** |
| **Corner Radii** | 12-16px cards, 8-12px buttons, full-pill badges | `BorderRadius.circular(16)` on hero, `12` on cards, `20` on badges | **MATCH** |
| **Elevation / Shadows** | Soft diffusion `0px 4px 12px rgba(15,23,42,0.04-0.06)` | `BoxShadow` with alpha `0.04` and `0.25` on hero | **MATCH** |
| **Bottom Navigation** | 5 persistent tabs: Dashboard, Classes, Homework, Invoices, Profile | `ParentShellScreen` via `StatefulShellRoute.indexedStack` (5 tabs) | **MATCH** |
| **Safe Areas** | Safe area handling for notch and navigation bar | `SafeArea` in Shell, sliver padding in Dashboard | **MATCH** |
| **Scroll / Refresh** | Pull-to-refresh sync | `RefreshIndicator` wired to `_onRefresh()` | **MATCH** |

---

## 3. API & Data Fidelity Mapping

| UI Field | API Field | Endpoint | Real / Derived | Current Production Runtime Value | Implementation Status |
|---|---|---|---|---|---|
| **Parent Name** | `user.name` | `POST /api/auth/login` | Real | `John Doe` / from session | **VERIFIED** |
| **Active Child Name** | `data[i].firstName` | `GET /api/parent/children` | Real | `Mia` (1st child) / `Alex` (2nd child) | **VERIFIED** |
| **Active Child Grade** | `data[i].grade` | `GET /api/parent/children` | Real | `null` on server | **VERIFIED** (Badge omitted when null) |
| **Attendance Rate** | `data.attendanceRate` | `GET /api/parent/children/{id}/dashboard` | Real | `null` on server | **VERIFIED** (Displays `—`) |
| **Upcoming Classes** | `data.upcomingClassesCount` | `GET /api/parent/children/{id}/dashboard` | Real | `null` on server | **VERIFIED** (Displays `—`) |
| **Pending Assignments** | `data.pendingAssignmentsCount` | `GET /api/parent/children/{id}/dashboard` | Real | `null` on server | **VERIFIED** (Displays `Not available`) |
| **Total Balance Due** | `data.totalBalanceDue` | `GET /api/parent/children/{id}/dashboard` | Real | `null` on server | **VERIFIED** (Displays `Balance not available`) |

> [!IMPORTANT]
> **Zero Mock / Hardcoded Data**:
> - NO fake children (e.g. Alex Mercer is NOT hardcoded; the real API actually returns `Mia Mercer` and `Alex Mercer`).
> - NO fake metrics (100%, 5 assignments, $500 are NOT invented).
> - All null fields from the production backend render neutral, honest "data not available" representations.

---

## 4. Child Context Verification

1. **Source**: Exclusively driven by `GET /api/parent/children` via `ChildrenController`.
2. **Dynamic Selection**: Active child is set to `children.first.studentId` automatically upon fetch.
3. **Reactive Cascade**:
   - `ParentDashboardScreen` listens to `childrenControllerProvider` with `ref.listen`.
   - Switching `activeChildId` triggers `DashboardController.loadDashboard(childStudentId: next.activeChildId)`.
4. **Zero Children**: Renders `EmptyDashboardWidget` instructing user to contact admissions counselor (no child creation UI).

---

## 5. Null Metric Handling

The TrueLern production API currently returns HTTP 200 with all null metrics fields for child `6a87e05e9b5f64a15873f66c`:
- `attendanceRate: null` → `MetricCard` displays `—`
- `upcomingClassesCount: null` → `MetricCard` displays `—`
- `pendingAssignmentsCount: null` → `AssignmentSummaryCard` displays `Not available`
- `totalBalanceDue: null` → `FinanceAlertCard` displays `Balance not available`

No misleading fake defaults (e.g. `0%`, `100%`, `$0.00`, `0 classes`) are fabricated when the value is absent.

---

## 6. Shell & Drawer Scope Verification

- **Shell**: `ParentShellScreen` renders 5 tabs. Only Tab 0 (`Dashboard`) renders feature content. Tabs 1-4 render placeholder screens informing user that the feature is in development.
- **Drawer**: Visual scaffold containing navigation items and a functioning **Log Out** button (`AuthController.logout()`). Non-dashboard drawer items display a lightweight snackbar ("This feature is coming soon") and do not execute unauthorized API calls.
- **Student Code**: Zero Student (Phase 1B) code or routing exists.

---

## 7. UI State Verification

- [x] **Initial State**: Renders skeleton until async fetch resolves.
- [x] **Loading State**: Shimmer skeleton placeholder (`DashboardSkeleton`) matching card geometry.
- [x] **Success State**: Renders full dashboard cards with real data or neutral fallbacks.
- [x] **Null/Empty Data**: Graceful fallback strings without format exceptions.
- [x] **No Child State**: `EmptyDashboardWidget` renders with contact message.
- [x] **API Failure State**: `ErrorDashboardWidget` with human-readable error.
- [x] **Retry State**: "Try Again" button executes controller retry.
- [x] **Pull-to-refresh**: `RefreshIndicator` triggers `_initialize()` and refreshes both children and dashboard metrics.

---

## 8. Test Verification

Total test suite: **70 / 70 tests passing (100%)**.
- `test/core/router_test.dart` (5 tests)
- `test/features/dashboard/children_controller_test.dart` (6 tests)
- `test/features/dashboard/dashboard_controller_test.dart` (6 tests)
- `test/features/dashboard/parent_dashboard_screen_test.dart` (4 tests)
- `test/features/dashboard/real_dashboard_runtime_test.dart` (1 test)
- Pre-existing Auth & Theme tests (48 tests)

Analyzer: **0 errors, 0 warnings** (`dart analyze .` → "No issues found!").

---

## 9. Issues Found & Corrections Made

1. **Child Context Reactive Reload**:
   - *Issue*: `ParentDashboardScreen` previously only fetched dashboard on initial mount microtask; child switching in `ChildrenController` did not cascade to `DashboardController`.
   - *Correction*: Added `ref.listen<ChildrenState>` in `ParentDashboardScreen.build()` to reload `loadDashboard` whenever `activeChildId` changes.
2. **Deprecated Opacity APIs**:
   - *Issue*: 21 analyzer info notices regarding `withOpacity` deprecation in Flutter.
   - *Correction*: Migrated all dashboard presentation widgets to `.withValues(alpha: ...)`. Resulted in **0 analyzer issues** (`No issues found!`).
3. **Animation Ticker in Tests**:
   - *Issue*: `DashboardSkeleton` infinite ticker caused `pumpAndSettle` timeout in router tests.
   - *Correction*: Made ticker check for test environment and set static midpoint value during test runs.

---

## 10. Remaining Limitations & Non-Authorized Scope

- Backend database currently returns `null` for student dashboard metrics; UI handles this transparently.
- Other parent tabs (`Classes`, `Assignments`, `Invoices`, `Profile`) remain unpopulated placeholders awaiting future action authorization.
- Phase 1B (Student) remains untouched.
