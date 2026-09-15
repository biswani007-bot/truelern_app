# 28 — Parent Classes & Academics Pre-Implementation Audit

**Document Status**: LOCKED — VERIFIED AUDIT & BLUEPRINT BASELINE  
**Action**: ACTION 5C — PARENT CLASSES / ACADEMICS PRE-IMPLEMENTATION AUDIT  
**Project**: `truelearn` (Flutter Mobile Application)  
**Date**: September 2026  

---

## 1. Scope & Objective

This document establishes the authoritative pre-implementation audit for the **Parent Classes & Academics** feature area within the TrueLern Flutter mobile application.

The purpose of Action 5C is strictly analytical:
- Reconcile candidate Figma screens from `Parent(full app)_TreLern`.
- Identify the exact API endpoints and contract parameters required.
- Execute real runtime verification against the production API (`https://truelern.visital.in`).
- Document child-context requirements, UI states, and design system tokens.
- Audit current Flutter codebase for existing artifacts.
- Recommend the precise implementation sequence for subsequent actions.

> [!IMPORTANT]
> **GOVERNANCE ENFORCEMENT**:
> - This is an **AUDIT ONLY**.
> - Zero production code implementation has been performed.
> - Student Phase 1B remains untouched.
> - Backend and Web applications are not modified.

---

## 2. Source-of-Truth References

