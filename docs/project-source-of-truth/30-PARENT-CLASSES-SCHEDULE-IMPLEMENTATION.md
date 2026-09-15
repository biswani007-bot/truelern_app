# 30 — Parent Classes Schedule UI (SCR-13) Implementation & Mobile Walkthrough

**Document Status**: LOCKED — VERIFIED IMPLEMENTATION BASELINE  
**Action**: ACTION 5E — PARENT CLASSES SCHEDULE UI — SCR-13  
**Project**: `truelearn` (Flutter Mobile Application)  
**Date**: September 2026  

---

## 1. Scope & Objective

This document formalizes the implementation, architecture, and live mobile walkthrough verification for **SCR-13 — Parent Class Schedule / Timetable**.

### Exact Scope Implemented:
- **Presentation Layer**: `ParentClassesScreen` (`lib/features/classes/presentation/screens/parent_classes_screen.dart`).
- **State Management**: `ClassesController` and `ClassesState` (`lib/features/classes/presentation/controllers/`).
- **Widgets**:
  - `ClassCard` (`lib/features/classes/presentation/widgets/class_card.dart`): Displays subject, title, timings, teacher avatar/name, and status pill (`UPCOMING`, `LIVE`, `COMPLETED`, `CANCELLED`).
  - `ChildContextBanner` (`lib/features/classes/presentation/widgets/child_context_banner.dart`): Top active-child header with dynamic popup menu to switch between linked wards.
  - `ClassesSkeleton` (`lib/features/classes/presentation/widgets/classes_skeleton.dart`): Geometry-accurate shimmer loading skeleton.
  - `EmptyClassesWidget` (`lib/features/classes/presentation/widgets/empty_classes_widget.dart`): Clean empty state when no sessions are scheduled for the active child.
  - `ErrorClassesWidget` (`lib/features/classes/presentation/widgets/error_classes_widget.dart`): Non-technical error display with retry button.
- **Routing**: Connected Branch 1 in `app_router.dart` (`/parent/classes`) to `ParentClassesScreen`.
- **Drawer Integration**: Connected "Classes & Timetable" drawer item to branch index 1.

### Explicit Exclusions:
- SCR-14 (Class Details) is NOT implemented. Tapping a card displays a non-breaking roadmap notice.
- SCR-24 (Learning Progress) is NOT implemented.
- Student Phase 1B and Jitsi live classroom join controls are strictly excluded.
- Zero backend or web modifications.

---

## 2. API Contract & Multi-Ward Runtime Facts

### 2.1 Authoritative Endpoint
- **Endpoint**: `GET /api/parent/children/{childStudentId}/live-classes`
- **Authentication**: `Authorization: Bearer <accessToken>` (injected automatically via `AuthInterceptor`).
- **Prohibited Endpoint**: `GET /api/live-classes` (returns HTTP 403 Forbidden for Parent tokens).

### 2.2 Live Production Backend Multi-Ward Findings
During Action 5E live runtime verification, both linked wards under `parent@truelern.com` were queried against the production API (`https://truelern.visital.in`):

1. **Mia Mercer** (`6a87e05e9b5f64a15873f66c`):
   - Response: `HTTP 200 OK` with `data: []`
   - UI Behavior: Renders honest `EmptyClassesWidget` ("No Classes Scheduled for Mia") without fake data or crash.
2. **Alex Mercer** (`6a87011efae35df7c876b0ab`):
   - Response: `HTTP 200 OK` with `data: [...]` containing 3 real scheduled sessions:
     - Session 1: *"Intro to Advanced Next.js"* | Course: Full Stack Software Engineering | Teacher: Elizabeth Vance | Status: `scheduled`
     - Session 2: *"Live Demo — Communication & Confidence"* | Course: Junior Foundation | Teacher: Elizabeth Vance | Status: `scheduled`
     - Session 3: *"Introduction to Full Stack Web Development"* | Course: Full Stack Software Engineering | Teacher: Elizabeth Vance | Status: `scheduled`
   - UI Behavior: Renders 3 `ClassCard` items with timings, teacher metadata, subject badges, and status pills.

---

## 3. UI States Matrix

