# 29 — Parent Classes Domain & Data Layer Implementation

**Document Status**: LOCKED — VERIFIED IMPLEMENTATION BASELINE  
**Action**: ACTION 5D — PARENT CLASSES DOMAIN & DATA LAYER  
**Project**: `truelearn` (Flutter Mobile Application)  
**Date**: September 2026  

---

## 1. Scope & Objective

This document provides the authoritative technical baseline for the **Parent Classes / Live Class Schedule** domain and data layers.

Per the Action 5D governance directive:
- **Implemented**: Domain entity (`ClassEntity`), DTO (`ClassDto`), domain repository interface (`ClassesRepository`), concrete repository implementation (`ClassesRepositoryImpl`), Riverpod provider (`classesRepositoryProvider`), and unit + live runtime tests.
- **Explicitly Excluded**: Classes UI (SCR-13, SCR-14, SCR-24), presentation widgets, controllers/states, router changes, student features, backend changes, web changes, or additional dependencies.

---

## 2. API Contract & Authority

### 2.1 Authoritative Endpoint
- **Method**: `GET`
- **Path**: `/api/parent/children/{childStudentId}/live-classes`
- **Postman Reference**: `docs/api/TrueLern-API.postman_collection.json` (Folder 04 — Parent, Item 7)
- **Role Requirement**: `PARENT` with verified `ParentStudentLink`.

### 2.2 Prohibited Endpoint
- **Path**: `GET /api/live-classes`
- **Discovery**: Returns `HTTP 403 Forbidden` (`{"message": "Not authorized, insufficient privileges"}`) for Parent tokens.
- **Rule**: Prohibited for all Parent app flows.

---

## 3. Child Context & Dynamic Input

Child context is supplied dynamically via `childStudentId`:
- **Source**: `ChildrenController.activeChildId` (retrieved from `GET /api/parent/children`).
- **Real Production Children Verified**:
  - `Mia Mercer`: `6a87e05e9b5f64a15873f66c`
  - `Alex Mercer`: `6a87011efae35df7c876b0ab`
- **Contract Signature**:
  ```dart
  Future<List<ClassEntity>> getLiveClasses(String childStudentId);
  ```
- **Constraint**: Zero hardcoded student IDs or child names exist in production code.

---

## 4. Response Structure & Defensive DTO Mapping

### 4.1 Server Response Shape
The production backend returns a standardized envelope:
```json
{
  "success": true,
  "message": "Child live classes retrieved successfully",
  "data": [],
  "meta": {}
}
```
When populated, items in `data` contain:
- `_id` / `id` (Session ID)
- `title` / `topic` / `name`
- `subject` (String or object `{ "name": "..." }`)
- `scheduledStartTime` / `startTime` / `startDate` (ISO 8601 string)
- `scheduledEndTime` / `endTime` / `endDate` (ISO 8601 string)
- `status` (`UPCOMING`, `LIVE`, `COMPLETED`, `CANCELLED`)
- `teacher` / `instructor` (Object `{ "name": "...", "avatar": "..." }` or String ID)
- `meetingUrl` / `roomName`

### 4.2 Empty Response Handling
On current production, `GET /api/parent/children/{childStudentId}/live-classes` returns:
```json
{
  "success": true,
  "message": "Child live classes retrieved successfully",
  "data": [],
  "meta": {}
}
```
The repository safely extracts `data` as `[]`, maps each item, and returns an empty Dart `List<ClassEntity>`. It does **not** throw exceptions, does **not** invent fake classes, and does **not** treat `[]` as an API error.

---

## 5. Domain & Data Components

