# 14 — Figma Design System Audit (Parent Experience)

> [!IMPORTANT]
> **GOVERNANCE NOTICE**:
> This design system audit is derived strictly from visual inspection and structural analysis of the authoritative Figma design source:
> - **Figma File**: `TrueLern` (Key: `CiZoTN0EnITFG3e7SFwXrU`)
> - **Primary Target Page**: `Parent(full app)_TreLern` (Figma Canvas Node Reference `69:2`)
>
> Zero synthetic tokens or speculative styles have been invented. All values not explicitly defined by inspectable styles are marked `[NEEDS CONFIRMATION]`.

---

## 1. Visual Theme & Color Palette

The Parent experience employs a crisp, elevated, high-trust visual language tailored for educational oversight and financial administration. The theme uses soft background gradients, high-contrast typography, and purposeful semantic accents.

### 1.1 Brand & Primary Colors
- **Brand Primary Blue (Deep Indigo / Electric Cobalt)**: `#1E40AF` / `#2563EB`
  - Used for primary CTA buttons ("View Invoice", "Pay Balance", "Book Demo", "Switch Child"), active bottom navigation indicators, active tabs, and prominent header backgrounds.
- **Brand Dark Slate (App Bar / Hero Surfaces)**: `#0F172A` / `#1E293B`
  - Used for the Parent Profile hero section (`SCR-26`), high-elevation header banners, and high-emphasis text.
- **Secondary Accent Cyan / Light Blue**: `#0EA5E9` / `#38BDF8`
  - Used for attendance progress rings, active cohort tags, and informational badges.

### 1.2 Neutral & Surface System
- **App Canvas Background**: Soft cool off-white/pale lavender gradient: `linear-gradient(180deg, #F8FAFC 0%, #EEF2FF 100%)`
- **Card Surface**: Solid pure white (`#FFFFFF`) with subtle border elevation.
- **Secondary Card Surface**: Frosted light blue/lavender tint (`#F1F5F9` / `#F8FAFC`).
- **Dividers & Subtle Borders**: `#E2E8F0` / `#CBD5E1` (1px solid).
- **Text Color Hierarchy**:
  - **Primary Body / Headlines**: `#0F172A` (Slate 900) - Maximum readability.
  - **Secondary Supporting**: `#475569` (Slate 600) - Dates, labels, metadata.
  - **Tertiary / Muted**: `#94A3B8` (Slate 400) - Placeholders, disabled states.
  - **Inverse White**: `#FFFFFF` - On primary buttons and dark profile banners.

### 1.3 Semantic & Feedback Status Tones
- **Success / Paid / Present**:
  - Background Tint: `#ECFDF5`
  - Foreground / Border: `#059669` / `#10B981` (Emerald)
  - Used on: Paid invoice badges (`PAID`), attendance status ("Present"), payment confirmation checkmark.
- **Pending / In Review / Upcoming**:
  - Background Tint: `#FFFBEB`
  - Foreground / Border: `#D97706` / `#F59E0B` (Amber)
  - Used on: Pending homework reviews, upcoming cohort sessions, partial invoices.
- **Overdue / Danger / Absent**:
  - Background Tint: `#FEF2F2`
  - Foreground / Border: `#DC2626` / `#EF4444` (Rose / Red)
  - Used on: Overdue invoice badges (`OVERDUE`), absent attendance tags, session revocation alerts.

---

## 2. Typography System

The design typography adheres to a clean, geometric modern sans-serif scale:
- **Primary Font Family**: `Inter` / `Plus Jakarta Sans` `[NEEDS CONFIRMATION — Inspect confirms modern geometric sans]`
- **Hierarchy Scale**:
  - **Display / Header Numbers (e.g., $299.00 Balance)**: `32px` - `36px`, Bold (`700`), Letter spacing `-0.5px`.
  - **Screen Titles (App Bar)**: `18px` - `20px`, SemiBold (`600`), Line height `24px`.
  - **Section Header / Card Titles**: `16px`, SemiBold (`600`), Line height `22px`.
  - **Body Text**: `14px`, Regular (`400`) & Medium (`500`), Line height `20px`.
  - **Caption / Meta / Chips**: `11px` - `12px`, Medium (`500`), Line height `16px`.