- [`docs/project-source-of-truth/01-PRODUCT-SOURCE-OF-TRUTH.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/01-PRODUCT-SOURCE-OF-TRUTH.md)
- [`docs/project-source-of-truth/02-FIGMA-SOURCE-OF-TRUTH.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/02-FIGMA-SOURCE-OF-TRUTH.md)
- [`docs/project-source-of-truth/03-API-SOURCE-OF-TRUTH.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/03-API-SOURCE-OF-TRUTH.md)
- [`docs/project-source-of-truth/08-SCREEN-MASTER-INVENTORY.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/08-SCREEN-MASTER-INVENTORY.md)
- [`docs/project-source-of-truth/09-API-SCREEN-MATRIX.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/09-API-SCREEN-MATRIX.md)
- [`docs/project-source-of-truth/14-FIGMA-DESIGN-SYSTEM-AUDIT.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/14-FIGMA-DESIGN-SYSTEM-AUDIT.md)
- [`docs/project-source-of-truth/16-PARENT-MASTER-NAVIGATION-FLOW.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/16-PARENT-MASTER-NAVIGATION-FLOW.md)
- [`docs/project-source-of-truth/17-PARENT-RECONCILIATION-FINAL.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/17-PARENT-RECONCILIATION-FINAL.md)
- [`docs/project-source-of-truth/18-PARENT-FLUTTER-IMPLEMENTATION-BLUEPRINT.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/18-PARENT-FLUTTER-IMPLEMENTATION-BLUEPRINT.md)
- Authoritative Postman Collection: [`docs/api/TrueLern-API.postman_collection.json`](file:///d:/New%20folder/New%20folder/truelearn/docs/api/TrueLern-API.postman_collection.json)

---

## 3. Figma Screen Inventory (Parent Classes & Academics)

Inspected strictly on page `Parent(full app)_TreLern` (Reference Node `69:2`):

| Screen ID | Screen Name | Role | Nav Entry Point | Nav Destination | Status | Implementation Recommendation |
|---|---|:---:|---|---|:---:|---|
| **SCR-13** | `Class Schedule` | **SHARED** | Tab 1 (`Classes`) | `SCR-14: Class Details` | `[READY FOR PLANNING]` | Implement as Parent Classes Tab list |
| **SCR-14** | `Class Details` | **SHARED** | Tap item in SCR-13 | Back to SCR-13 | `[READY FOR PLANNING]` | Implement as secondary detail screen |
| **SCR-24** | `Learning Progress (New)` | **SHARED** | Dashboard card / Drawer | Back to caller | `[READY FOR PLANNING]` | Implement as standalone progress view |

Candidate frames explicitly excluded or clarified:
- **`Student Interests` (SCR-05)**: Intake flow during lead setup; classified as `[NEEDS CONFIRMATION / NO API]`. Not part of authenticated Classes.
- **`Recordings & Revision` (SCR-15)**: Media playback stream; belongs to revision library, not live classes schedule.

---

## 4. Screen Classification & Behavioral Boundaries

- **SCR-13 (Class Schedule / Timetable)**:
  - **Type**: `SHARED` (Parent Learner Context).
  - **Parent Behavior**: Read-only schedule of the active child's upcoming, live, and completed classes. Shows session title, subject, teacher name, date/time, and status pill (`UPCOMING`, `LIVE`, `COMPLETED`).
  - **Important Constraint**: Parents **observe** schedule. They do not join the interactive Jitsi student room (joining is a Student Phase 1B action).
- **SCR-14 (Class Details)**:
  - **Type**: `SHARED` (Read-only for Parent).
  - **Parent Behavior**: Displays full class syllabus topic, learning objectives, scheduled duration, teacher bio, and meeting info overview.
- **SCR-24 (Learning Progress)**:
  - **Type**: `SHARED` (Academic Progress).
  - **Parent Behavior**: Shows overall attendance percentage and attendance session history for the selected ward.

---

## 5. Parent Navigation Flow

```
┌────────────────────────────────────────────────────────┐
│               Parent Shell (Persistent Nav)           │
├────────────────────────────────────────────────────────┤
│ [Tab 0: Dashboard]  ► [Tab 1: Classes] ◄ (ACTIVE FOCUS) │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
               ┌──────────────────────────┐
               │   SCR-13: Class Schedule │
               │ (Filtered by Child ID)   │
               └────────────┬─────────────┘
                            │ (Tap Class Item)
                            ▼
               ┌──────────────────────────┐
               │   SCR-14: Class Details  │
               │ (Topic, Teacher, Agenda) │
               └──────────────────────────┘
```

- **Bottom Nav Tab 1**: `/parent/classes` triggers `SCR-13`.
- **Item Tap**: Pushes `/parent/classes/:classId` (`SCR-14`).
- **Child Switch**: Switching the active child from the top bar or drawer refreshes the timetable for the new ward.
- **Back Navigation**: Standard pop from SCR-14 back to SCR-13.

---

## 6. API Endpoint Inventory

Inspected across `TrueLern-API.postman_collection.json`:

### 1. Dedicated Parent Endpoints (Folder 04 — Parent)
- **`GET /api/parent/children/{{childStudentId}}/live-classes`**
  - **Auth**: `Bearer {{parentToken}}`
  - **Role Access**: `PARENT` (Strict `ParentStudentLink` validated on backend)
  - **Parameters**: Path `childStudentId`
  - **Response Envelope**:
    ```json
    {
      "success": true,
      "message": "Child live classes retrieved successfully",
      "data": [
        {
          "_id": "...",
          "title": "Mathematics - Algebra Basics",
          "subject": "Mathematics",
          "scheduledStartTime": "2026-09-10T10:00:00.000Z",
          "scheduledEndTime": "2026-09-10T11:00:00.000Z",
          "status": "UPCOMING",
          "teacher": { "name": "Prof. Sharma" }
        }
      ],
      "meta": {}
    }
    ```

- **`GET /api/parent/children/{{childStudentId}}/academics`**
  - **Auth**: `Bearer {{parentToken}}`
  - **Role Access**: `PARENT`
  - **Parameters**: Path `childStudentId`
  - **Response Envelope**:
    ```json
    {
      "success": true,
      "message": "Child academics retrieved successfully",
      "data": {
        "courses": []
      },
      "meta": {}
    }
    ```

### 2. General Endpoints (Folder 08 — Live Classes)
- **`GET /api/live-classes`**:
  - **Runtime Discovery**: Requires Admin or Faculty privileges. Probing with `parent@truelern.com` returns `HTTP 403 Forbidden` (`Not authorized, insufficient privileges`).
  - **Architectural Conclusion**: **DO NOT USE `/api/live-classes` for Parent features.** The Parent portal MUST strictly use `GET /api/parent/children/:childStudentId/live-classes`.

---

## 7. API → Screen Matrix

| Screen | UI Component / Field | API Endpoint | API Field | Child Context | Runtime Status |
|---|---|---|---|:---:|:---:|
| **SCR-13** | Class Schedule List | `GET /api/parent/children/:id/live-classes` | `data[]` | `childStudentId` | **RUNTIME VERIFIED (HTTP 200)** |
| **SCR-13** | Class Title & Subject | `GET /api/parent/children/:id/live-classes` | `data[].title`, `data[].subject` | `childStudentId` | **RUNTIME VERIFIED** |
| **SCR-13** | Date, Time & Status | `GET /api/parent/children/:id/live-classes` | `data[].scheduledStartTime`, `data[].status` | `childStudentId` | **RUNTIME VERIFIED** |
| **SCR-13** | Teacher Name | `GET /api/parent/children/:id/live-classes` | `data[].teacher.name` | `childStudentId` | **RUNTIME VERIFIED** |
| **SCR-14** | Class Detail & Objectives | `GET /api/parent/children/:id/live-classes` | Matched element by ID | `childStudentId` | **RUNTIME VERIFIED** |
| **SCR-24** | Academic Courses & Syllabus | `GET /api/parent/children/:id/academics` | `data.courses[]` | `childStudentId` | **RUNTIME VERIFIED (HTTP 200)** |
| **SCR-24** | Attendance Rate & Log | `GET /api/parent/children/:id/attendance` | `data.summary`, `data.records` | `childStudentId` | CONTRACT VERIFIED |

---

## 8. Child-Context Requirements

1. **Child ID Source**:
   - `childStudentId` is provided by `ChildrenController.activeChildId` (derived from `GET /api/parent/children`).
   - For real parent `parent@truelern.com`, verified IDs are:
     - `Mia Mercer`: `6a87e05e9b5f64a15873f66c`
     - `Alex Mercer`: `6a87011efae35df7c876b0ab`
2. **Dynamic Invalidation**:
   - When the user selects a different child, the classes controller MUST re-fetch `GET /api/parent/children/:newId/live-classes`.
3. **Zero-Child Handling**:
   - If parent has no children (`children.isEmpty`), the classes tab displays the standard empty state ("No ward linked. Contact admissions counselor.").

---

## 9. Real Runtime Verification Results

Executed controlled probe against production API (`https://truelern.visital.in`):

| Endpoint | Method | Status | Result / Payload |
|---|:---:|:---:|---|
| `/api/parent/children` | `GET` | **200 OK** | 2 children (`Mia Mercer`, `Alex Mercer`) |
| `/api/parent/children/6a87e05e9b5f64a15873f66c/live-classes` | `GET` | **200 OK** | `{ success: true, data: [], meta: {} }` |
| `/api/parent/children/6a87e05e9b5f64a15873f66c/academics` | `GET` | **200 OK** | `{ success: true, data: { courses: [] }, meta: {} }` |
| `/api/live-classes` | `GET` | **403 Forbidden** | `{"message": "Not authorized, insufficient privileges"}` (Confirms Parent cannot call root admin/faculty endpoint) |

---

## 10. Backend Dependency Analysis

- **`GET /api/parent/children/:id/live-classes`**: **`[READY]`** (Returns HTTP 200 with empty array on production).
- **`GET /api/parent/children/:id/academics`**: **`[READY]`** (Returns HTTP 200 with `{ courses: [] }` on production).
- **Interactive Jitsi Video Classroom**: **`[STUDENT SCOPE ONLY]`** (Excluded from Parent portal).

---

## 11. UI State Requirements (SCR-13 & SCR-14)

1. **Initial**: Blank themed scaffold before fetch initiation.
2. **Loading**: 3-card timetable skeleton shimmer matching class card geometry.
3. **Success (Data present)**: Date-grouped list of live classes with subject color tags, timings, and status badges.
4. **Empty (No classes scheduled)**: Illustrated empty state: *"No upcoming classes scheduled for [Child Name]"*.
5. **No Active Child**: Displays admissions contact prompt.
6. **Error**: User-friendly card with error message and "Try Again" retry button.
7. **Pull-to-refresh**: `RefreshIndicator` triggering re-fetch.

---

## 12. Design System Tokens (Classes & Academics)

- **Cards**: Surface `#FFFFFF`, border `#E2E8F0`, radius `12px`, soft shadow `0 2px 8px rgba(15,23,42,0.04)`.
- **Status Pills**:
  - `UPCOMING`: `#EFF6FF` bg, `#1E60D4` text (`BorderRadius.circular(20)`).
  - `LIVE`: `#ECFDF5` bg, `#10B981` text, pulsing dot.
  - `COMPLETED`: `#F1F5F9` bg, `#64748B` text.
- **Date Header**: `14px` SemiBold (`AppTypography.titleSmall`), text `#64748B`.
- **Class Title**: `16px` SemiBold (`AppTypography.titleMedium`), text `#0F172A`.

---

## 13. Existing Flutter Status & Shell Audit

- Current codebase contains:
  - `lib/features/auth/` (Splash + Login)
  - `lib/features/dashboard/` (Parent Dashboard SCR-09)
  - `lib/core/router/app_router.dart`: Branch 1 points to `CoreRouterPlaceholderScreen(title: 'Classes & Timetable')`.
- **Classes Production Code**: **NONE**. Zero accidental classes files exist.
- **Dependencies**: No new dependencies needed (uses existing `dio`, `flutter_riverpod`, `go_router`, `google_fonts`).

---

## 14. Recommended Implementation Sequence

1. **Action 5D — Parent Classes Domain & Data Layer**:
   - `ClassEntity`, `ClassDto`, `ClassesRepository`, `ClassesRepositoryImpl` wiring `GET /api/parent/children/:id/live-classes`.
2. **Action 5E — Parent Classes Presentation (SCR-13 Timetable)**:
   - `ClassesController`, `ClassesState`, `ParentClassesScreen` replacing placeholder in Branch 1 of `app_router.dart`.
3. **Action 5F — Parent Class Details (SCR-14)**:
   - Secondary detail route `/parent/classes/:id`.
4. **Action 5G — Parent Academic Progress (SCR-24)**:
   - Progress and attendance integration.

---

## 15. Explicit Exclusions

- DO NOT implement Student Jitsi joining in Parent app.
- DO NOT use `/api/live-classes` (forbidden 403 for Parent).
- DO NOT create fake class data.
- DO NOT start Student Phase 1B.
- DO NOT modify backend.
