# 03 — API Source of Truth (TrueLern API Contract)

> [!CAUTION]
> **CRITICAL ARCHITECTURAL WARNING — WRONG PROJECT REMOVAL**:
> The domain `https://360api.vnvision.in/api` and `https://360api.vnvision.in/docs` belong to an entirely different project and **MUST NOT BE USED UNDER ANY CIRCUMSTANCES**.
> Status: **`[WRONG PROJECT — DO NOT USE]`**
>
> The ONLY authoritative production API base URL for the TrueLern Flutter mobile application is:
> **`https://truelern.visital.in/api`**
>
> The primary authoritative API specification is the official Postman collection:
> [`docs/api/TrueLern-API.postman_collection.json`](file:///d:/New%20folder/New%20folder/truelearn/docs/api/TrueLern-API.postman_collection.json)
> and its environment:
> [`docs/api/TrueLern-API.postman_environment.json`](file:///d:/New%20folder/New%20folder/truelearn/docs/api/TrueLern-API.postman_environment.json).
>
> **PROJECT READINESS STATUS**:
> - **PHASE 1 PLANNING**: **`[READY]`**
> - **AUTHENTICATED FLUTTER IMPLEMENTATION**: **`[BLOCKED — PRODUCTION LOGIN 500]`** (Backend throws 500 on login; prevents live token generation).

---

## 1. Mandatory Governance: NO API INVENTION RULE

> [!IMPORTANT]
> **NO API INVENTION RULE**:
> Before implementing any Flutter API integration:
> 1. **Verify the endpoint exists** in the authoritative TrueLern API contract ([`TrueLern-API.postman_collection.json`](file:///d:/New%20folder/New%20folder/truelearn/docs/api/TrueLern-API.postman_collection.json)).
> 2. **Verify the exact HTTP method** (e.g., `GET`, `POST`, `PUT`, `DELETE`).
> 3. **Verify the request structure** (exact JSON keys, data types, headers, query parameters, path variables).
> 4. **Verify authentication requirements** (`BearerAuth` JWT token vs. Public).
> 5. **Verify the response structure** (envelope, data payload attributes, error structure).
> 6. **Verify role and access behavior** where available.
>
> **If ANY of these parameters are unknown, ambiguous, or missing from the contract:**
> **STOP AND MARK `[NEEDS CONFIRMATION]` OR `[BACKEND DEPENDENCY]`.**
>
> - DO NOT create an endpoint based on naming conventions.
> - DO NOT assume standard REST patterns exist where not documented.
> - DO NOT assume an endpoint exists simply because a similar endpoint exists in another system.
> - DO NOT copy APIs from another project.
> - DO NOT synthesize fake/mock endpoints or mock payloads in production code.

---

## 2. API Environment & Configuration

- **Production API Base URL**: `https://truelern.visital.in/api` `[VERIFIED]`
- **Development / Local Base URL**: `http://localhost:3000/api` `[VERIFIED via TrueLern Postman Environment]`
- **Local Server Root**: `http://localhost:3000` (`baseUrl` variable)
- **Environment Handling Rule**: All API URLs must be resolved dynamically through environment configuration (e.g., `--dart-define=ENVIRONMENT=production` or `AppConfig`) rather than hardcoding string URLs across Flutter feature repositories.

---

## 3. Authentication & Header Standards

### 3.1 Security Scheme
- **Mechanism**: JWT (JSON Web Token) via Bearer Authorization header.
- **Header Format**:
  ```http
  Authorization: Bearer <accessToken>
  Content-Type: application/json
  Accept: application/json
  ```
- **Collection-Level Auth**: Defined as `bearer` token referencing `{{accessToken}}`.

### 3.2 Token Lifecycle & Session Rotation
1. **Login**: `POST /api/auth/login` returns `{ accessToken, refreshToken, user: { _id, name, email, role } }`.
2. **Access Token Lifetime**: Short-lived JWT used for standard API queries.
3. **Refresh Token**: Stored securely in `flutter_secure_storage`. When any request receives an `HTTP 401 Unauthorized`, the client's `AuthInterceptor` must automatically invoke `POST /api/auth/refresh` passing `{ "refreshToken": "<token>" }`.
4. **Session Termination**: `POST /api/auth/logout` invalidates the server session, and the local secure token store is cleared.

### 3.3 Standard Response & Error Envelopes
- **Success Response**:
  ```json
  {
    "success": true,
    "message": "Operation completed successfully",
    "data": { ... },
    "meta": { "page": 1, "limit": 10, "total": 42, "totalPages": 5 }
  }
  ```
- **Error Response**:
  ```json
  {
    "success": false,
    "message": "Human-readable error description or validation message",
    "data": null,
    "errors": [ ... ]
  }
  ```

---

## 4. Complete Postman Endpoint Inventory (67 Requests across 17 Folders)

Every endpoint in this section is verified against [`TrueLern-API.postman_collection.json`](file:///d:/New%20folder/New%20folder/truelearn/docs/api/TrueLern-API.postman_collection.json).

### 4.1 Folder 01 — Public
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Book Free Demo (Lead Submission)** | `POST` | `/api/public/lead` | None | Body: `fullName`, `parentName`, `childName`, `childAge`, `email`, `phone`, `interestedCourse`, `preferredSchedule`, `source`, `message` | `[VERIFIED]` |
| **List Public Courses** | `GET` | `/api/public/courses` | None | Query: pagination | `[VERIFIED]` |
| **List Course Categories** | `GET` | `/api/public/categories` | None | None | `[VERIFIED]` |
| **Public Portal Configuration** | `GET` | `/api/v1/public/portal-config` | None | Query: `?portalId=student-portal` | `[VERIFIED]` |
| **Public Search** | `GET` | `/api/public/search` | None | Query: `?q=foundation` | `[VERIFIED]` |

### 4.2 Folder 02 — Authentication
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Student Login** | `POST` | `/api/auth/login` | None | Body: `email`, `password` | `[VERIFIED]` |
| **Parent Login** | `POST` | `/api/auth/login` | None | Body: `email`, `password` | `[VERIFIED]` |
| **Teacher / Faculty Login** | `POST` | `/api/auth/login` | None | Body: `email`, `password` | `[VERIFIED]` |
| **Admin Login** | `POST` | `/api/auth/login` | None | Body: `email`, `password` | `[VERIFIED]` |
| **Refresh Token** | `POST` | `/api/auth/refresh` | None | Body: `refreshToken` | `[VERIFIED]` |
| **Auth Handoff Verification** | `GET` | `/api/auth/handoff` | None | Query: `?token={{handoffToken}}` | `[VERIFIED]` |
| **Change Password** | `POST` | `/api/auth/change-password` | Bearer | Body: `oldPassword`, `newPassword` | `[VERIFIED]` |
| **Forgot Password** | `POST` | `/api/auth/forgot-password` | None | Body: `email` | `[VERIFIED]` |
| **Logout** | `POST` | `/api/auth/logout` | Bearer | None | `[VERIFIED]` |

### 4.3 Folder 03 — Student
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Get Student List (Admin/Counsellor view)** | `GET` | `/api/students` | Bearer | Query: `?limit=10&page=1` | `[VERIFIED]` |
| **Get Student Profile Detail** | `GET` | `/api/students/{{studentId}}` | Bearer | Path: `studentId` | `[VERIFIED]` |
| **Get Student Timeline** | `GET` | `/api/students/{{studentId}}/timeline` | Bearer | Path: `studentId` | `[VERIFIED]` |

### 4.4 Folder 04 — Parent (Strict `ParentStudentLink` Enforcement)
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Get Linked Children** | `GET` | `/api/parent/children` | Bearer | Returns array of linked wards with `studentId`, name, avatar | `[VERIFIED]` |
| **Get Child Dashboard Context** | `GET` | `/api/parent/children/{{childStudentId}}/dashboard` | Bearer | Path: `childStudentId` (attendance, classes, assignments, fees) | `[VERIFIED]` |
| **Get Child Attendance** | `GET` | `/api/parent/children/{{childStudentId}}/attendance` | Bearer | Path: `childStudentId` (session attendance logs) | `[VERIFIED]` |
| **Get Child Academics & Courses** | `GET` | `/api/parent/children/{{childStudentId}}/academics` | Bearer | Path: `childStudentId` (enrolled courses & syllabus breakdown) | `[VERIFIED]` |
| **Get Child Assignments** | `GET` | `/api/parent/children/{{childStudentId}}/assignments` | Bearer | Path: `childStudentId` (homework submissions & marks) | `[VERIFIED]` |
| **Get Child Assessments** | `GET` | `/api/parent/children/{{childStudentId}}/assessments` | Bearer | Path: `childStudentId` (sanitized quiz scores & results) | `[VERIFIED]` |
| **Get Child Live Classes** | `GET` | `/api/parent/children/{{childStudentId}}/live-classes` | Bearer | Path: `childStudentId` (timetable of upcoming/past classes) | `[VERIFIED]` |
| **Get Child Recordings & Revision** | `GET` | `/api/parent/children/{{childStudentId}}/recordings` | Bearer | Path: `childStudentId` (completed session revision media) | `[VERIFIED]` |
| **Get Child Finance & Invoices** | `GET` | `/api/parent/children/{{childStudentId}}/finance` | Bearer | Path: `childStudentId` (invoices, payments, balance due) | `[VERIFIED]` |
| **Get Parent Notifications** | `GET` | `/api/parent/notifications` | Bearer | Parent-targeted alert stream | `[VERIFIED]` |

### 4.5 Folder 05 — Faculty
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Get Teachers List** | `GET` | `/api/teachers` | Bearer | Query: `?limit=10` | `[VERIFIED]` |
| **Get Teacher Detail** | `GET` | `/api/teachers/{{teacherId}}` | Bearer | Path: `teacherId` | `[VERIFIED]` |
| **Get Teacher Availability Schedule** | `GET` | `/api/teachers/{{teacherId}}/availability` | Bearer | Path: `teacherId` | `[VERIFIED]` |

### 4.6 Folder 06 — Courses
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Get Courses List** | `GET` | `/api/courses` | Bearer | Query: `?limit=10&status=active` | `[VERIFIED]` |
| **Get Course Detail** | `GET` | `/api/courses/{{courseId}}` | Bearer | Path: `courseId` | `[VERIFIED]` |
| **Get Course Curriculum** | `GET` | `/api/courses/{{courseId}}/curriculum` | Bearer | Path: `courseId` (modules, topics, lessons) | `[VERIFIED]` |

### 4.7 Folder 07 — Enrollments
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Get Enrollments** | `GET` | `/api/enrollments` | Bearer | Query: `?limit=10` | `[VERIFIED]` |
| **Get Batches List** | `GET` | `/api/batches` | Bearer | Query: `?limit=10` | `[VERIFIED]` |
| **Get Batch Detail** | `GET` | `/api/batches/{{batchId}}` | Bearer | Path: `batchId` | `[VERIFIED]` |

### 4.8 Folder 08 — Live Classes
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Get Live Classes List** | `GET` | `/api/live-classes` | Bearer | Query: `?limit=10&sort=startDate&order=asc` | `[VERIFIED]` |
| **Get Live Class Detail** | `GET` | `/api/live-classes/{{liveClassId}}` | Bearer | Path: `liveClassId` | `[VERIFIED]` |
| **Generate Live Classroom Jitsi Token** | `POST` | `/api/live-classes/{{liveClassId}}/token` | Bearer | Path: `liveClassId`, Body: `{}` (Returns Jitsi JWT token) | `[VERIFIED]` |
| **Get Live Class Announcements** | `GET` | `/api/live-classes/{{liveClassId}}/announcements` | Bearer | Path: `liveClassId` | `[VERIFIED]` |
| **Get Live Class Resources** | `GET` | `/api/live-classes/{{liveClassId}}/resources` | Bearer | Path: `liveClassId` | `[VERIFIED]` |

### 4.9 Folder 09 — Recordings & Revision
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Stream Recording Video (HTTP Range Support)** | `GET` | `/api/recordings/{{recordingId}}/stream` | Bearer | Path: `recordingId` (HTTP Range 206 partial content) | `[VERIFIED]` |
| **Get Live Class Recordings Metadata** | `GET` | `/api/live-classes/{{liveClassId}}/recordings` | Bearer | Path: `liveClassId` | `[VERIFIED]` |

### 4.10 Folder 10 — Attendance
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Get Attendance Records** | `GET` | `/api/attendance` | Bearer | Query: `?student={{studentId}}&limit=20` | `[VERIFIED]` |
| **Get Attendance Summary** | `GET` | `/api/attendance/summary` | Bearer | Query: `?student={{studentId}}` | `[VERIFIED]` |
| **Mark Attendance (Teacher/Admin)** | `POST` | `/api/attendance` | Bearer | Body: `student`, `batch`, `liveClass`, `status`, `remarks` | `[VERIFIED]` |

### 4.11 Folder 11 — Assignments
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Get Assignments List** | `GET` | `/api/assignments` | Bearer | Query: `?limit=10&status=published` | `[VERIFIED]` |
| **Get Assignment Detail** | `GET` | `/api/assignments/{{assignmentId}}` | Bearer | Path: `assignmentId` | `[VERIFIED]` |
| **Submit Assignment (Student)** | `POST` | `/api/assignments/{{assignmentId}}/submit` | Bearer | Path: `assignmentId`, Body: `submissionText`, `attachments` (URLs) | `[VERIFIED]` |
| **Evaluate Submission (Teacher)** | `POST` | `/api/assignments/{{assignmentId}}/evaluate` | Bearer | Path: `assignmentId`, Body: `submissionId`, `marksAwarded`, `feedback`, `status` | `[VERIFIED]` |

### 4.12 Folder 12 — Assessments
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Get Assessments List** | `GET` | `/api/assessments` | Bearer | Query: `?limit=10&status=published` | `[VERIFIED]` |
| **Get Assessment Detail** | `GET` | `/api/assessments/{{assessmentId}}` | Bearer | Path: `assessmentId` | `[VERIFIED]` |
| **Start Assessment Attempt (Student)** | `POST` | `/api/assessments/{{assessmentId}}/start` | Bearer | Path: `assessmentId`, Body: `{}` | `[VERIFIED]` |
| **Submit Assessment Answers (Student)** | `POST` | `/api/assessments/{{assessmentId}}/submit` | Bearer | Path: `assessmentId`, Body: `attemptId`, `answers` array | `[VERIFIED]` |

### 4.13 Folder 13 — Finance
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Get Invoices List** | `GET` | `/api/finance/invoices` | Bearer | Query: `?limit=10` | `[VERIFIED]` |
| **Get Invoice Detail** | `GET` | `/api/finance/invoices/{{invoiceId}}` | Bearer | Path: `invoiceId` | `[VERIFIED]` |
| **Get Payments History** | `GET` | `/api/finance/payments` | Bearer | Query: `?limit=10` | `[VERIFIED]` |
| **Get Receipts** | `GET` | `/api/finance/receipts` | Bearer | Query: `?limit=10` | `[VERIFIED]` |

### 4.14 Folder 14 — Notifications
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Get Notifications Inbox** | `GET` | `/api/notifications/inbox` | Bearer | Query: `?limit=20&page=1` | `[VERIFIED]` |
| **Mark Notification as Read** | `POST` | `/api/notifications/inbox` | Bearer | Body: `{ "notificationId": "...", "action": "read" }` | `[VERIFIED]` |
| **Archive Notification** | `POST` | `/api/notifications/inbox` | Bearer | Body: `{ "notificationId": "...", "action": "archive" }` | `[VERIFIED]` |
| **Get Notification Preferences** | `GET` | `/api/notifications/preferences` | Bearer | Returns user alert settings | `[VERIFIED]` |

### 4.15 Folder 15 — Calendar
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Export Calendar ICS Feed** | `GET` | `/api/calendar/ics` | Bearer | Returns standard iCalendar `.ics` stream for native calendar sync | `[VERIFIED]` |

### 4.16 Folder 16 — Certificates
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **Get Certificates List** | `GET` | `/api/certificates` | Bearer | Query: `?limit=10` | `[VERIFIED]` |
| **Verify Certificate** | `GET` | `/api/certificates/verify` | None | Query: `?code={{certificateCode}}` | `[VERIFIED]` |

### 4.17 Folder 17 — Admin (Mobile Optional / Super Admin)
| Request Name | Method | Path | Auth | Payload / Params | Status |
|---|:---:|---|:---:|---|:---:|
| **CRM Leads List (Admin Mobile View)** | `GET` | `/api/crm/leads` | Bearer | Query: `?limit=10&page=1` | `[VERIFIED]` |
| **Academic Health & Analytics Summary** | `GET` | `/api/analytics/academic` | Bearer | High-level cohort health and attendance metrics | `[VERIFIED]` |

---

## 5. Backend Dependencies (Missing from Current TrueLern API Contract)

The following capabilities referenced in candidate UI briefs or PRD workflows do NOT exist in `TrueLern-API.postman_collection.json`:

| Required Feature / Screen | Missing API Endpoint | Description / Impact | Status |
|---|---|---|:---:|
| **Mobile OTP Login / Verify** | `POST /api/auth/otp/send`<br>`POST /api/auth/otp/verify` | Backend auth currently only supports email/password login. Phone OTP is blocked. | `[BACKEND DEPENDENCY]` |
| **Add / Link Child from Mobile** | `POST /api/parent/children` | Parent portal currently only supports `GET /api/parent/children`. Creating/linking a ward from mobile requires backend support. | `[BACKEND DEPENDENCY]` |
| **Timezone Preference Update** | `PUT /api/parent/timezone` | Mobile setup asks for timezone/location; endpoint is missing. | `[BACKEND DEPENDENCY]` |
| **Direct Student-Teacher Chat** | `GET/POST /api/messages` | No chat WebSocket or REST messaging endpoint exists in the TrueLern contract. | `[BACKEND DEPENDENCY]` |
| **Device Session Revocation** | `GET /api/auth/devices`<br>`DELETE /api/auth/devices/:id` | Candidate security screen "Login & Devices" requires session management endpoints. | `[BACKEND DEPENDENCY]` |
| **Native Mobile Payment Checkout** | `POST /api/finance/pay-native` | In-app native card/UPI checkout order creation. (Current flow relies on web handoff token). | `[BACKEND DEPENDENCY]` |
| **Gamification / Badges** | `GET /api/achievements` | Badges/points endpoint missing (also excluded in v1 PRD). | `[BACKEND DEPENDENCY]` |
