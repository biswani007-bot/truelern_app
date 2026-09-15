# 26 — Parent Dashboard Implementation (SCR-09)

**Document Status**: LOCKED — VERIFIED IMPLEMENTATION BASELINE  
**Action**: ACTION 5A — PARENT DASHBOARD IMPLEMENTATION  
**Project**: `truelearn` (Flutter Mobile Application)  
**Date**: September 2026  

---

## 1. Executive Summary

Under **Action 5A**, the TrueLern Parent Dashboard (`SCR-09`) was implemented as the first authenticated Parent product feature.

All implementation adheres strictly to:
- Real API contracts: `GET /api/parent/children` and `GET /api/parent/children/{childStudentId}/dashboard`
- Clean Architecture principles (Domain, Data, Presentation)
- Unidirectional state management using Riverpod (`AsyncNotifier` / `Notifier`)
- Null-safety with defensive parsing for production data anomalies
- Zero mock or fake data in production code
- Comprehensive unit and widget tests (70/70 passing across the entire project suite)
- Real runtime authentication and dashboard data retrieval against the live production server `https://truelern.visital.in`

---

## 2. API Contract & Runtime Discovery

### Endpoints
1. **`GET /api/parent/children`**
   - **Postman Reference**: Folder 04, Item 1
   - **Auth**: `Authorization: Bearer <accessToken>` (injected by `AuthInterceptor`)
   - **Response Envelope**:
     ```json
     {
       "success": true,
       "data": [
         {
           "studentId": "6a87e05e9b5f64a15873f66c",
           "firstName": "Mia",
           "lastName": "Mercer",
           "avatar": null,
           "grade": null
         },
         {
           "studentId": "6a87011efae35df7c876b0ab",
           "firstName": "Alex",
           "lastName": "Mercer",
           "avatar": null,
           "grade": null
         }
       ]
     }
     ```

2. **`GET /api/parent/children/{childStudentId}/dashboard`**
   - **Postman Reference**: Folder 04, Item 2
   - **Auth**: `Authorization: Bearer <accessToken>`
   - **Response Envelope**:
     ```json
     {
       "success": true,
       "data": {
         "attendanceRate": null,
         "upcomingClassesCount": null,
         "pendingAssignmentsCount": null,
         "totalBalanceDue": null
       }
     }
     ```

### Real Production Runtime Verification Findings
Direct runtime execution with `parent@truelern.com` / `password123`:
- **Auth**: Authenticated successfully via `POST /api/auth/login` (HTTP 200).
- **Tokens**: `accessToken` and `refreshToken` received and stored.
- **Children**: 2 linked children exist on the production database:
  - `Mia Mercer` (ID: `6a87e05e9b5f64a15873f66c`)
  - `Alex Mercer` (ID: `6a87011efae35df7c876b0ab`)
- **Metrics**: The metrics fields returned `null` for the first child on backend, demonstrating that our **null-safe parsing (`DashboardDto.fromJson`) and resilient UI cards** properly display neutral fallback states (`—` / `Not available` / `No outstanding balance`) without exceptions.

---

## 3. Architecture & File Structure

### Domain Layer
- [`lib/features/dashboard/domain/entities/child_entity.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/domain/entities/child_entity.dart): Immutable model representing linked child.
- [`lib/features/dashboard/domain/entities/dashboard_entity.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/domain/entities/dashboard_entity.dart): Immutable dashboard metrics container.
- [`lib/features/dashboard/domain/repositories/dashboard_repository.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/domain/repositories/dashboard_repository.dart): Interface defining contract for data retrieval.

### Data Layer
- [`lib/features/dashboard/data/models/child_dto.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/data/models/child_dto.dart): Safe JSON parsing for children array.
- [`lib/features/dashboard/data/models/dashboard_dto.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/data/models/dashboard_dto.dart): Safe JSON parsing with robust type-coercion helpers (`parseDouble`, `parseInt`).
- [`lib/features/dashboard/data/repositories/dashboard_repository_impl.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/data/repositories/dashboard_repository_impl.dart): Concrete repository communicating with `ApiClient`.