### 5.1 Domain Entity
- File: [`lib/features/classes/domain/entities/class_entity.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/classes/domain/entities/class_entity.dart)
- Immutable entity containing:
  - `id`, `title`, `subject`, `scheduledStartTime`, `scheduledEndTime`, `status`, `teacherName`, `teacherAvatar`, `meetingUrl`, `roomName`
  - Helper getters: `isLive`, `isUpcoming`, `isCompleted`
  - Value equality based on `id`.

### 5.2 Data Model (DTO)
- File: [`lib/features/classes/data/models/class_dto.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/classes/data/models/class_dto.dart)
- Factory `ClassDto.fromJson(Map<String, dynamic> json)` with defensive null-checks and safe parsing for dates, teacher name/avatar, and nested subject objects.
- Method `toEntity()` converting DTO to `ClassEntity`.

### 5.3 Repository Contract
- File: [`lib/features/classes/domain/repositories/classes_repository.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/classes/domain/repositories/classes_repository.dart)
- Declares `Future<List<ClassEntity>> getLiveClasses(String childStudentId);`.

### 5.4 Repository Implementation
- File: [`lib/features/classes/data/repositories/classes_repository_impl.dart`](file:///d:/New%20folder/New%20folder/truelearn/lib/features/classes/data/repositories/classes_repository_impl.dart)
- Implements `ClassesRepository` via `ApiClient`.
- Automatically inherits `Authorization: Bearer <token>` through `AuthInterceptor`.
- Converts Dio exceptions through `ErrorHandler` to domain `Failure` instances (`ServerFailure`, `NetworkFailure`, `TimeoutFailure`, `AuthFailure`).
- Exposes `classesRepositoryProvider = Provider<ClassesRepository>`.

---

## 6. Verification Results

### 6.1 Unit Tests
- File: [`test/features/classes/classes_repository_test.dart`](file:///d:/New%20folder/New%20folder/truelearn/test/features/classes/classes_repository_test.dart)
- 10 automated unit tests covering:
  1. Populated class JSON parsing with nested teacher object.
  2. Teacher name fallback (`firstName` + `lastName`).
  3. Nested subject map parsing.
  4. Defensive null-handling on missing fields.
  5. Entity equality and hashCode.
  6. Empty list handling (`data: []`).
  7. Populated list mapping (`List<ClassEntity>`).
  8. Null or malformed data payload handling.
  9. HTTP 500 error mapping to `ServerFailure`.
  10. Connection failure mapping to `NetworkFailure`.

### 6.2 Real Runtime API Verification
- File: [`test/features/classes/real_classes_runtime_test.dart`](file:///d:/New%20folder/New%20folder/truelearn/test/features/classes/real_classes_runtime_test.dart)
- Result:
  ```
  ACTION 5D RUNTIME VERIFICATION
  Login success: true
  AuthState: Authenticated
  Access Token stored: true
  GET /api/parent/children count: 2
  Active Child: id=6a87e05e9b5f64a15873f66c, name=Mia Mercer
  GET /api/parent/children/6a87e05e9b5f64a15873f66c/live-classes count: 0
  Parsed ClassEntity list: []
  Live Classes API call returned HTTP 200 and parsed safely without exceptions.
  ```

### 6.3 Static Analysis & Test Suite
- `dart analyze .`: **0 issues found!**
- `flutter test`: **81/81 tests passing (100%)**.

---

## 7. Explicit Governance Checklist

- [x] Only Classes domain and data layers implemented.
- [x] SCR-13 (Class Schedule UI) NOT implemented.
- [x] SCR-14 (Class Details UI) NOT implemented.
- [x] SCR-24 (Learning Progress UI) NOT implemented.
- [x] No changes made to Parent Dashboard or Shell navigation.
- [x] No student features or Jitsi conferencing joining implemented.
- [x] No backend code modified.
- [x] No web code modified.
- [x] No fake class data created.
- [x] No hardcoded child IDs or names in production code.
- [x] Correct Parent endpoint `/api/parent/children/{id}/live-classes` used.
- [x] General `/api/live-classes` strictly avoided.
- [x] Reused existing `ApiClient`, `AuthInterceptor`, and `Failure` hierarchy.
- [x] Empty API response handled safely without exception.
- [x] Real production runtime verified.
- [x] 81/81 tests passing; 0 analyzer issues.
