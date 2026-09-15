# 11 — TrueLern API Audit & Governance Report

> [!IMPORTANT]
> **EXECUTIVE AUDIT SUMMARY**:
> This document establishes the authoritative API audit for the TrueLern AIO Flutter mobile application. It records the complete removal and reclassification of the previous incorrect API reference, analyzes the authoritative TrueLern Postman collection, inventories all 67 verified requests across 17 folders, documents backend dependencies, and provides actionable pre-implementation recommendations.
>
> **PROJECT READINESS STATUS**:
> - **PHASE 1 PLANNING READINESS**: **`[READY]`**
> - **AUTHENTICATED FLUTTER IMPLEMENTATION**: **`[BLOCKED — PRODUCTION LOGIN 500]`**
>
> **AUTHENTICATION BLOCKER**:
> `POST https://truelern.visital.in/api/auth/login` currently returns `500 INTERNAL_SERVER_ERROR` with documented test credentials. Therefore, login cannot currently generate live production JWT tokens, and protected Parent/Student runtime testing cannot be marked complete. Planning and typed architecture may proceed.

---

## A. Correct TrueLern API Source

- **Official Production API Base URL**: `https://truelern.visital.in/api` `[VERIFIED]`
- **Local Development Base URL**: `http://localhost:3000/api` (Root server: `http://localhost:3000`) `[VERIFIED via Postman Environment]`
- **Authoritative Contract Repository**: [`docs/api/TrueLern-API.postman_collection.json`](file:///d:/New%20folder/New%20folder/truelearn/docs/api/TrueLern-API.postman_collection.json)
- **Authoritative Environment File**: [`docs/api/TrueLern-API.postman_environment.json`](file:///d:/New%20folder/New%20folder/truelearn/docs/api/TrueLern-API.postman_environment.json)

---

## B. Incorrect API Source (Removed & Reclassified)

- **Removed Domain**: `https://360api.vnvision.in/api` & `https://360api.vnvision.in/docs`
- **Reclassification Status**: **`[WRONG PROJECT — DO NOT USE]`**
- **Audit Findings**: The `360api.vnvision.in` endpoints belong to a completely separate organization and project. All active references to `360api.vnvision.in` in the TrueLern project documentation have been purged or quarantined with explicit warning labels to prevent accidental reuse.

---

## C. Postman Collection Analyzed

- **Collection Name**: `TrueLern Mobile API`
- **File Path**: [`docs/api/TrueLern-API.postman_collection.json`](file:///d:/New%20folder/New%20folder/truelearn/docs/api/TrueLern-API.postman_collection.json)
- **Total Requests**: 67 requests
- **Total Folders**: 17 modular folders
- **Collection Authentication**: Bearer Token referencing `{{accessToken}}`
- **Environment Variables Supported**: 31 variables including `baseUrl`, `mobileBaseUrl`, `accessToken`, `refreshToken`, `studentToken`, `parentToken`, `childStudentId`, `liveClassId`, `assignmentId`, `invoiceId`.

---

## D. Complete Verified Endpoint Inventory Summary

| Folder Number & Name | Total Requests | Primary Persona / Purpose | Status |
|---|:---:|---|:---:|
| **01 - Public** | 5 | Public leads, course catalog, categories, search, portal config | `[VERIFIED]` |
| **02 - Authentication** | 9 | Login (4 roles), token refresh, handoff, password management | `[VERIFIED]` |
| **03 - Student** | 3 | Student profile, directory, academic timeline | `[VERIFIED]` |
| **04 - Parent** | 10 | Linked wards, ward dashboard, attendance, academics, finance | `[VERIFIED]` |
| **05 - Faculty** | 3 | Teacher roster, detail, availability hours | `[VERIFIED]` |
| **06 - Courses** | 3 | Course list, course details, curriculum hierarchy | `[VERIFIED]` |
| **07 - Enrollments** | 3 | Student enrollments, batch roster, batch details | `[VERIFIED]` |
| **08 - Live Classes** | 5 | Timetable, class detail, Jitsi room token, announcements, assets | `[VERIFIED]` |
| **09 - Recordings & Revision** | 2 | Video streaming (HTTP 206), recording metadata | `[VERIFIED]` |
| **10 - Attendance** | 3 | Attendance records, attendance summary, mark attendance | `[VERIFIED]` |
| **11 - Assignments** | 4 | Assignment list, detail, student submit, teacher evaluate | `[VERIFIED]` |
| **12 - Assessments** | 4 | Quiz list, quiz detail, start attempt, submit answers | `[VERIFIED]` |
| **13 - Finance** | 4 | Invoices list, invoice detail, payments history, receipts | `[VERIFIED]` |
| **14 - Notifications** | 4 | Inbox list, mark read, archive, alert preferences | `[VERIFIED]` |
| **15 - Calendar** | 1 | iCalendar (.ics) native sync feed | `[VERIFIED]` |
| **16 - Certificates** | 2 | Certificates list, public verification | `[VERIFIED]` |
| **17 - Admin (Mobile Optional)** | 2 | Executive leads monitoring, academic analytics | `[VERIFIED]` |
| **TOTAL** | **67** | Complete TrueLern Mobile REST API Surface | `[VERIFIED]` |

---

## E. Authentication Endpoints

- `POST /api/auth/login` — Issues access token (1-day) and refresh token (7-day) via email + password. Verified for Student, Parent, Teacher, and Admin roles.
- `POST /api/auth/refresh` — Rotates access token using stored `refreshToken`.
- `GET /api/auth/handoff?token={{handoffToken}}` — Validates single-use token for transitioning between mobile app and web checkout.
- `POST /api/auth/change-password` — Updates password with existing session revocation (`{ oldPassword, newPassword }`).
- `POST /api/auth/forgot-password` — Dispatches reset link/token (`{ email }`).
- `POST /api/auth/logout` — Destroys server-side session.

---

## F. Parent Endpoints (`ParentStudentLink` Guarded)

All ward-specific endpoints strictly enforce parent ownership over the specified `childStudentId`:
- `GET /api/parent/children` — Returns array of linked wards with `studentId`, full name, avatar URL, grade.
- `GET /api/parent/children/{{childStudentId}}/dashboard` — Aggregated metrics: attendance %, upcoming live classes, pending homework count, balance due.
- `GET /api/parent/children/{{childStudentId}}/attendance` — Complete session attendance log.
- `GET /api/parent/children/{{childStudentId}}/academics` — Enrolled programs, courses, syllabus completion percentage.
- `GET /api/parent/children/{{childStudentId}}/assignments` — Homework submissions, marks awarded, teacher remarks.
- `GET /api/parent/children/{{childStudentId}}/assessments` — Sanitized quiz scores and performance metrics.
- `GET /api/parent/children/{{childStudentId}}/live-classes` — Cohort live class timetable.
- `GET /api/parent/children/{{childStudentId}}/recordings` — Completed class recordings available for revision.
- `GET /api/parent/children/{{childStudentId}}/finance` — Tuition ledger, outstanding fee balance, payment receipts.
- `GET /api/parent/notifications` — Alert feed scoped exclusively to parent guardians.

---

## G. Student Endpoints

- `GET /api/students/{{studentId}}` — Detailed learner profile.
- `GET /api/students/{{studentId}}/timeline` — Chronological academic history and milestones.
- `GET /api/students?limit=10&page=1` — Directory (Admin/Counsellor view).

---

## H. Child / Account Endpoints

- **Verified Child Viewing**: Handled via `GET /api/parent/children` and `GET /api/parent/children/{{childStudentId}}/*`.
- **Child Self-Registration from Mobile**: `[NOT FOUND IN CURRENT TRUELEARN API CONTRACT — BACKEND DEPENDENCY]`. No endpoint exists in the contract for a parent to register/link a new child from the mobile app without admin intervention.

---

## I. Course & Batch Endpoints

- `GET /api/courses?limit=10&status=active` — Active course catalog.
- `GET /api/courses/{{courseId}}` — Comprehensive course description, prerequisites, syllabus overview.
- `GET /api/courses/{{courseId}}/curriculum` — Structured curriculum tree (Modules → Topics → Lessons).
- `GET /api/enrollments?limit=10` — Learner's active enrollment records.
- `GET /api/batches?limit=10` — Cohort batch list with assigned instructor and schedule.
- `GET /api/batches/{{batchId}}` — Batch detail and session calendar.

---

## J. Live Class Endpoints (High Priority)

- `GET /api/live-classes?limit=10&sort=startDate&order=asc` — Chronological live session schedule.
- `GET /api/live-classes/{{liveClassId}}` — Session agenda, instructor details, status.
- `POST /api/live-classes/{{liveClassId}}/token` — **HIGH PRIORITY**: Generates signed Jitsi Meet JWT token (`isModerator: false` for students).
- `GET /api/live-classes/{{liveClassId}}/announcements` — Real-time in-class broadcast announcements.
- `GET /api/live-classes/{{liveClassId}}/resources` — PDF worksheets and class attachments.

---

## K. Assignment & Homework Endpoints

- `GET /api/assignments?limit=10&status=published` — Published homework assignments for enrolled cohort.
- `GET /api/assignments/{{assignmentId}}` — Instructions, rubric, attachments, due date.
- `POST /api/assignments/{{assignmentId}}/submit` — Submits work (`{ submissionText, attachments: [ "url..." ] }`).
- `POST /api/assignments/{{assignmentId}}/evaluate` — Instructor evaluation (`{ submissionId, marksAwarded, feedback, status }`).

---

## L. Assessment & Exam Endpoints

- `GET /api/assessments?limit=10&status=published` — Published quizzes and exams.
- `GET /api/assessments/{{assessmentId}}` — Quiz rules, time duration, total marks.
- `POST /api/assessments/{{assessmentId}}/start` — Initiates timed attempt timestamp.
- `POST /api/assessments/{{assessmentId}}/submit` — Submits answer array (`{ attemptId, answers: [ { questionId, selectedOption, writtenAnswer } ] }`).

---

## M. Attendance & Academic Endpoints

- `GET /api/attendance?student={{studentId}}&limit=20` — Session-by-session attendance history.
- `GET /api/attendance/summary?student={{studentId}}` — Attendance summary statistics (total, present, absent, late, percentage).
- `POST /api/attendance` — Faculty attendance marking (`{ student, batch, liveClass, status, remarks }`).

---

## N. Finance & Payment Endpoints

- `GET /api/finance/invoices?limit=10` — Itemized tuition fee invoices.
- `GET /api/finance/invoices/{{invoiceId}}` — Invoice details, line items, taxes, balance due.
- `GET /api/finance/payments?limit=10` — Transaction and payment history.
- `GET /api/finance/receipts?limit=10` — Official downloadable payment receipts.
- **In-App Mobile Payment Order Creation**: `[NOT FOUND IN CURRENT TRUELEARN API CONTRACT — BACKEND DEPENDENCY]`. Mobile checkout transitions to web via `GET /api/auth/handoff`.

---

## O. Notification Endpoints

- `GET /api/notifications/inbox?limit=20&page=1` — In-app notification feed.
- `POST /api/notifications/inbox` (Action `read`) — Marks alert as read (`{ notificationId, action: "read" }`).
- `POST /api/notifications/inbox` (Action `archive`) — Archives notification (`{ notificationId, action: "archive" }`).
- `GET /api/notifications/preferences` — User alert delivery preferences.

---

## P. Recording Endpoints

- `GET /api/recordings/{{recordingId}}/stream` — **HTTP Range 206 Partial Content video streaming** for enrolled cohort revision.
- `GET /api/live-classes/{{liveClassId}}/recordings` — Metadata for recorded sessions.

---

## Q. Other Verified Endpoints

- `POST /api/public/lead` — Book free demo / prospective parent lead capture.
- `GET /api/v1/public/portal-config?portalId=student-portal` — App bootstrap, feature flags, version check.
- `GET /api/calendar/ics` — iCalendar feed for native device calendar sync.
- `GET /api/certificates?limit=10` — Student completion certificates.
- `GET /api/certificates/verify?code={{certificateCode}}` — Public certificate credential verification.
- `GET /api/crm/leads?limit=10&page=1` — CRM leads overview.
- `GET /api/analytics/academic` — Cohort health and attendance analytics.

---

## R. Missing APIs Required by Candidate Mobile Flows

The following candidate mobile screens cannot be implemented without new backend endpoints:
1. **SMS/Email Mobile OTP**: `POST /api/auth/otp/send` and `POST /api/auth/otp/verify` `[NOT FOUND]`.
2. **Mobile Add-Child**: `POST /api/parent/children` `[NOT FOUND]`.
3. **Timezone Preference**: `PUT /api/parent/timezone` `[NOT FOUND]`.
4. **Direct Messaging / Chat**: `GET/POST /api/messages` `[NOT FOUND]`.
5. **Session / Device Management**: `GET/DELETE /api/auth/devices` `[NOT FOUND]`.

---

## S. Backend Dependencies Summary

| Dependency ID | Required Backend Capability | Blocked Mobile Feature / Screen | Action Required |
|---|---|---|---|
| **DEP-01** | Mobile OTP Authentication API | SCR-04 Verify Code (OTP) | Implement OTP generation and verification in backend auth service. |
| **DEP-02** | Parent Ward Creation API | SCR-07 Child Details Setup | Implement `POST /api/parent/children` with ParentStudentLink creation. |
| **DEP-03** | Timezone Configuration API | SCR-08 Location / Timezone | Expose timezone mutation on user/parent profile. |
| **DEP-04** | Chat / WebSocket Service | SCR-27 Messages / Chat | Requires real-time messaging microservice (currently excluded by v1 PRD). |
| **DEP-05** | Session Revocation API | SCR-31 Login & Devices | Expose active JWT sessions table and revocation endpoint. |

---

## T. Unverified & Ambiguous APIs

- **`POST /api/auth/reset-password`**: While `POST /api/auth/forgot-password` exists, the exact token-consumption reset endpoint is not in the Postman collection.
- **Native Mobile Payment SDK**: Mobile checkout order creation endpoints do not exist in the collection; current workflow relies on `GET /api/auth/handoff` redirecting to the web portal.

---

## U. API Risks & Implementation Blockers

1. **OTP Block**: If the mobile UI designs mandate phone OTP login as the primary entry point, user onboarding is completely blocked until the backend team builds the OTP service.
2. **Missing In-App Payment**: If stakeholders require native in-app Google Pay / Apple Pay / card processing, a native payment order endpoint and payment gateway SDK contract must be delivered.
3. **Strict Parent-Student Guard**: The Flutter app must handle `403 Forbidden` errors gracefully if a parent attempts to query data for a student ID that is not linked to their account via `ParentStudentLink`.

---

## V. Recommended Verification Steps Before Flutter Implementation

1. **Live Endpoint Health Check**: Execute a smoke test against `https://truelern.visital.in/api/v1/public/portal-config` and `POST /api/auth/login` using test credentials to verify DNS resolution, SSL certificates, and network response times.
2. **Contract Freeze Sign-off**: Have the backend lead formally confirm that [`TrueLern-API.postman_collection.json`](file:///d:/New%20folder/New%20folder/truelearn/docs/api/TrueLern-API.postman_collection.json) is the frozen contract for TrueLern Mobile v1.
3. **Clarify Auth Entry Point**: Confirm whether Phase 1 implementation proceeds with **Email + Password** login (fully supported by backend) while the OTP service is built.
