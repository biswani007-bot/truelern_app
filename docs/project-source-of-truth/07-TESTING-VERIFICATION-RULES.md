# 07 — Testing & Verification Rules (Definition of "Done")

> [!IMPORTANT]
> **DEFINITION OF "DONE" CONTRACT**:
> A task or feature is NEVER considered complete simply because code compiles, `flutter analyze` passes, or a widget renders in an isolated test harness. True completion demands runtime verification across user flows, live API communication, and lifecycle stability.

---

## 1. What Does NOT Constitute "Done"

The following milestones are necessary prerequisites, but are **NOT sufficient** to claim completion:

❌ The code compiles without fatal errors.  
❌ `flutter analyze` outputs "No issues found!".  
❌ Unit/widget tests pass against static mock objects.  
❌ A screen renders static hardcoded dummy data.  
❌ A feature works only on Windows desktop without being verified on the Android toolchain.  

---

## 2. The Comprehensive "Done" Checklist

A feature is officially marked **DONE** and verified only when all applicable conditions in this checklist are fulfilled:

### 2.1 Visual & UX Conformance
- [ ] **Figma Fidelity**: Colors, typography, spacing, border radii, and visual hierarchy strictly conform to approved Figma specifications.
- [ ] **Responsive Insets**: All top headers, action buttons, and bottom sheets respect `SafeArea` insets and adjust properly on various screen aspect ratios.
- [ ] **Accessibility Targets**: All interactive touch targets (buttons, links, icon tabs) measure at least `48x48 dp`.

### 2.2 Navigation & Routing
- [ ] **Declarative Route Entry**: Screen opens cleanly via its registered `go_router` path and handles query/path parameters safely.
- [ ] **Back Navigation**: Hardware back button (Android) and app bar back arrow consistently pop the route or return to the designated parent screen.
- [ ] **Deep Linking / Redirects**: Unauthenticated users trying to access protected routes are immediately redirected to the Login flow.

### 2.3 Live API Integration & State Handling
- [ ] **Real Backend Communication**: Feature makes genuine HTTP calls against verified TrueLern API endpoints (`https://truelern.visital.in/api`).
> [!WARNING]
> Do NOT hit or reference `https://360api.vnvision.in/api` (`[WRONG PROJECT — DO NOT USE]`).
- [ ] **Token Handling & Session Continuity**: Request sends valid `Authorization: Bearer <accessToken>` and seamlessly recovers on `401 Unauthorized` via `/api/auth/refresh`.
- [ ] **Loading State**: Displays smooth skeleton shimmers matching component geometry while data loads.
- [ ] **Populated State**: Displays all payload attributes without null pointer crashes or truncated text.
- [ ] **Empty State**: Displays friendly, informative empty state illustrations and helper copy when API returns empty collections.
- [ ] **Error & Retry State**: Displays clear human-readable error banners (e.g., "Network unavailable") with an active "Retry" action that re-triggers the query.

### 2.4 Android Runtime & Hardware Verification
- [ ] **Android Compilation**: Verified on Android SDK 36 (`flutter build apk --debug`).
- [ ] **Hardware Permissions**: When launching live video classes (Jitsi Meet), camera and microphone permissions are requested gracefully and handled when denied.
- [ ] **App Lifecycle Stability**: App does not crash or lose state when sent to the background and resumed.
- [ ] **Clean Runtime Logs**: Zero unhandled exceptions, memory leaks, or continuous console spam during execution.

### 2.5 Scope Integrity
- [ ] **No Scope Expansion**: The feature contains no unauthorized buttons, placeholder "Coming Soon" dialogs, or speculative features outside [`00-SCOPE.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/00-SCOPE.md).

---

## 3. End-to-End Verification Flows (Critical Paths)

For the core workflows of TrueLern, end-to-end multi-step verification must be documented:

### Flow 1: Parent Authentication & Multi-Ward Inspection
1. Launch app → Splash bootstrap verifies `/api/v1/public/portal-config`.
2. Login screen → Enter parent credentials → `POST /api/auth/login` returns tokens.
3. Tokens securely stored in Keystore via `flutter_secure_storage`.
4. App router navigates to Parent Dashboard.
5. `GET /api/parent/children` loads linked wards.
6. Toggle Ward Switcher → Selected `childStudentId` updates state.
7. `GET /api/parent/children/:id/dashboard` loads verified metrics for the selected child.

### Flow 2: Student Live Classroom Entry
1. Student context activated.
2. Dashboard fetches `/api/live-classes` → Displays upcoming class card with instructor and scheduled start time.
3. User taps "Join Live Class".
4. Pre-flight screen validates camera/mic availability.
5. App dispatches `POST /api/live-classes/:id/token` → Obtains signed Jitsi JWT.
6. Native Jitsi Meet launches room with verified student display name.
7. Disconnecting returns student safely back to the Live Class details screen.

### Flow 3: Assignment Submission & Feedback Review
1. Navigate to Assignments tab → `GET /api/assignments` populates pending tasks.
2. Select assignment → `GET /api/assignments/:id` displays instructions, rubric, and due date.
3. Enter answer text and attach assignment link.
4. Tap "Submit Assignment" → `POST /api/assignments/:id/submit` returns `200 OK`.
5. Screen reflects status update (`SUBMITTED`).
6. Once evaluated by instructor, evaluation details card renders marks and teacher feedback.
