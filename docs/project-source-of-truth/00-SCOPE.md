# 00 — Strict Scope Contract

## Product Identification

- **Product Name**: TrueLern AIO Mobile Application
- **Platform**: Flutter Mobile Application (Targeting Android primary, iOS capable)
- **Primary Experience**: Unified All-In-One (AIO) Parent + Student Experience
- **Architecture Mandate**: ONE single application repository and runtime bundle. There are NOT two separate mobile apps.

---

## 1. System Role & Persona Boundaries

### 1.1 The Parent Persona [VERIFIED]
- The Parent is the primary account holder and primary device owner.
- Authenticated via verified Parent credentials.
- Can manage one or multiple linked wards (children) via the `ParentStudentLink` security model.
- Maintains administrative, oversight, and financial authority (e.g., viewing attendance, tracking syllabus progress, reviewing submitted homework and teacher feedback, monitoring live class schedules, viewing tuition invoices/payments).

### 1.2 The Student Persona & Active Child Context [VERIFIED]
- The Student learning experience operates within the context of an **Active Selected Child** (`childStudentId`).
- For multi-child families, the app must provide child-switching capabilities so the parent or learner can toggle context seamlessly.
- In student mode, the interface shifts into the learner workflow: accessing assigned batches, joining scheduled live classrooms (via Jitsi Meet), submitting homework assignments, viewing topics/curriculum, and viewing achievements.

---

## 2. Capability Scope Matrix

### 2.1 IN-SCOPE Capabilities (Subject to Verified Backend & Design Support)

| Capability Domain | Sub-Features & Screens | Scope Status | Notes |
|---|---|:---:|---|
| **Authentication & Onboarding** | Welcome, Login (Email/Password), Session Refresh, Logout, Forgot/Reset Password | `[VERIFIED]` | Backend auth fully operational via JWT. |
| | OTP Verification | `[BACKEND DEPENDENCY]` | Mobile OTP endpoint currently missing from backend auth API. |
| | Onboarding Walkthrough, Interests, Account Details, Location Setup | `[NEEDS CONFIRMATION]` | Present in candidate UI flows; requires explicit Figma/PRD sign-off. |
| **Account & Profile** | Parent Profile, Security & Privacy, Login Methods, Login & Devices | `[NEEDS CONFIRMATION]` | Candidate security screens; some profile endpoints exist. |
| **Child Management** | My Children directory, Linked Child Switcher, Child Details view | `[VERIFIED]` | Backed by `/api/parent/children`. |
| | Add New Child registration flow | `[BACKEND DEPENDENCY]` | Endpoint for linking/creating new child from mobile app needs backend support. |
| **Dashboard** | Parent Overview (attendance %, assignments, upcoming classes, balance due) | `[VERIFIED]` | Backed by `/api/parent/children/:id/dashboard`. |
| | Student Learning Dashboard (Active Program, Upcoming Live Class, Pending Tasks) | `[VERIFIED]` | Backed by Batch & Enrollment APIs. |
| | Offline Dashboard Mode | `[NEEDS CONFIRMATION]` | Requires UX specification for offline caching behavior. |
| **Programs & Courses** | Enrolled Courses, Curriculum breakdown (Modules, Topics, Lessons) | `[VERIFIED]` | Backed by `/api/courses` & `/api/courses/:id/curriculum`. |
| **Live Classroom** | Class schedule, Class details, Session status, Teacher info | `[VERIFIED]` | Backed by `/api/live-classes`. |
| | Jitsi Meet Live Classroom Entry & Participation | `[VERIFIED]` | Backed by `/api/live-classes/:id/token` (JWT room token). |
| | Ready to Join pre-flight check screen | `[NEEDS CONFIRMATION]` | Candidate screen in UX flow. |
| **Assignments & Submissions** | Assignment list, Assignment detail & rubric | `[VERIFIED]` | Backed by `/api/assignments` & `/api/assignments/:id`. |
| | Student homework submission (Text + Attachment URL) | `[VERIFIED]` | Backed by `POST /api/assignments/:id/submit`. |
| | Teacher evaluation & feedback review | `[VERIFIED]` | Backed by `/api/assignments` evaluation payload. |
| **Assessments & Quizzes** | Timed Quiz/Exam list, Assessment detail, Question start & answer submission | `[VERIFIED]` | Backed by `/api/assessments` APIs. |
| **Learning Progress & Topics** | Attendance summary & log, Module completion, Topic detail | `[VERIFIED]` | Backed by `/api/attendance` & `/api/parent/children/:id/attendance`. |
| | Gamified Badges / Achievements | `[NEEDS CONFIRMATION]` | Mentioned in UI candidate list; PRD lists gamification as v1 exclusion. |
| **Communication** | Notification Feed (inbox, mark read, archive), Notification Preferences | `[VERIFIED]` | Backed by `/api/notifications/inbox` & `/preferences`. |
| | Direct Student-Teacher 1-on-1 Messaging | `[NEEDS CONFIRMATION]` | Mentioned in candidate list; PRD v1 excludes forum/chat, backend lacks chat socket. |
| **Finance & Invoices** | Invoice list, Invoice detail, Balance due, Payment receipts | `[VERIFIED]` | Backed by `/api/finance/invoices`, `/payments`, `/receipts`. |
| | In-App Mobile Checkout / Payment Gateway | `[NEEDS CONFIRMATION]` | Needs confirmation whether payment is completed via web handoff (`/api/auth/handoff`) or native SDK. |
| **Marketing & Lead Intake** | Book Demo screens, Public course catalog exploration | `[VERIFIED]` | Backed by `POST /api/public/lead` & `/api/public/courses`. |

