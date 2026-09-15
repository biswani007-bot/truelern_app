# 01 — Product Source of Truth (PRD)

## 1. Authoritative Requirements Sources

The verified product requirements governing this Flutter project originate from the frozen core specifications:

1. **Primary PRD**: [`docs/PRD.md`](file:///d:/New%20folder/New%20folder/lmsca-release-v1.0.0-lms-core-freeze/lmsca-release-v1.0.0-lms-core-freeze/docs/PRD.md)
   - **System Name**: LMSCA / TrueLern Live Cohort Learning Platform
   - **Version**: 1.0 (MVP Core Freeze)
   - **Status**: Production Core Freeze
2. **Mobile API Architecture & Role Contract**:
   - Primary Contract: [`docs/api/TrueLern-API.postman_collection.json`](file:///d:/New%20folder/New%20folder/truelearn/docs/api/TrueLern-API.postman_collection.json)
   - Audit Report: [`docs/project-source-of-truth/11-API-AUDIT-REPORT.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/11-API-AUDIT-REPORT.md)
   - Production Base URL: `https://truelern.visital.in/api`
   - *Warning*: `https://360api.vnvision.in/api` is classified as `[WRONG PROJECT — DO NOT USE]`.

---

## 2. Core Business Principles [VERIFIED]

The TrueLern product model is built upon three non-negotiable operational principles:
1. **Live Cohort-Based Education**: Learning takes place in scheduled, instructor-led live cohorts with synchronous classes. The system does NOT rely on self-paced, pre-recorded MOOC video catalogs as the primary pedagogy.
2. **Rule-Based Automation**: Batch scheduling, attendance accounting, assignment grading windows, and enrollment activations follow deterministic, configurable business rules.
3. **Strict No-AI Operational Policy**: In accordance with PRD Section "Business Principles", there is **no AI-based decision-making**, automatic grading without instructor oversight, or conversational chatbot pretending to teach.

---

## 3. Product Functional Requirements by Domain

### 3.1 Authentication & Session Management
- **Role Verification**: Mobile app users log in via verified credentials (`POST /api/auth/login`).
- **Token Model**: JWT Access Token (1-day lifetime) and Refresh Token (7-day lifetime).
- **Session Continuity**: Mobile HTTP client must automatically intercept `401 Unauthorized` responses and rotate tokens via `POST /api/auth/refresh` without prompting the user to re-authenticate unless the refresh token itself has expired.
- **OTP Verification**: `[NOT FOUND IN BACKEND — REQUIRES SOURCE / BACKEND DEPENDENCY]`. The core PRD and auth API currently execute email/password login. If phone OTP login is required by the mobile design, the backend auth service must implement an OTP gateway before client integration.

### 3.2 Parent Portal Requirements
- **Guard Link Security**: The Parent accesses student information strictly through a verified `ParentStudentLink` record where `canAccessPortal: true`.
- **Multi-Ward Switching**: When a parent has multiple children enrolled, the application must provide an active child switcher. All subsequent academic and attendance calls are parameterized by the selected child's `studentId`.
- **Parent Metrics**:
  - Attendance percentage and session breakdown.
  - Enrolled courses and academic syllabus progress.
  - Active homework assignments, submission status, grades, and teacher remarks.
  - Scheduled live classroom timetable for the child's batch.
  - Financial ledger: Outstanding tuition balance, issued invoices, payment receipts.

### 3.3 Student Learning Experience Requirements
- **Batch Enrollment**: The student is bound to an active cohort batch (`BatchStudent`).
- **Live Classroom (High Priority)**:
  - Students view scheduled live classes with start/end time, instructor name, and status.
  - Joining a live class invokes `POST /api/live-classes/:id/token`, which generates a scoped Jitsi Meet JWT room token (`isModerator: false`).
  - Native Jitsi Meet integration launches the interactive classroom (video, audio, screen share viewing).
- **Assignments**:
  - Students retrieve homework assignments with deadline dates, total marks, instructions, and rubric.
  - Submission (`POST /api/assignments/:id/submit`) allows submitting written answers and external file URLs.
  - Evaluation view presents awarded marks and instructor feedback once evaluated.
- **Assessments**:
  - Timed quizzes/exams with duration limits and passing score criteria.
  - Student initiates attempt (`POST /api/assessments/:id/start`) and submits answers (`POST /api/assessments/:id/submit`).
- **Learning Progress & Attendance**:
  - Session-by-session attendance tracking (`Present`, `Absent`, `Late`).
  - Course curriculum module completion tracking.

### 3.4 Communication & Notifications
- **In-App Notification Feed**:
  - Alerts for class schedule reminders, assignment deadlines, evaluation publications, and invoice generation.
  - Actions to mark notifications as read or archive them.
- **Notification Preferences**:
  - User-configurable toggles for email and in-app alerts.
- **Direct Messaging**: `[NEEDS CONFIRMATION]`. While candidate screen lists mention "Messages", the core PRD v1 exclusions explicitly state discussion forums and community chat are excluded. Real-time chat requires backend WebSocket infrastructure not currently in the frozen core.

### 3.5 Billing & Finance Requirements
- **Invoices**: Parents view itemized tuition invoices (`GET /api/finance/invoices`), breakdown of taxes, line items, and payment due dates.
- **Payment Processing**: `[NEEDS CONFIRMATION]`. Payment completion is supported on the web platform. For mobile, the system must either use web handoff (`GET /api/auth/handoff` redirecting to web checkout) or an integrated native payment gateway SDK if authorized.

---

## 4. Requirement Gaps & Unconfirmed Mobile Items

| Candidate Item | PRD Status | Current Resolution / Rule |
|---|---|---|
| **Gamification & Badges** | Explicitly excluded in PRD Section "Version 1 Exclusions" (`Gamification`) | `[NEEDS CONFIRMATION]` — Do not implement complex reward point systems unless authorized. |
| **Discussion Forum / Chat** | Explicitly excluded in PRD Section "Version 1 Exclusions" (`Discussion Forum`) | `[NEEDS CONFIRMATION]` — Direct chat blocked pending backend architecture confirmation. |
| **Recorded Video Catalog** | PRD Section "Version 1 Exclusions" excludes generic video libraries | `[VERIFIED SCOPE BOUNDARY]` — Only enrolled cohort revision recordings via `/api/recordings/:id/stream` are permitted. |
| **Parent Mobile Self-Registration** | PRD Section "Admissions" specifies CRM/Counselor lead conversion | `[NEEDS CONFIRMATION]` — Registration from mobile app vs. invited account credentials must be clarified. |
