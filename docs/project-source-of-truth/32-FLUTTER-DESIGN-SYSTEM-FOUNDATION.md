# 32 — FLUTTER DESIGN SYSTEM FOUNDATION

**Action**: Complete Restart — Phase 1 (Figma-Exact Design Foundation)  
**Status**: APPROVED & VERIFIED ON PHYSICAL DEVICE  
**Date**: 2026-09-08  
**Figma File**: TrueLern (`CiZoTN0EnITFG3e7SFwXrU`)  
**Implementation Page**: `Parent(full app)_TrueLern` (Canvas ID: `69:2`)  
**Target Physical Device**: Nothing Phone (3a) Lite (`0025565BN000479`), Android 16 (API 36)

---

## 1. Executive Summary & Strict Governance

In this phase, the Flutter mobile project's design system foundation was audited against live Figma specifications via Figma MCP and rebuilt from the ground up:
- **Zero Redesign**: No arbitrary styling, modernized tweaks, or generic UI patterns were used.
- **Single Source of Truth**: Live Figma nodes inspected via Figma MCP (`figma-dev-mode-mcp-server`) served as the sole visual authority.
- **Scope Isolation**: Exclusively inspected and mapped `Parent(full app)_TrueLern` (Canvas `69:2`). The Student page (`Truelern_student` / `28:2`) was **NOT used**.
- **No Feature Screens Implemented**: Zero screen redesigns were coded; only core tokens (`app_colors.dart`, `app_typography.dart`, `app_dimensions.dart`, `app_theme.dart`) and the local asset pipeline were configured.
- **Physical Device Verification**: The application was built, deployed, and visually inspected on the connected physical device (Nothing Phone 3a Lite).

---

## 2. Figma MCP Source Nodes Inspected

| Component / Layer | Figma Node ID | Inspected Properties |
|---|---|---|
| **App Icon Launcher (Brand Spec)** | `71:3` | Explicitly dictates Brand Primary Blue `#0037B1`, squircle/circle variants |
| **Parent Dashboard Canvas** | `76:3476` | Canvas gradient (`106.91deg`, `#F3E8FF` -> `#E0F2FE` -> `#FFFFFF`), card radius `16px`, `Hanken Grotesk` typography |
| **Live Class Schedule / Timetable** | `76:1820` | `#0037B1` active date pill, `#22D3EE` accent cyan, `#14B8A6` accent teal, card radius `16px` |
| **Parent Login / Auth** | `71:232` | `Hanken Grotesk` display + `Be Vietnam Pro` inputs, card radius `24px`, primary button `#0037B1` |
| **Splash / Brand Mark** | `71:84` | Floating SVG badges, centered TrueLern wordmark + crest |

---

## 3. Extracted Design Tokens

### 3.1 Colors (`lib/core/theme/app_colors.dart`)
- **Primary Brand Color**: `#0037B1` (Figma Brand Blue, correcting previous erroneous `#2563EB`)
- **Primary Variations**:
  - `primaryDark`: `#002B8C`
  - `primaryLight`: `#1E4ED8`
  - `primaryTonal`: `#E0E7FF`
- **Accents**:
  - `accentCyan`: `#22D3EE` (10% bg: `rgba(34, 211, 238, 0.1)`)
  - `accentTeal`: `#14B8A6` (10% bg: `rgba(20, 184, 166, 0.1)`)
  - `accentOrange`: `#F97316`
- **Canvas Gradients**:
  - Multi-stop gradient: `#F3E8FF` (Lavender) -> `#E0F2FE` (Sky Blue) -> `#FFFFFF` (Pure White)
- **Glassmorphism**:
  - `surfaceGlass`: `rgba(250, 248, 255, 0.8)` (`0xCCFAF8FF`)
  - `surfaceGlassBorder`: `rgba(255, 255, 255, 0.5)` (`0x80FFFFFF`)
- **Typography & Neutrals**:
  - `textPrimary`: `#0F172A`
  - `textSecondary`: `#475569`
  - `textMuted`: `#94A3B8`
  - `border`: `#E2E8F0`