---

### 2.2 EXPLICITLY OUT-OF-SCOPE Capabilities

> [!WARNING]
> The following areas are strictly **OUT OF SCOPE** for this Flutter application repository:
> - Separate standalone "Parent App" or "Student App" builds.
> - Public corporate website development (handled by Next.js / CMS).
> - Administrative portal / Super Admin back-office workflows.
> - Teacher / Instructor desktop web console redevelopment.
> - LMS backend core redevelopment or database schema modifications.
> - AI-based automated grading, conversational AI tutors, or automated bot decision-making (explicitly forbidden by PRD).
> - Discussion forums, public social feeds, or community chat rooms (PRD v1 exclusion).
> - Video library / recorded video streaming, **except** revision recordings explicitly authorized for enrolled cohorts via `/api/recordings/:id/stream`.
> - Invented APIs, mock business rules, or fake authentication bypasses.

---

## 3. Scope Change Governance Rule

Any requested new feature, screen, workflow, API requirement, or major UX interaction not established in this approved baseline must be formally classified into one of the following four tiers:

```
                  ┌──────────────────────────────┐
                  │      Scope Request Item      │
                  └──────────────┬───────────────┘
                                 │
         ┌───────────────────────┼────────────────────────┐
         │                       │                        │
         ▼                       ▼                        ▼
┌──────────────────┐   ┌──────────────────┐     ┌──────────────────┐
│  1. Required     │   │  2. Clarification│     │  3. Backend      │
│  Existing Scope  │   │     Request      │     │     Dependency   │
└────────┬─────────┘   └────────┬─────────┘     └────────┬─────────┘
         │                      │                        │
         ▼                      ▼                        ▼
  [PROCEED WITH          [SUBMIT QUESTION         [BLOCK FEATURE &
   IMPLEMENTATION]        TO STAKEHOLDER]          LOG BACKEND TICKET]
                                                         │
                                                         ▼
                                                ┌──────────────────┐
                                                │  4. Scope Change │
                                                │     Request      │
                                                └────────┬─────────┘
                                                         │
                                                         ▼
                                                  [REQUIRES CLIENT
                                                   WRITTEN APPROVAL]
```

1. **Category 1 — Required Existing Scope**: Directly mandated by approved PRD/API/Figma. **Only this category may proceed without additional stakeholder approval.**
2. **Category 2 — Clarification**: Existing requirement with ambiguous edge case or interaction detail. Requires written clarification from the project lead before implementation.
3. **Category 3 — Backend Dependency**: Screen/flow required by UI or PRD where the backend endpoint is missing, incomplete, or untested. The UI integration must remain blocked until the backend team publishes a verified API contract.
4. **Category 4 — Scope Change**: Any new capability, screen, or third-party integration outside the approved baseline. Requires formal stakeholder sign-off and an entry in `10-CHANGE-LOG.md` before any code is written.
