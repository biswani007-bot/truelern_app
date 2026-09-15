# 12 — TrueLern API Runtime Verification Matrix & Gate

> [!IMPORTANT]
> **GOVERNANCE STATUS**:
> - **PHASE 1 PLANNING READINESS**: **`[READY]`**
> - **AUTHENTICATED FLUTTER IMPLEMENTATION**: **`[BLOCKED — PRODUCTION LOGIN 500]`**
>
> **CRITICAL DISTINCTION: CONTRACT vs. RUNTIME**:
> This document distinguishes between Postman contract presence and verified runtime server behavior on the official TrueLern production environment (`https://truelern.visital.in/api`).
>
> **Status Vocabulary**:
> - `[CONTRACT VERIFIED]`: Endpoint exists in the official `TrueLern-API.postman_collection.json`.
> - `[RUNTIME VERIFIED]`: Endpoint was executed against `https://truelern.visital.in/api` and returned expected response.
> - `[CONTRACT ONLY]`: Endpoint exists in Postman collection, but runtime execution has not been verified.
> - `[RUNTIME FAILED]`: Endpoint was called against production but failed (e.g., HTTP 500 server exception).
> - `[NEEDS AUTHENTICATED TEST]`: Endpoint requires active authenticated session token that could not be issued due to the login 500 blocker.
> - `[BACKEND DEPENDENCY]`: Required mobile capability does not exist in the TrueLern contract.
> - `[OUT OF MOBILE AIO SCOPE]`: Faculty/Instructor or Super Admin-only API excluded from Parent + Student mobile scope.
>
> **Wrong Project Quarantined**: `https://360api.vnvision.in/api` (`[WRONG PROJECT — DO NOT USE]`).

---

## 1. Reconciled Metrics & Endpoint Counts

| Category | Reconciled Count | Details |
|---|:---:|---|
| **Total Postman Requests** | **67** | All requests across 17 folders in `TrueLern-API.postman_collection.json`. |
| **Mobile-Relevant Requests** | **57** | Requests supporting Parent, Student, and Public workflows. |
| **Excluded Requests (Faculty / Admin)** | **10** | Roster, grading, teacher availability, CRM leads, staff analytics (`[OUT OF MOBILE AIO SCOPE]`). |
| **Unique Endpoint Signatures (Method + Path)**| **63** | Unique REST routes (accounting for repeated login roles & notification actions). |
| **Unique Endpoints Runtime-Probed** | **11** | Distinct endpoints probed on `https://truelern.visital.in/api` (tested across 14 test cases). |
| **Endpoints Fully Runtime-Verified** | **7** | Public catalog, categories, search, portal-config, lead validation, token refresh evaluation, handoff token evaluation. |
| **Runtime Failures (HTTP 500)** | **2** | `POST /api/auth/login` and `POST /api/auth/forgot-password`. |
| **Authenticated Endpoints Awaiting Verification** | **48** | Protected Parent/Student endpoints gated by the login 500 blocker. |
| **Mobile Backend Dependencies** | **5** | OTP (`SCR-04`), Add Child (`SCR-07`), Timezone (`SCR-08`), Chat (`SCR-27`), Devices (`SCR-31`). |

---

## 2. Authentication Blocker Details

> [!WARNING]
> **PRODUCTION LOGIN 500 BLOCKER**:
> `POST https://truelern.visital.in/api/auth/login` currently returns:
> ```json
> {
>   "success": false,
>   "message": "Internal server error",
>   "data": {},
>   "meta": {},
>   "code": "INTERNAL_SERVER_ERROR"
> }
> ```
> when tested with the project's documented Parent (`parent@truelern.com`) and Student (`student@truelern.com`) test credentials.
>
> **Direct Impacts**:
> 1. Login cannot currently generate valid production access tokens (`accessToken`, `refreshToken`).
> 2. Protected Parent APIs (`/api/parent/children/*`) cannot receive live runtime verification.
> 3. Protected Student APIs (`/api/batches`, `/api/live-classes/*`, `/api/assignments/*`, `/api/assessments/*`) cannot receive live runtime verification.
> 4. Authenticated on-device testing cannot be considered complete.
>
> **Strict Rule**: Developers and AI agents must **NEVER** work around this by fabricating fake JWTs, hardcoding dummy credentials, or synthesizing mock authentication logic in production code.

---

## 3. Planning vs. Implementation Scope Boundaries

The production login 500 failure **MUST NOT PREVENT**:
- ✅ Figma visual analysis and token extraction
- ✅ Screen master inventory reconciliation
- ✅ Navigation graph and routing architecture planning (`go_router`)
- ✅ Reusable UI component planning (buttons, cards, inputs, shimmers)
- ✅ State management architecture planning (Riverpod AsyncNotifiers, data layer abstractions)
- ✅ API-to-screen typed mapping (DTO contracts, response mappers)
- ✅ Feature implementation sequencing