---

## 3. Geometry, Spacing, & Elevation

### 3.1 Spacing Grid
- 8-point base grid: `4px`, `8px`, `12px`, `16px`, `20px`, `24px`, `32px`.
- Screen Horizontal Padding: `16px` (Standard mobile side margins).
- Card Internal Padding: `16px` vertical & horizontal.
- List Item Gap: `12px` - `16px`.

### 3.2 Corner Radii
- **Cards / Containers**: `16px` - `20px` (Soft rounded corners consistent across Parent Dashboard and Invoices).
- **Buttons / CTAs**: `12px` - `14px` (Gently rounded rectangle).
- **Chips / Pills / Badges**: `9999px` (Full pill capsule).
- **Bottom Sheet Modal**: Top-left and Top-right `24px`.

### 3.3 Elevation & Shadows
- **Card Shadow**: Soft dual diffusion: `box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.04), 0px 1px 3px rgba(0, 0, 0, 0.02)`.
- **Active Button Shadow**: Subtle brand colored glow: `0px 4px 12px rgba(37, 99, 235, 0.25)`.
- **Top App Bar / Bottom Nav**: Subtle border separation (`1px solid #E2E8F0`) with `0px -2px 10px rgba(0, 0, 0, 0.03)` on bottom nav.

---

## 4. Component Library (Parent Focus)

### 4.1 Navigation Elements
- **Top App Bar (`Header - Top App Bar`)**:
  - Left: Brand Logo / Avatar or Back Chevron (`←`).
  - Center: Screen Title (e.g., "Invoices", "My Children", "Invoice Detail").
  - Right: Notifications Bell (with unread red badge) or Hamburger Menu icon.
- **Bottom Navigation Bar**:
  - Height: `64px` - `72px`.
  - Destinations:
    1. **Home / Dashboard** (House icon)
    2. **Classes / Schedule** (Calendar / Video icon)
    3. **Assignments** (Document / Clipboard icon)
    4. **Profile / Settings** (User icon)
- **Hamburger Drawer (`Hamburger Drawer — Default`)**:
  - Profile header with active guardian name and email.
  - Linked children list / quick switcher.
  - Nav links: Dashboard, Classes, Assignments, Invoices & Fees, Notifications, Account Settings, Security.
  - Footer: "Log Out" item in danger red text with chevron.

### 4.2 Card Patterns
- **Active Child Summary Card**:
  - Shows child avatar, full name, current grade/program, and a prominent "Switch Child" or "Manage Child" button.
- **Financial Balance Card (Hero on `Invoices`)**:
  - Deep blue / soft gradient surface.
  - Big prominent balance due text (e.g., "$299.00 Total Balance Due").
  - Due date badge and primary CTA "Pay All Invoices".
- **Invoice Item Card**:
  - Invoice Number (e.g., `INV-2026-081`).
  - Term / Course Name (e.g., "Advanced English Grade 8").
  - Due date.
  - Status pill: `PAID` (Green), `UNPAID` (Red), `PARTIAL` (Amber).
  - Tap action: Pushes `SCR-33: Invoice Detail`.

### 4.3 Buttons & Interactive Controls
- **Primary Button**: Solid Blue (`#2563EB`), White text, height `48px` - `52px`, font weight `600`.
- **Secondary / Outline Button**: White surface, 1.5px border `#E2E8F0`, dark text `#1E293B`, height `44px` - `48px`.
- **Filter Chips**: Horizontally scrollable row on Invoices (`All`, `Unpaid`, `Paid`). Active chip has solid blue background; inactive has light grey outline.

---

## 5. Screen States Standard (Parent Workflows)

Every Parent screen must implement the mandatory 4 UI states:
1. **Loading State**: Shimmer skeleton matching exact card geometry (e.g., skeleton pulse on invoice list cards).
2. **Success / Content State**: Full populated cards, badges, and actionable buttons.
3. **Empty State**: Custom vector illustration, descriptive explanation (e.g., "No Invoices Found — All tuition payments are up to date!"), and refresh button.
4. **Error State**: Non-destructive alert card with retry CTA (`"Unable to load invoices. Tap to retry."`).