### Presentation Layer
- **Controllers & States**:
  - [`lib/features/dashboard/presentation/controllers/children_controller.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/presentation/controllers/children_controller.dart): Manages child list state & active child selection.
  - [`lib/features/dashboard/presentation/controllers/children_state.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/presentation/controllers/children_state.dart): `ChildrenInitial`, `ChildrenLoading`, `ChildrenLoaded`, `ChildrenError`.
  - [`lib/features/dashboard/presentation/controllers/dashboard_controller.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/presentation/controllers/dashboard_controller.dart): Manages child dashboard metrics.
  - [`lib/features/dashboard/presentation/controllers/dashboard_state.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/presentation/controllers/dashboard_state.dart): `DashboardInitial`, `DashboardLoading`, `DashboardLoaded`, `DashboardNoChild`, `DashboardError`.

- **Screens & Shell**:
  - [`lib/features/dashboard/presentation/screens/parent_dashboard_screen.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/presentation/screens/parent_dashboard_screen.dart): SCR-09 Parent Dashboard implementation.
  - [`lib/features/dashboard/presentation/screens/parent_shell_screen.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/presentation/screens/parent_shell_screen.dart): Stateful persistent 5-tab shell + drawer.
  - [`lib/core/router/app_router.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/core/router/app_router.dart): `StatefulShellRoute.indexedStack` with 5 branches.

- **Widgets**:
  - [`lib/features/dashboard/presentation/widgets/dashboard_header_card.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/presentation/widgets/dashboard_header_card.dart): Hero greeting card.
  - [`lib/features/dashboard/presentation/widgets/metric_card.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/presentation/widgets/metric_card.dart): Attendance and class metrics card.
  - [`lib/features/dashboard/presentation/widgets/assignment_summary_card.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/presentation/widgets/assignment_summary_card.dart): Assignments summary card.
  - [`lib/features/dashboard/presentation/widgets/finance_alert_card.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/presentation/widgets/finance_alert_card.dart): Outstanding fee balance card.
  - [`lib/features/dashboard/presentation/widgets/dashboard_skeleton.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/presentation/widgets/dashboard_skeleton.dart): Shimmer placeholder during async loading.
  - [`lib/features/dashboard/presentation/widgets/empty_dashboard_widget.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/presentation/widgets/empty_dashboard_widget.dart): Shown when 0 children are linked.
  - [`lib/features/dashboard/presentation/widgets/error_dashboard_widget.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/dashboard/presentation/widgets/error_dashboard_widget.dart): Error state with user-friendly message and retry button.

---

## 4. Verification & Testing

### Test Suite Summary
- `test/core/router_test.dart`: Router navigation, redirect guards, branch destinations.
- `test/features/dashboard/children_controller_test.dart`: 6 tests for initial, load, empty, error, select, retry.
- `test/features/dashboard/dashboard_controller_test.dart`: 6 tests for initial, no-child, loaded, error, retry.
- `test/features/dashboard/parent_dashboard_screen_test.dart`: 4 widget tests for skeleton, empty state, error state, and loaded dashboard.
- `test/features/dashboard/real_dashboard_runtime_test.dart`: Real production runtime test executing live authentication + child listing + metrics retrieval.

**Overall Test Suite**: **70 / 70 tests passed (100% pass rate)**.  
**Analyzer**: **0 errors, 0 warnings** (exit code 0).

---

## 5. Governance Boundaries

- **Implemented**: Parent Dashboard (`SCR-09`) & Parent Shell (`StatefulShellRoute`).
- **Forbidden / Not Started**:
  - Other Parent tabs (`Classes`, `Assignments`, `Invoices`, `Profile`) remain unpopulated placeholders.
  - Child onboarding / child creation flows are NOT implemented (no backend API exists).
  - Student application (`Phase 1B`) has NOT been touched.
  - Backend has NOT been modified.