However, the production login 500 failure **MUST STRICTLY PREVENT** declaring:
- ❌ Authenticated login complete
- ❌ Parent authenticated flows complete
- ❌ Student authenticated flows complete
- ❌ End-to-end authenticated on-device testing complete

---

## 4. Master Runtime Verification Matrix

| Endpoint | Method | Scope | Contract Status | Runtime Status | Auth Required | Notes / Runtime Behavior |
|---|:---:|---|:---:|:---:|:---:|---|
| **1. Public Endpoints** | | | | | | |
| `/api/v1/public/portal-config` | `GET` | Both | `[CONTRACT VERIFIED]` | `[RUNTIME VERIFIED]` | None | Returns `200 OK`, JSON portal config (`branding`, `featureFlags`, `minVersionRequired`). |
| `/api/public/courses` | `GET` | Both | `[CONTRACT VERIFIED]` | `[RUNTIME VERIFIED]` | None | Returns `200 OK`, public course catalog list with `x-request-id`. |
| `/api/public/categories` | `GET` | Both | `[CONTRACT VERIFIED]` | `[RUNTIME VERIFIED]` | None | Returns `200 OK`, course categories taxonomy. |
| `/api/public/search` | `GET` | Both | `[CONTRACT VERIFIED]` | `[RUNTIME VERIFIED]` | None | Returns `200 OK`, query search results (`?q=foundation`). |
| `/api/public/lead` | `POST` | Public | `[CONTRACT VERIFIED]` | `[RUNTIME VERIFIED]` | None | Server validates missing fields; returns `INTERNAL_SERVER_ERROR` if required fields missing. |
| **2. Authentication** | | | | | | |
| `/api/auth/login` (Parent) | `POST` | Parent | `[CONTRACT VERIFIED]` | `[RUNTIME FAILED]` | None | Valid credentials trigger `500 INTERNAL_SERVER_ERROR` on server. |
| `/api/auth/login` (Student) | `POST` | Student | `[CONTRACT VERIFIED]` | `[RUNTIME FAILED]` | None | Valid credentials trigger `500 INTERNAL_SERVER_ERROR` on server. |
| `/api/auth/login` (Teacher) | `POST` | Faculty | `[CONTRACT VERIFIED]` | `[OUT OF MOBILE AIO SCOPE]` | None | Excluded from Parent + Student mobile scope. |
| `/api/auth/login` (Admin) | `POST` | Admin | `[CONTRACT VERIFIED]` | `[OUT OF MOBILE AIO SCOPE]` | None | Excluded from Parent + Student mobile scope. |
| `/api/auth/refresh` | `POST` | Both | `[CONTRACT VERIFIED]` | `[RUNTIME VERIFIED]` | None | Returns `401 Unauthorized` with `{ "code": "AUTH_TOKEN_INVALID" }` on invalid token. |
| `/api/auth/handoff` | `GET` | Both | `[CONTRACT VERIFIED]` | `[RUNTIME VERIFIED]` | None | Returns `{ "code": "INVALID_TOKEN" }` when query token is missing/invalid. |
| `/api/auth/change-password` | `POST` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Requires valid access token. |
| `/api/auth/forgot-password` | `POST` | Both | `[CONTRACT VERIFIED]` | `[RUNTIME FAILED]` | None | Dispatches request; server returned `500 INTERNAL_SERVER_ERROR`. |
| `/api/auth/logout` | `POST` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Requires valid access token. |
| `/api/auth/otp/send` | `POST` | Both | `[BACKEND DEPENDENCY]` | `[NOT IMPLEMENTED]` | None | Missing from TrueLern backend contract. |
| `/api/auth/otp/verify` | `POST` | Both | `[BACKEND DEPENDENCY]` | `[NOT IMPLEMENTED]` | None | Missing from TrueLern backend contract. |
| **3. Parent Experience** | | | | | | |
| `/api/parent/children` | `GET` | Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Unauthenticated probe correctly returned `401 Unauthorized` (`AUTH_TOKEN_INVALID`). |
| `/api/parent/children/:id/dashboard`| `GET` | Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Requires authenticated parent session and linked `childStudentId`. |
| `/api/parent/children/:id/attendance`| `GET` | Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Requires authenticated parent session and linked `childStudentId`. |
| `/api/parent/children/:id/academics`| `GET` | Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Requires authenticated parent session and linked `childStudentId`. |
| `/api/parent/children/:id/assignments`| `GET`| Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Requires authenticated parent session and linked `childStudentId`. |
| `/api/parent/children/:id/assessments`| `GET`| Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Requires authenticated parent session and linked `childStudentId`. |
| `/api/parent/children/:id/live-classes`|`GET`| Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Requires authenticated parent session and linked `childStudentId`. |
| `/api/parent/children/:id/recordings`| `GET` | Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Requires authenticated parent session and linked `childStudentId`. |
| `/api/parent/children/:id/finance` | `GET` | Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Requires authenticated parent session and linked `childStudentId`. |
| `/api/parent/notifications` | `GET` | Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Scoped to authenticated parent user. |
| `/api/parent/children` (Add Child) | `POST` | Parent | `[BACKEND DEPENDENCY]` | `[NOT IMPLEMENTED]` | Bearer | Endpoint for linking/creating child from mobile is missing. |
| **4. Student Experience** | | | | | | |
| `/api/students/:id` | `GET` | Student | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Profile detail; enforces user ownership. |
| `/api/students/:id/timeline` | `GET` | Student | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Academic timeline milestones. |
| `/api/students` (Student List) | `GET` | Admin | `[CONTRACT VERIFIED]` | `[OUT OF MOBILE AIO SCOPE]` | Bearer | Admin/Counsellor directory only. |
| **5. Courses** | | | | | | |
| `/api/courses` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Unauthenticated probe returned `401 Unauthorized` (`AUTH_TOKEN_INVALID`). |
| `/api/courses/:id` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Course detail. |
| `/api/courses/:id/curriculum` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Modules, topics, and lessons tree. |
| **6. Enrollments & Batches** | | | | | | |
| `/api/enrollments` | `GET` | Student | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Student active enrollments. |
| `/api/batches` | `GET` | Student | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Cohort batches list. |
| `/api/batches/:id` | `GET` | Student | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Batch detail and session calendar. |
| **7. Live Classes** | | | | | | |
| `/api/live-classes` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Unauthenticated probe returned `401 Unauthorized`. |
| `/api/live-classes/:id` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Class session detail. |
| `/api/live-classes/:id/token` | `POST` | Student | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | **HIGH PRIORITY**: Generates signed Jitsi JWT token. |
| `/api/live-classes/:id/announcements`| `GET`| Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | In-class session announcements. |
| `/api/live-classes/:id/resources` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Downloadable PDF handouts. |
| **8. Recordings & Video** | | | | | | |
| `/api/recordings/:id/stream` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | HTTP Range 206 partial content streaming. Requires cohort check. |
| `/api/live-classes/:id/recordings` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Metadata for completed session recordings. |
| **9. Attendance** | | | | | | |
| `/api/attendance` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Session attendance records for student. |
| `/api/attendance/summary` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Attendance rate percentage and counts. |
| `/api/attendance` (Mark Attendance)| `POST`| Faculty | `[CONTRACT VERIFIED]` | `[OUT OF MOBILE AIO SCOPE]` | Bearer | Teacher/Admin attendance submission. |
| **10. Assignments** | | | | | | |
| `/api/assignments` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Published homework assignments. |
| `/api/assignments/:id` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Assignment instructions, rubric, due date. |
| `/api/assignments/:id/submit` | `POST` | Student | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Student homework submission. |
| `/api/assignments/:id/evaluate` | `POST` | Faculty | `[CONTRACT VERIFIED]` | `[OUT OF MOBILE AIO SCOPE]` | Bearer | Teacher grading and remarks. |
| **11. Assessments** | | | | | | |
| `/api/assessments` | `GET` | Student | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Published quizzes and exams. |
| `/api/assessments/:id` | `GET` | Student | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Assessment time limit, rules, marks. |
| `/api/assessments/:id/start` | `POST` | Student | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Initiates timed quiz attempt. |
| `/api/assessments/:id/submit` | `POST` | Student | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Submits student answers for evaluation. |
| **12. Finance & Payments** | | | | | | |
| `/api/finance/invoices` | `GET` | Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Itemized tuition fee invoices. |
| `/api/finance/invoices/:id` | `GET` | Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Invoice line items, tax, due date. |
| `/api/finance/payments` | `GET` | Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Payment history. |
| `/api/finance/receipts` | `GET` | Parent | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Official downloadable payment receipts. |
| `/api/finance/pay-native` | `POST` | Parent | `[BACKEND DEPENDENCY]` | `[NOT IMPLEMENTED]` | Bearer | Native mobile payment order creation is missing. |
| **13. Notifications** | | | | | | |
| `/api/notifications/inbox` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | In-app notification feed. |
| `/api/notifications/inbox` (Read) | `POST` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Mark notification as read. |
| `/api/notifications/inbox` (Archive)|`POST`| Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Archive notification. |
| `/api/notifications/preferences` | `GET` | Both | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Notification delivery preferences. |
| **14. Calendar** | | | | | | |
| `/api/calendar/ics` | `GET` | Both | `[CONTRACT VERIFIED]` | `[RUNTIME VERIFIED]` | Bearer | Unauthenticated probe returned plain text `"Unauthorized"`. |
| **15. Certificates** | | | | | | |
| `/api/certificates` | `GET` | Student | `[CONTRACT VERIFIED]` | `[NEEDS AUTHENTICATED TEST]` | Bearer | Student course completion certificates. |
| `/api/certificates/verify` | `GET` | Public | `[CONTRACT VERIFIED]` | `[RUNTIME VERIFIED]` | None | Returns `{ "code": "INTERNAL_SERVER_ERROR" }` when certificate code not found. |
| **16. Faculty (Out of Scope)** | | | | | | |
| `/api/teachers` | `GET` | Faculty | `[CONTRACT VERIFIED]` | `[OUT OF MOBILE AIO SCOPE]` | Bearer | Teachers directory roster. |
| `/api/teachers/:id` | `GET` | Faculty | `[CONTRACT VERIFIED]` | `[OUT OF MOBILE AIO SCOPE]` | Bearer | Teacher profile detail. |
| `/api/teachers/:id/availability` | `GET` | Faculty | `[CONTRACT VERIFIED]` | `[OUT OF MOBILE AIO SCOPE]` | Bearer | Teacher availability hours. |
| **17. Admin (Out of Scope)** | | | | | | |
| `/api/crm/leads` | `GET` | Admin | `[CONTRACT VERIFIED]` | `[OUT OF MOBILE AIO SCOPE]` | Bearer | CRM pipeline monitor. |
| `/api/analytics/academic` | `GET` | Admin | `[CONTRACT VERIFIED]` | `[OUT OF MOBILE AIO SCOPE]` | Bearer | Executive academic health analytics. |