| State | Controller State | Visual Presentation | Verified In |
|---|---|---|:---:|
| **Initial / Loading** | `ClassesLoading` | `ClassesSkeleton` (3 shimmer cards + banner) | Unit + Widget Test |
| **Success (Empty)** | `ClassesLoaded([])` | `EmptyClassesWidget` ("No Classes Scheduled for [Name]") | Real Mobile Walkthrough (Mia) |
| **Success (Populated)** | `ClassesLoaded([3 sessions])` | Date-grouped `ClassCard` list with subject tags, teacher, times | Real Mobile Walkthrough (Alex) |
| **No Active Child** | `ClassesNoChild` | `EmptyDashboardWidget` ("No Child Linked") | Controller Unit Test |
| **Error** | `ClassesError` | `ErrorClassesWidget` with "Try Again" CTA | Widget Test |
| **Pull-to-Refresh** | `ClassesLoading` → `ClassesLoaded` | `RefreshIndicator` re-fetching active child's endpoint | Real Mobile Walkthrough |

---

## 4. Mobile Walkthrough Results

Executed via automated end-to-end mobile walkthrough harness: `test/features/classes/real_mobile_walkthrough_test.dart` against `https://truelern.visital.in`.

| Step | Action | Expected | Actual | Result |
|:---:|---|---|---|:---:|
| **1-5** | Launch app & login `parent@truelern.com` / `password123` | HTTP 200, tokens persisted in SecureStorage, `Authenticated` state | Real HTTP 200 received; session tokens stored | **PASS** |
| **6-8** | Load Parent Shell & Dashboard | 2 linked wards loaded (`Mia Mercer`, `Alex Mercer`); Mia active | Shell displayed; 2 children found; Mia active | **PASS** |
| **9-11** | Tap "Classes" bottom nav tab (Branch 1) | SCR-13 `ParentClassesScreen` opens; header shows "Class Schedule" / "Timetable" | SCR-13 opened; tab index 1 selected | **PASS** |
| **12-15** | Fetch live classes for active child (Mia Mercer) | API returns HTTP 200 with `[]`; honest empty state displayed | 0 sessions returned; `EmptyClassesWidget` rendered | **PASS** |
| **16-18** | Switch active child to Alex Mercer | Schedule for Mia discarded; API queries Alex; 3 real sessions displayed | Switched to Alex; 3 sessions rendered with Elizabeth Vance | **PASS** |
| **19-21** | Pull-to-refresh on schedule view | Re-fetches Alex schedule; updates list without duplicate loops | Refreshed cleanly; 3 sessions reloaded | **PASS** |
| **22** | Switch back to Mia Mercer | Alex schedule discarded; Mia empty schedule rendered | Switched to Mia; count = 0 empty state rendered | **PASS** |
| **23** | Check unauthenticated boundary | Direct access without auth token prevented | Unauthenticated access returns `AuthInitial` / redirects to login | **PASS** |

---

## 5. Visual Quality & Figma Fidelity Audit

- **Overflow**: Zero render overflow or yellow-black striped errors.
- **Safe Area**: Respects top and bottom notches; top padding 16px, horizontal margins 20px.
- **Typography**: Adheres strictly to `AppTypography` (`Inter`):
  - Section subtitle: 12px Medium `AppTypography.bodySmall`
  - Section title: 16px SemiBold `AppTypography.titleMedium`
  - Class title: 16px SemiBold `AppTypography.titleMedium`
  - Time & Teacher text: 12px `AppTypography.bodySmall`
- **Cards & Radii**:
  - `ClassCard`: 16px radius, 1px border (`#E2E8F0`), subtle drop shadow `0 4px 12px rgba(15,23,42,0.04)`.
  - Status Pills: 20px radius capsules (`BorderRadius.circular(20)`).
- **Observation Constraint**:
  - Zero "Join Class", "Join Meeting", or Jitsi interactive controls rendered.
  - Read-only schedule for parent peace of mind.

---

## 6. Test Suite & Static Analysis Summary

- **Analyzer**: `dart analyze .` → **0 issues found!**
- **Test Suite**: `flutter test` → **96/96 tests passing (100%)**
  - Added 7 `ClassesController` tests.
  - Added 6 `ParentClassesScreen` widget tests.
  - Added 1 real mobile walkthrough end-to-end integration test.
  - Added 1 real production multi-ward runtime API test.
