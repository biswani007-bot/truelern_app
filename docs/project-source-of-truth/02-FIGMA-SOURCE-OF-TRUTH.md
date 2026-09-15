# 02 — Figma & Design Source of Truth

> [!IMPORTANT]
> **SOURCE STATUS: `[VERIFIED REMOTE SOURCE — INSPECTED]`**
> - **Figma URL**: `https://www.figma.com/design/CiZoTN0EnITFG3e7SFwXrU/TrueLern?node-id=69-2`
> - **Figma File Key**: `CiZoTN0EnITFG3e7SFwXrU`
> - **Inspected Primary Parent Page**: `Parent(full app)_TreLern` (Reference Node `69:2`)
> - **Student Page (Phase 1B)**: `Truelern_student`
>
> Detailed Design System Audit is published in [`docs/project-source-of-truth/14-FIGMA-DESIGN-SYSTEM-AUDIT.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/14-FIGMA-DESIGN-SYSTEM-AUDIT.md).

---

## 1. Design Source & Governance

- **Design Tool**: Figma
- **File Key**: `CiZoTN0EnITFG3e7SFwXrU`
- **Current Status**: `[VERIFIED REMOTE INSPECTION — 33 ARTBOARDS AUDITED]`
- **Authority Level**: Level 2 in Source Hierarchy.
- **Rule of Engagement**:
  - Figma designs dictate visual layout, typography scale, component geometry, brand colors, and interaction transitions.
  - **Figma screens do NOT grant authority to invent backend endpoints, create mock business data, or bypass product rules.**
  - Any screen found in a Figma file that is not supported by a verified API or approved PRD requirement must be classified as `[BACKEND DEPENDENCY]` or `[NEEDS CONFIRMATION]`.

---

## 2. Identified Candidate Screen Groups

Based on the candidate screen inventory and project brief, the design encompasses four primary structural zones:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      TrueLern AIO Flutter App                            │
├───────────────────┬───────────────────┬─────────────────────────────────┤
│ 1. Onboarding/Auth│ 2. Parent Context │ 3. Student Learning Context     │
├───────────────────┼───────────────────┼─────────────────────────────────┤
│ • Splash Screen   │ • Multi-Child Hub │ • Learning Dashboard            │
│ • Onboarding Intro│ • Parent Dashboard│ • My Classes / Live Classroom   │
│ • Login           │ • Child Academics │ • Current Program & Topics      │
│ • Verify Code/OTP │ • Child Attendance│ • Homework / Assignments        │
│ • Interests       │ • Financial Ledger│ • Assignment Submit / Feedback  │
│ • Account Details │ • Invoice Detail  │ • Quizzes / Assessments         │
│ • Location Setup  │ • Account Settings│ • Achievements / Progress       │
└───────────────────┴───────────────────┴─────────────────────────────────┘
│ 4. Shared Utilities: Notifications Feed • Profile • Security & Devices  │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.1 Group A: Auth & Onboarding Flow `[NEEDS CONFIRMATION]`
1. **Splash Screen**: Brand identity, logo reveal, animated bootstrap check (`/api/v1/public/portal-config`).
2. **Onboarding Intro**: Value proposition slides for live cohort education.
3. **Login Screen**: Secure credential input (Email, Password, Remember Me).
4. **Verify Code / OTP**: Code verification screen `[BACKEND DEPENDENCY — Backend auth endpoint required]`.
5. **Onboarding Questions (Interests / Account Details / Location)**: Profile completion flow `[NEEDS CONFIRMATION — Clarify whether this applies to public leads or enrolled students]`.

### 2.2 Group B: Parent Portal Experience `[VERIFIED UX FLOW]`
1. **My Children / Ward Switcher**: Card carousel or bottom-sheet list showing linked children with profile photos, current grade, and active enrolled program.
2. **Parent Dashboard**: Top-level summary cards:
   - Attendance percentage badge with status ring.
   - Next upcoming live class card with countdown timer.
   - Pending assignments count and latest grades.
   - Outstanding balance alert banner with quick-pay trigger.
3. **Child Academic Hub**: Breakdown of courses, syllabus progress bar, and class schedule.
4. **Finance & Invoice Screens**: List of issued invoices, status badges (`PAID`, `PENDING`, `OVERDUE`), detailed itemized receipt breakdown.

### 2.3 Group C: Student Learning Experience `[VERIFIED UX FLOW]`
1. **Student Dashboard**: Live class hero banner ("Join Live Class" primary CTA), daily schedule timetable, active homework assignments.
2. **Ready to Join (Pre-flight Screen)**: Camera and microphone permission check, audio input/output test before launching Jitsi Meet.
3. **Live Classroom (Jitsi Meet)**: Native full-screen interactive video conference with teacher video, participant gallery, hand-raise, and in-class chat/reactions.
4. **Assignment Workspace**:
   - Assignment Overview: Objective, instructions, due date, maximum marks.
   - Submission Form: Text response editor, attachment file picker.
   - Evaluation & Teacher Remarks: Grade card, teacher comment box.
5. **Topic / Curriculum Explorer**: Module accordion, topic details, lesson resources (downloadable PDFs).

### 2.4 Group D: Shared Shell & Navigation `[NEEDS CONFIRMATION]`
1. **Primary Navigation**: Modern bottom navigation bar with curated destinations:
   - *Home / Dashboard*
   - *Classes / Schedule*
   - *Assignments*
   - *Progress / Reports*
   - *Profile / Settings*
2. **Hamburger Drawer / Context Menu**: Quick access to switch child, view notifications, security settings, help/support, and logout.

---

## 3. Design System Observations & Visual Language

From the existing web design tokens, branding references, and candidate specifications:

- **Brand Palette**:
  - Primary Indigo / Blue: Rich deep brand tone for primary actions and active tabs.
  - Vibrant Accent (Emerald / Mint / Amber): Positive badges, attendance rings, and countdown highlights.
  - Surface Tones: High-contrast modern dark mode and crisp clean light mode surfaces.
- **Visual Style (Claymorphic / Soft 3D Elevation)**:
  - Where present in approved Figma frames, cards utilize subtle dual drop-shadows, soft borders (`12px` - `20px` radius), and gentle frosted glassmorphism overlays.
  - Overly flat or generic wireframe styling is prohibited; designs must look polished and tactile.
- **Typography Scale**:
  - Font Family: Clean modern sans-serif (e.g., Inter, Plus Jakarta Sans, or Outfit).
  - Clear structural hierarchy: `Display`, `Headline`, `Title`, `Body`, `Label`.

---

## 4. Pending Design Confirmations

The following design artifacts must be formally supplied or confirmed by the stakeholder prior to Phase 1 UI coding:

1. **Official Figma Project URL**: Link with read/inspect permissions for vector dimensions, exact colors, and icon SVGs.
2. **OTP Screen Interaction**: Confirmation of whether OTP is 4-digit or 6-digit, with SMS or email resend countdown.
3. **Offline Mode Screen**: Explicit Figma artboard for `Offline Dashboard` when network connectivity is lost.
4. **Payment Flow Screen**: Confirmation of whether in-app payment requires a native Razorpay/Stripe checkout sheet or an in-app browser redirect to the web portal.
