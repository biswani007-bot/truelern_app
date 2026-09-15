# 05 — UI/UX Rules & Design System Tokens

> [!NOTE]
> All tokens and styling guidelines in this document represent the verified design parameters established for the TrueLern mobile experience. Where exact hexadecimal codes or pixel radii require final Figma token export, they are explicitly tagged `[NEEDS CONFIRMATION]`.

---

## 1. Brand Identity & Visual Language

- **Brand Tone**: Modern, energetic, academic, and trustworthy. Designed to inspire confidence in parents while engaging and motivating students.
- **Visual Style (Soft 3D / Tactile Elevation)**:
  - Cards, progress rings, and action buttons use gentle rounded forms (`16px` - `24px` radius) with subtle dual-offset shadows.
  - Claymorphic/3D illustrations are reserved for achievement badges, welcome heroes, and empty states.
  - Avoid flat, dull, wireframe-style gray layouts; maintain vibrant contrast and visual hierarchy.

---

## 2. Color Palette Tokens `[NEEDS CONFIRMATION — PENDING FIGMA TOKEN EXPORT]`

| Token Name | Candidate Color / Value | Usage | Status |
|---|---|---|:---:|
| `primary` | `#2D5BFF` (TrueLern Royal Blue) | Primary CTA buttons, active tab indicators, branding highlights | `[NEEDS CONFIRMATION]` |
| `primaryDark` | `#1A3DBF` | Pressed button states, deep header backgrounds | `[NEEDS CONFIRMATION]` |
| `secondary` | `#00C9A7` (Teal Accent) | Attendance badges, success states, verified icons | `[NEEDS CONFIRMATION]` |
| `accentAmber` | `#FFB800` (Amber Gold) | Upcoming live class warnings, pending homework, rating stars | `[NEEDS CONFIRMATION]` |
| `accentCoral` | `#FF5C5C` (Coral Red) | Overdue invoices, error banners, recording active indicators | `[NEEDS CONFIRMATION]` |
| `backgroundLight` | `#F8F9FD` (Off-white / Slate 50) | Light theme scaffold background | `[NEEDS CONFIRMATION]` |
| `surfaceLight` | `#FFFFFF` | Light theme cards, bottom navigation bar, modal sheets | `[NEEDS CONFIRMATION]` |
| `backgroundDark` | `#0F1423` (Deep Obsidian) | Dark theme scaffold background | `[NEEDS CONFIRMATION]` |
| `surfaceDark` | `#1A2035` (Dark Slate Card) | Dark theme cards and input containers | `[NEEDS CONFIRMATION]` |
| `textPrimary` | `#121826` (Light) / `#F3F4F6` (Dark) | Headings and primary labels | `[NEEDS CONFIRMATION]` |
| `textSecondary` | `#64748B` (Light) / `#94A3B8` (Dark) | Timestamps, subtitles, rubric descriptions | `[NEEDS CONFIRMATION]` |

---

## 3. Typography Hierarchy

The app uses a modern geometric sans-serif font (Google Fonts: **Plus Jakarta Sans** or **Inter**):

| Style Level | Size | Weight | Line Height | Usage |
|---|---|---|---|---|
| `Display` | 32sp | Bold (700) | 40sp | Splash hero title, major dashboard greeting |
| `Headline` | 24sp | Bold (700) | 32sp | Screen titles, section headers (e.g., "Live Classes") |
| `Title` | 18sp | SemiBold (600) | 26sp | Card titles, course names, modal sheet headers |
| `BodyMedium` | 15sp | Regular (400) | 22sp | Assignment instructions, announcement body |
| `BodySmall` | 13sp | Regular (400) | 18sp | Secondary descriptions, timestamps, helper text |
| `Label` | 12sp | Medium (500) | 16sp | Badges, status chips, bottom navigation labels |

---

## 4. UI Geometry & Component Standards

### 4.1 Border Radii
- Small Elements (Chips, Badges): `8px`
- Input Fields & Standard Buttons: `12px` - `14px`
- Surface Cards & Modals: `16px` - `20px`
- Bottom Sheets & Sticky Drawers: `24px` (Top corners only)

### 4.2 Buttons
- **Primary CTA**: Height `52px`, full-width or adaptive, filled with `primary` gradient, bold label, slight elevation (`shadowBlur: 12, shadowOpacity: 0.15`).
- **Secondary Button**: Outlined with `1.5px` border or soft tinted background (`primary.withOpacity(0.1)`).
- **Disabled State**: Opacity reduced to `0.4`, completely non-reactive to taps; no pointer events.

### 4.3 Form Inputs
- Clear floating labels with distinct hint text.
- Validation errors rendered directly below the field with red helper text and an exclamation icon.
- Password fields must always include a toggleable visibility eye icon.

---

## 5. Mandatory Screen State Guidelines

Every screen that loads data from an API must implement four distinct, beautiful states:

```
┌────────────────────────────────────────────────────────┐
│ 1. Loading State:                                      │
│    • Shimmer effect matching exact card geometry       │
│    • Never show raw generic spinning circle alone      │
├────────────────────────────────────────────────────────┤
│ 2. Populated State:                                    │
│    • High-contrast cards, tactile elevation, clean typography │
│    • Smooth pull-to-refresh transition                 │
├────────────────────────────────────────────────────────┤
│ 3. Empty State:                                        │
│    • Curated brand illustration or soft 3D vector      │
│    • Clear title: "No Assignments Due"                 │
│    • Helpful message + optional action button          │
├────────────────────────────────────────────────────────┤
│ 4. Error / Offline State:                              │
│    • Specific error illustration (Network vs Server)   │
│    • Human-readable error message (never raw JSON)     │
│    • Prominent "Retry Now" button                      │
└────────────────────────────────────────────────────────┘
```

---

## 6. Navigation Patterns

1. **Bottom Navigation Bar**:
   - Anchored to the bottom of primary screens.
   - Hides automatically when entering full-screen immersive flows (e.g., Jitsi Live Classroom, fullscreen video player).
   - Shows active badge dots for unread notifications or newly posted assignments.
2. **Context Switching Header**:
   - For parents with multiple wards: Top header contains the Ward Selector widget (`WardAvatar` + Name + dropdown caret).
   - Tapping opens a smooth modal sheet to switch the active child context.
3. **Back Navigation**:
   - Android hardware back button and top app bar back arrow must behave identically.
   - Discarding unsaved assignment submissions or active exam attempts triggers a confirmation modal dialog.

---

## 7. Responsive & Accessibility Rules

- **Target Form Factor**: Mobile phones (portrait orientation primary; landscape supported for video and live classroom).
- **Minimum Touch Target**: Every interactive element (buttons, icons, chips) must have a touch target of at least `48x48 dp`.
- **Text Scaling**: Layouts must not clip or overflow when system font size is scaled up to 1.3x.
- **Safe Area Insets**: All top headers, bottom bars, and modal sheets must strictly respect `SafeArea` insets to prevent notch and navigation bar overlap.
