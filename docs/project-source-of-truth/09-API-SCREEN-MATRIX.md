# 09 — API-Screen Matrix (Authoritative TrueLern Mapping)

> [!IMPORTANT]
> **UNIDIRECTIONAL INTEGRATION CONTRACT**:
> Every API-backed screen must map strictly through this pipeline:
> `SCREEN → ROLE → USER FLOW → REQUIRED API → HTTP METHOD → REQUEST → RESPONSE → STATE REQUIREMENT → API STATUS → DEPENDENCY → NOTES`
>
> Production API Base URL: **`https://truelern.visital.in/api`** `[VERIFIED]`
> Reference Contract: [`docs/api/TrueLern-API.postman_collection.json`](file:///d:/New%20folder/New%20folder/truelearn/docs/api/TrueLern-API.postman_collection.json)
>
> `[WRONG PROJECT WARNING]`: `https://360api.vnvision.in/api` is obsolete, belongs to a different project, and must NEVER be referenced.
>
> **READINESS STATUS**:
> - **PHASE 1 PLANNING**: **`[READY]`** (Mapping, screen inventory, navigation, and DTO contracts are unlocked).
> - **AUTHENTICATED IMPLEMENTATION**: **`[BLOCKED — PRODUCTION LOGIN 500]`** (Login returns 500 error on production, preventing live token generation).

---

## Screen-to-API Mapping Matrix

### 1. Public & Onboarding Flow

#### SCR-01: Splash Screen
- **Role**: Public / Both
- **User Flow**: App launch → Check maintenance/version → Validate token → Route
- **Required API**: `/api/v1/public/portal-config?portalId=student-portal`
- **HTTP Method**: `GET`
- **Request**: None (Query: `portalId=student-portal`)
- **Response**: `{ "success": true, "data": { "maintenanceMode": false, "minAppVersion": "1.0.0", "features": { ... } } }`
- **State Requirement**: `SplashController` AsyncValue
- **API Status**: `[VERIFIED]` (Found in Postman collection Folder 01)
- **Dependency**: Local secure storage for token presence check
- **Notes**: If maintenance active, block UI; if valid token present, navigate to dashboard.

#### SCR-02: Onboarding Intro
- **Role**: Public
- **User Flow**: First launch → View value proposition slides → Tap "Get Started"
- **Required API**: None (Static UI slides)
- **HTTP Method**: N/A
- **Request**: N/A
- **Response**: N/A
- **State Requirement**: Local onboarding completion flag in `SharedPreferences`
- **API Status**: N/A
- **Dependency**: None
- **Notes**: Pure presentation layer.

#### SCR-03: Login Screen
- **Role**: Both (Parent / Student)
- **UI Type**: NAVIGABLE SCREEN (`/login`)
- **User Flow**: Input email & password → Tap "Login" → Store tokens → Navigate
- **Required API**: `/api/auth/login`
- **HTTP Method**: `POST`
- **Request**: `{ "email": "user@truelern.com", "password": "password123" }`
- **Response**: `{ "success": true, "data": { "accessToken": "jwt...", "refreshToken": "jwt...", "user": { "_id": "...", "name": "...", "email": "...", "role": "PARENT"|"STUDENT" } } }`
- **State Requirement**: `AuthController` (`AuthState.authenticated`)
- **Design Planning Readiness**: `[READY FOR IMPLEMENTATION PLANNING]`
- **API Contract**: `[CONTRACT VERIFIED]` (Found in Postman collection Folder 02)
- **Production Runtime**: `[BLOCKED — LOGIN 500]` (Server returns 500 error on production credentials)
- **Dependency**: `flutter_secure_storage` for AES/Keystore token persistence
- **Notes**: API Contract verified in collection. Runtime testing blocked by server 500.

#### SCR-04: Verify Code (OTP)
- **Role**: Both
- **User Flow**: Enter SMS/Email OTP code → Confirm account / 2FA
- **Required API**: `POST /api/auth/otp/verify`
- **HTTP Method**: `POST`
- **Request**: `[NOT IN TRUELEARN CONTRACT]`
- **Response**: `[NOT IN TRUELEARN CONTRACT]`
- **State Requirement**: `VerifyOtpController`
- **API Status**: `[BACKEND DEPENDENCY]`
- **Dependency**: Mobile SMS/Email OTP gateway in TrueLern backend
- **Notes**: `TrueLern-API.postman_collection.json` has NO OTP endpoint. Must remain blocked.

#### SCR-05: Interests Setup
- **Role**: Student
- **User Flow**: Select topic interests during onboarding
- **Required API**: `POST /api/students/interests`
- **HTTP Method**: `POST`
- **Request**: `[NOT IN TRUELEARN CONTRACT]`
- **Response**: `[NOT IN TRUELEARN CONTRACT]`
- **State Requirement**: `InterestsController`
- **API Status**: `[BACKEND DEPENDENCY]`
- **Dependency**: Student interests onboarding endpoint
- **Notes**: Excluded from v1 core freeze; blocked.

#### SCR-06: Account Details
- **Role**: Parent
- **User Flow**: Fill guardian contact info during onboarding
- **Required API**: `PUT /api/parent/profile`
- **HTTP Method**: `PUT`
- **Request**: `[NOT IN TRUELEARN CONTRACT]`
- **Response**: `[NOT IN TRUELEARN CONTRACT]`
- **State Requirement**: `AccountDetailsController`
- **API Status**: `[BACKEND DEPENDENCY]`
- **Dependency**: Backend profile mutation endpoint
- **Notes**: Blocked pending endpoint specification.

#### SCR-07: Child Details Setup
- **Role**: Parent
- **User Flow**: Add new ward (child name, age, grade)
- **Required API**: `POST /api/parent/children`
- **HTTP Method**: `POST`
- **Request**: `[NOT IN TRUELEARN CONTRACT]`
- **Response**: `[NOT IN TRUELEARN CONTRACT]`
- **State Requirement**: `AddChildController`
- **API Status**: `[BACKEND DEPENDENCY]`
- **Dependency**: Backend self-link ward endpoint
- **Notes**: Postman collection only contains `GET /api/parent/children`. Creating wards from mobile is unbuilt.

#### SCR-08: Location / Timezone Setup
- **Role**: Parent
- **User Flow**: Set timezone for class schedules
- **Required API**: `PUT /api/parent/timezone`
- **HTTP Method**: `PUT`
- **Request**: `[NOT IN TRUELEARN CONTRACT]`
- **Response**: `[NOT IN TRUELEARN CONTRACT]`
- **State Requirement**: `LocationController`
- **API Status**: `[BACKEND DEPENDENCY]`
- **Dependency**: User timezone preference API
- **Notes**: Blocked pending backend contract.

---

### 2. Parent Portal Experience

#### SCR-09: Parent Dashboard
- **Role**: Parent
- **User Flow**: Select child → View attendance, upcoming classes, assignments, fees
- **Required API**: `/api/parent/children/{{childStudentId}}/dashboard`
- **HTTP Method**: `GET`
- **Request**: Path param `childStudentId`, Header `Authorization: Bearer <accessToken>`
- **Response**: `{ "success": true, "data": { "attendanceRate": 94.2, "upcomingClassesCount": 3, "pendingAssignmentsCount": 2, "totalBalanceDue": 450.00 } }`
- **State Requirement**: `ParentDashboardNotifier` (`AsyncValue<ParentDashboardEntity>`)
- **API Status**: `[VERIFIED]` (Folder 04, Item 2)
- **Dependency**: Valid `childStudentId` from SCR-11
- **Notes**: Requires `ParentStudentLink` guard authorization on backend.

#### SCR-11: My Children Hub (Ward Switcher)
- **Role**: Parent
- **User Flow**: Tap child switcher in app bar → View linked wards → Switch active child
- **Required API**: `/api/parent/children`
- **HTTP Method**: `GET`
- **Request**: Header `Authorization: Bearer <accessToken>`
- **Response**: `{ "success": true, "data": [ { "studentId": "std_101", "firstName": "Aarav", "lastName": "Sharma", "avatar": "...", "grade": "Grade 8" } ] }`
- **State Requirement**: `ParentChildrenNotifier` + `activeChildIdProvider`
- **API Status**: `[VERIFIED]` (Folder 04, Item 1)
- **Dependency**: None
- **Notes**: Test script verifies first child ID is stored as `childStudentId`.

#### SCR-32: Invoices List
- **Role**: Parent
- **User Flow**: View tuition fee invoices and statement breakdown
- **Required API**: `/api/finance/invoices?limit=10` & `/api/parent/children/{{childStudentId}}/finance`
- **HTTP Method**: `GET`
- **Request**: Query: `?limit=10`, Header: Bearer token
- **Response**: `{ "success": true, "data": [ { "id": "inv_1", "invoiceNumber": "INV-001", "amount": 500, "status": "PENDING" } ] }`
- **State Requirement**: `FinanceInvoicesNotifier`
- **API Status**: `[VERIFIED]` (Folder 04 Item 9, Folder 13 Item 1)
- **Dependency**: Active child context
- **Notes**: Filterable by ward.

#### SCR-33: Invoice Detail
- **Role**: Parent
- **User Flow**: View line items, tax breakdown, pay button
- **Required API**: `/api/finance/invoices/{{invoiceId}}`
- **HTTP Method**: `GET`
- **Request**: Path param `invoiceId`
- **Response**: Detailed invoice object with tax and line item array
- **State Requirement**: `InvoiceDetailNotifier`
- **API Status**: `[VERIFIED]` (Folder 13, Item 2)
- **Dependency**: Valid `invoiceId`
- **Notes**: Payment trigger links to web handoff token.

#### SCR-34: Payment Successful
- **Role**: Parent
- **UI Type**: SUCCESS STATE / DIALOG OVERLAY (No separate pushed route)
- **User Flow**: View payment receipt after completed transaction
- **Required API**: `/api/finance/receipts?limit=10`
- **HTTP Method**: `GET`
- **Request**: Query: `limit=10`
- **Response**: Receipt array with download URLs
- **State Requirement**: `ReceiptNotifier`
- **Planning Status**: `[NEEDS CONFIRMATION]`
- **Runtime Status**: `[NEEDS AUTH TEST]`
- **Dependency**: Completed payment transaction (execution mechanism unconfirmed)
- **Notes**: Receipt read endpoint exists. Payment callback and execution mechanism require confirmation.

---

### 3. Student Learning Experience

#### SCR-10: Student Dashboard
- **Role**: Student
- **User Flow**: View active batch, upcoming live class card, active homework
- **Required API**: `/api/batches?limit=10` and `/api/live-classes?limit=10&sort=startDate&order=asc`
- **HTTP Method**: `GET`
- **Request**: Bearer token
- **Response**: Batches list and scheduled live classes list
- **State Requirement**: `StudentDashboardNotifier`
- **API Status**: `[VERIFIED]` (Folder 07 Item 2, Folder 08 Item 1)
- **Dependency**: Active student enrollment
- **Notes**: Combines batch and class schedules.

#### SCR-12: Current Program & Curriculum
- **Role**: Student
- **User Flow**: Explore modules, topics, lessons
- **Required API**: `/api/courses/{{courseId}}/curriculum`
- **HTTP Method**: `GET`
- **Request**: Path param `courseId`
- **Response**: Curriculum tree with modules, topics, and lesson objects
- **State Requirement**: `CurriculumNotifier`
- **API Status**: `[VERIFIED]` (Folder 06, Item 3)
- **Dependency**: Enrolled `courseId`
- **Notes**: Displays progress percentage per module.

#### SCR-13: My Classes / Schedule
- **Role**: Both
- **User Flow**: View calendar/timetable of scheduled classes
- **Required API**: `/api/live-classes?limit=10&sort=startDate&order=asc`
- **HTTP Method**: `GET`
- **Request**: Query: `limit=10&sort=startDate&order=asc`
- **Response**: Array of live class sessions with instructor and start/end times
- **State Requirement**: `LiveClassListNotifier`
- **API Status**: `[VERIFIED]` (Folder 08, Item 1)
- **Dependency**: Cohort batch membership
- **Notes**: Highlights active classes with status `LIVE`.

#### SCR-14: Class Details
- **Role**: Both
- **User Flow**: View class agenda, teacher info, handouts, announcements
- **Required API**: `/api/live-classes/{{liveClassId}}`, `/announcements`, `/resources`
- **HTTP Method**: `GET`
- **Request**: Path param `liveClassId`
- **Response**: Class session detail, announcements array, resources array
- **State Requirement**: `ClassDetailNotifier`
- **API Status**: `[VERIFIED]` (Folder 08, Items 2, 4, 5)
- **Dependency**: Valid `liveClassId`
- **Notes**: Pre-join overview screen.

#### SCR-15: Ready to Join (Pre-flight)
- **Role**: Student
- **User Flow**: Test microphone, camera, speaker before entering Jitsi
- **Required API**: None (Local hardware permissions check)
- **HTTP Method**: N/A
- **Request**: N/A
- **Response**: N/A
- **State Requirement**: `MediaPermissionState`
- **API Status**: N/A
- **Dependency**: Device camera/mic permissions
- **Notes**: Native permission verification.

#### SCR-16: Live Classroom (Jitsi Meet)
- **Role**: Student
- **User Flow**: Enter live conference room with video, audio, screen-share viewing
- **Required API**: `POST /api/live-classes/{{liveClassId}}/token`
- **HTTP Method**: `POST`
- **Request**: Path param `liveClassId`, Body: `{}`
- **Response**: `{ "success": true, "data": { "token": "jitsi_jwt...", "roomName": "truelern-room-6a8b...", "serverUrl": "https://meet.jit.si" } }`
- **State Requirement**: `JitsiController`
- **API Status**: `[VERIFIED]` (Folder 08, Item 3)
- **Dependency**: Native Jitsi Meet SDK
- **Notes**: HIGH PRIORITY. Embeds `isModerator: false` for students.

#### SCR-18: Assignments Hub
- **Role**: Both
- **User Flow**: View list of published assignments, deadlines, submission status
- **Required API**: `/api/assignments?limit=10&status=published`
- **HTTP Method**: `GET`
- **Request**: Query: `?limit=10&status=published`
- **Response**: Array of assignments with due date, title, maxMarks
- **State Requirement**: `AssignmentsNotifier`
- **API Status**: `[VERIFIED]` (Folder 11, Item 1)
- **Dependency**: Enrolled batch
- **Notes**: Filterable by status (`pending`, `submitted`, `graded`).

#### SCR-19: Assignment Details
- **Role**: Both
- **User Flow**: Read instructions, download worksheet PDF, check rubric
- **Required API**: `/api/assignments/{{assignmentId}}`
- **HTTP Method**: `GET`
- **Request**: Path param `assignmentId`
- **Response**: Assignment entity with instructions, rubric, and attachment URLs
- **State Requirement**: `AssignmentDetailNotifier`
- **API Status**: `[VERIFIED]` (Folder 11, Item 2)
- **Dependency**: Valid `assignmentId`
- **Notes**: Contains "Submit Work" button for students.

#### SCR-20: Assignment Submission
- **Role**: Student
- **User Flow**: Enter text answer, upload attachment URL, submit
- **Required API**: `POST /api/assignments/{{assignmentId}}/submit`
- **HTTP Method**: `POST`
- **Request**: `{ "submissionText": "...", "attachments": [ "https://..." ] }`
- **Response**: `{ "success": true, "message": "Assignment submitted successfully", "data": { "submissionId": "...", "status": "SUBMITTED" } }`
- **State Requirement**: `AssignmentSubmitController`
- **API Status**: `[VERIFIED]` (Folder 11, Item 3)
- **Dependency**: Valid `assignmentId`
- **Notes**: Transitions to SCR-21 upon success.

#### SCR-21: Assignment Submitted
- **Role**: Student
- **User Flow**: Confirmation receipt display
- **Required API**: None (UI state from SCR-20 response)
- **HTTP Method**: N/A
- **Request**: N/A
- **Response**: N/A
- **State Requirement**: Static success display
- **API Status**: N/A
- **Dependency**: SCR-20 completion
- **Notes**: Shows submission timestamp and link back to list.

#### SCR-22: Teacher Feedback
- **Role**: Both
- **User Flow**: View evaluated marks, graded status, teacher remarks
- **Required API**: `/api/assignments/{{assignmentId}}` (or evaluated submission payload)
- **HTTP Method**: `GET`
- **Request**: Path param `assignmentId`
- **Response**: Assignment object containing evaluation marks and feedback string
- **State Requirement**: `AssignmentEvaluationNotifier`
- **API Status**: `[VERIFIED]` (Folder 11, Item 2 / Item 4 payload)
- **Dependency**: Evaluated submission
- **Notes**: Visible to parent and student once graded.

#### SCR-24: Learning Progress & Attendance Log
- **Role**: Both
- **User Flow**: View attendance summary percentage and session history
- **Required API**: `/api/attendance/summary?student={{studentId}}` and `/api/attendance?student={{studentId}}&limit=20`
- **HTTP Method**: `GET`
- **Request**: Query `student={{studentId}}`
- **Response**: Attendance percentage, total sessions, present, absent, and detailed records
- **State Requirement**: `AttendanceNotifier`
- **API Status**: `[VERIFIED]` (Folder 10, Items 1 & 2)
- **Dependency**: Valid `studentId`
- **Notes**: Displays calendar heat map or progress ring.

#### SCR-25: Achievements / Badges
- **Role**: Student
- **User Flow**: View certificates and course milestones
- **Required API**: `/api/certificates?limit=10`
- **HTTP Method**: `GET`
- **Request**: Query: `?limit=10`
- **Response**: Certificates array with title, issueDate, and verification code
- **State Requirement**: `CertificatesNotifier`
- **API Status**: `[VERIFIED]` (Folder 16, Item 1)
- **Dependency**: Completed course
- **Notes**: Gamified badge endpoints do not exist; certificate milestones used instead.

---

### 4. Communication, Notifications, & Settings

#### SCR-26: User Profile
- **Role**: Both
- **User Flow**: View account details, email, phone, enrolled date
- **Required API**: `/api/students/{{studentId}}` (Student) or parent profile
- **HTTP Method**: `GET`
- **Request**: Path param `studentId`, Bearer token
- **Response**: Profile object with user attributes and enrollment dates
- **State Requirement**: `ProfileNotifier`
- **API Status**: `[VERIFIED]` (Folder 03, Item 2)
- **Dependency**: Active user session
- **Notes**: Enforces ownership verification on backend.

#### SCR-27: Messages / Chat
- **Role**: Both
- **User Flow**: Direct 1-on-1 messaging between student and teacher
- **Required API**: `GET/POST /api/messages`
- **HTTP Method**: N/A
- **Request**: `[NOT IN TRUELEARN CONTRACT]`
- **Response**: `[NOT IN TRUELEARN CONTRACT]`
- **State Requirement**: `ChatNotifier`
- **API Status**: `[BACKEND DEPENDENCY]`
- **Dependency**: Chat WebSocket / REST messaging microservice
- **Notes**: Excluded from PRD v1; blocked.

#### SCR-28: Notifications Feed
- **Role**: Both
- **User Flow**: View in-app alerts → Mark as read / archive
- **Required API**:
  - `GET /api/notifications/inbox?limit=20&page=1`
  - `POST /api/notifications/inbox` (Body: `{ notificationId, action: "read" | "archive" }`)
- **HTTP Method**: `GET` & `POST`
- **Request**: Query params & JSON body
- **Response**: Notifications list; updated status
- **State Requirement**: `NotificationsNotifier`
- **API Status**: `[VERIFIED]` (Folder 14, Items 1, 2, 3)
- **Dependency**: Bearer token
- **Notes**: Tapping notification marks it read and routes to target entity.

#### SCR-29: Security & Privacy (Change Password)
- **Role**: Both
- **User Flow**: Update password securely
- **Required API**: `POST /api/auth/change-password`
- **HTTP Method**: `POST`
- **Request**: `{ "oldPassword": "...", "newPassword": "..." }`
- **Response**: `{ "success": true, "message": "Password changed successfully" }`
- **State Requirement**: `ChangePasswordController`
- **API Status**: `[VERIFIED]` (Folder 02, Item 7)
- **Dependency**: Bearer token
- **Notes**: Invalidates active sessions; requires re-login.

#### SCR-30 & SCR-31: Login Methods & Devices
- **Role**: Both
- **User Flow**: Manage login devices and revoke active sessions
- **Required API**: `GET/DELETE /api/auth/devices`
- **HTTP Method**: N/A
- **Request**: `[NOT IN TRUELEARN CONTRACT]`
- **Response**: `[NOT IN TRUELEARN CONTRACT]`
- **State Requirement**: `DevicesController`
- **API Status**: `[BACKEND DEPENDENCY]`
- **Dependency**: Session table in backend auth
- **Notes**: Blocked pending backend implementation.

#### SCR-36: Account Settings (Alert Preferences)
- **Role**: Both
- **User Flow**: Update notification delivery preferences
- **Required API**: `GET /api/notifications/preferences`
- **HTTP Method**: `GET`
- **Request**: Bearer token
- **Response**: Notification preference object (email, push flags)
- **State Requirement**: `PreferencesNotifier`
- **API Status**: `[VERIFIED]` (Folder 14, Item 4)
- **Dependency**: Bearer token
- **Notes**: Controls alert settings.

#### SCR-37 & SCR-38: Book Free Demo Flow
- **Role**: Public
- **User Flow**: Prospective parent fills lead form → Receives confirmation
- **Required API**: `POST /api/public/lead`
- **HTTP Method**: `POST`
- **Request**: `{ "fullName": "...", "parentName": "...", "childName": "...", "childAge": 9, "email": "...", "phone": "...", "interestedCourse": "...", "preferredSchedule": "...", "source": "mobile_app_demo", "message": "..." }`
- **Response**: `{ "success": true, "data": { "leadId": "..." } }`
- **State Requirement**: `DemoBookingController`
- **API Status**: `[VERIFIED]` (Folder 01, Item 1)
- **Dependency**: None
- **Notes**: Test script confirms `data.leadId` returned.