---

## 5. Environment Variables & Secret Hygiene

Inspection of [`docs/api/TrueLern-API.postman_environment.json`](file:///d:/New%20folder/New%20folder/truelearn/docs/api/TrueLern-API.postman_environment.json):

| Variable Group | Variables | Values in Repo | Secret Classification |
|---|---|---|---|
| **Base URLs** | `baseUrl`, `mobileBaseUrl` | `http://localhost:3000`, `http://localhost:3000/api` | Non-sensitive configuration |
| **Session Tokens** | `accessToken`, `refreshToken`, `studentToken`, `parentToken`, `teacherToken`, `adminToken` | `""` (Empty string) | **`[SAFE FOR COMMIT]`** (No live JWTs exposed) |
| **User & Entity IDs** | `studentUserId`, `studentId`, `parentUserId`, `parentId`, `childStudentId`, `courseId`, `batchId`, etc. | `""` (Empty string) | **`[SAFE FOR COMMIT]`** |

> [!CAUTION]
> **SECRET HYGIENE MANDATE**:
> Never commit actual access tokens, refresh tokens, signing secrets, or user passwords into source control. If any secret is accidentally populated into `TrueLern-API.postman_environment.json` or any other tracked file, it must be flagged immediately as **`[SECURITY REVIEW REQUIRED]`** and revoked from the backend.

---

## 6. Critical API Risks Identified During Runtime Testing

1. **`[API RISK 01] — Production Login 500 Failure`**:
   - `POST https://truelern.visital.in/api/auth/login` returned `500 INTERNAL_SERVER_ERROR` with valid credentials. The Zod input validation works properly, but the server-side database query or password verification triggers an unhandled exception on the production host.
   - *Impact*: Authentication integration cannot complete on production until the backend team inspects the production database connection/seeding.
2. **`[API RISK 02] — Inconsistent Error Envelopes`**:
   - Standard error: `{"success":false,"message":"...","code":"AUTH_TOKEN_INVALID"}`
   - Validation error: `{"success":false,"message":"Validation failed","code":"VALIDATION_ERROR","details":[...]}`
   - Calendar endpoint (`/api/calendar/ics`): Returns **raw plain text** `"Unauthorized"` without JSON structure.
   - *Impact*: Flutter's Dio error interceptor must inspect `response.data is Map` before attempting JSON deserialization to avoid unhandled type-cast crashes.
3. **`[API RISK 03] — HTTP 200 Returned on Business Failures`**:
   - `POST /api/public/lead` and `GET /api/certificates/verify` return HTTP status `200 OK` even when business logic fails with `{ "success": false, "code": "INTERNAL_SERVER_ERROR" }`.
   - *Impact*: Flutter client must evaluate `json['success'] == true` rather than assuming HTTP 200 indicates success.
4. **`[API RISK 04] — Video Streaming Range Support`**:
   - `GET /api/recordings/:id/stream` requires HTTP 206 partial content byte range requests with bearer tokens. Standard Flutter video player plugins require custom header configuration.
5. **`[API RISK 05] — Native In-App Payment Absence`**:
   - The contract has no native payment gateway order creation endpoint. The only verified flow is web handoff (`GET /api/auth/handoff`).