### 3.2 Typography (`lib/core/theme/app_typography.dart`)
- **Primary Font Family**: `GoogleFonts.hankenGrotesk()` (Replacing generic `Inter`)
  - `displayLarge`: `32px`, Bold (`w700`), `height: 1.2`, `letterSpacing: -0.5`
  - `titleLarge`: `20px`, Bold (`w700`), `height: 1.25`, `letterSpacing: -0.2`
  - `titleMedium`: `16px`, SemiBold (`w600`), `height: 1.35`, `letterSpacing: -0.1`
  - `bodyLarge`: `16px`, Regular (`w400`), `height: 1.5`
  - `bodyMedium`: `14px`, Regular (`w400`), `height: 1.42`
  - `buttonText`: `14px`, SemiBold (`w600`), `letterSpacing: 0.1`
- **Secondary Font Family**: `GoogleFonts.beVietnamPro()` (Auth & Forms)
  - `inputLabel`: `14px`, Medium (`w500`)
  - `inputText`: `14px`, Regular (`w400`)
  - `inputHint`: `14px`, Regular (`w400`)

### 3.3 Dimensions, Radii & Shadows (`lib/core/theme/app_dimensions.dart`)
- **Grid Spacing**: 4px, 8px, 12px, 16px, 20px, 24px, 32px, 48px
- **Corner Radii**:
  - Small pills / timetable dates: `8px`
  - Form inputs & secondary buttons: `12px`
  - Cards & timetable item containers: `16px`
  - Modal sheets & hero containers: `20px`
  - Login container & bottom nav bar top corners: `24px`
  - Badges & avatars: `9999px` (Full circle)
- **Effects & Shadows**:
  - Card Shadow: `0px 4px 20px rgba(0,0,0,0.04)` + `0px 1px 4px rgba(0,0,0,0.02)`
  - Button Glow: `0px 4px 14px rgba(0, 55, 177, 0.22)`
  - Nav Bar Shadow: `0px -4px 20px rgba(0,0,0,0.04)`

---

## 4. Asset Pipeline Setup

The following 21 exact vector and bitmap assets were extracted directly from the Figma document and packaged into Flutter:
- **`assets/images/`**:
  - `truelern_logo.png`, `truelern_app_icon.png`, `truelern_favicon.png`, `google_logo.png`, `calendar_3d.png`, `thinking_3d.png`, `avatar_mia.png`, `avatar_arjun.png`, `splash_wordmark_truelern.png`, `splash_brand_mark.png`.
- **`assets/icons/`**:
  - `nav_home.svg`, `nav_classes.svg`, `nav_assignments.svg`, `nav_profile.svg`, and 7 floating splash badges (`splash_float_*.svg`).
- Configured in `pubspec.yaml` under `assets:`.

---

## 5. Local Physical Device Verification

- **Device**: Nothing Phone (3a) Lite (`0025565BN000479`, Android 16, API 36)
- **Execution**: App launched and rendered in real time.
- **Verification Matrix**:

| Element | Figma Specification | Flutter Implementation | Physical Device Verification | Result |
|---|---|---|---|---|
| **Primary Brand Color** | `#0037B1` (Node 71:3) | `AppColors.primary = Color(0xFF0037B1)` | Sign In button rendered in deep rich `#0037B1` blue | **PASS** |
| **Typography** | `Hanken Grotesk` (Node 76:3476, 71:232) | `GoogleFonts.hankenGrotesk()` | Headlines & labels rendered in authentic Hanken Grotesk | **PASS** |
| **Card Corner Radius** | `24px` on Auth Card (Node 71:232) | `BorderRadius.circular(24.0)` | Card smoothly rounded to 24px on physical OLED screen | **PASS** |
| **Input Corner Radius** | `12px` (Node 71:232) | `BorderRadius.circular(12.0)` | Email and password inputs match 12px rounded contour | **PASS** |
| **Button Glow / Shadow** | `0px 4px 14px rgba(0,55,177, 0.22)` | `AppDimensions.buttonShadow` | Subtle brand-tinted elevation visible under Sign In CTA | **PASS** |
| **Surface Styling** | `#FFFFFF` with `#E2E8F0` border | `AppColors.surface` + `BorderSide(color: border)` | Clean hairline border around white auth surface | **PASS** |

---

## 6. Code Verification & Test Results

- **Dart Analyzer**: `D:\flutter\bin\cache\dart-sdk\bin\dart.exe analyze .`
  - Result: **0 issues found!**
- **Flutter Test Suite**: `D:\flutter\bin\flutter.bat test`
  - Result: **96 / 96 tests passed (100%)**
  - Includes `theme_test.dart` asserting exact `#0037B1` and Figma grid tokens.
