# 33 — PARENT PRE-LOGIN FIGMA-EXACT IMPLEMENTATION

**Status:** COMPLETE & DEVICE-VERIFIED  
**Date:** 2026-09-08  
**Scope:** Parent App Pre-Login Flow & Login Presentation Only  
**Authority:** Figma File `TrueLern` (`CiZoTN0EnITFG3e7SFwXrU`), Page `Parent(full app)_TrueLern` (Canvas `69:2`)  
**Student Page (`Truelern_student` / `28:2`):** STRICTLY NOT USED

---

## 1. PRE-LOGIN FLOW DISCOVERY (FIGMA MCP)

Direct inspection of `Parent(full app)_TrueLern` (Canvas ID `69:2`) through the Figma MCP identified the exact 4 pre-login screens preceding Login:

1. **Screen 1 (Splash):** `Splash Screen (Production)` — Node ID `71:128` (390 × 907)
2. **Screen 2 (Onboarding 1):** `Onboarding: Learn with Fun` — Node ID `71:150` (390 × 902)
3. **Screen 3 (Onboarding 2):** `Onboarding: Grow Every Day` — Node ID `71:179` (390 × 902)
4. **Screen 4 (Onboarding 3):** `Onboarding: Learning Without Limits` — Node ID `71:208` (390 × 907)
5. **Screen 5 (Login):** `Student Login (Redesign)` — Node ID `71:232` (390 × 966)

---

## 2. FIGMA SPECIFICATIONS & ASSET EXTRACTION

| Screen | Figma Node | Canvas Size | Key Assets Extracted | Typography & Colors |
|---|---|---|---|---|
| **Screen 1** | `71:128` | 390 × 907 | 7 floating background SVGs (`imgIcon.svg`, `imgContainer.svg`, `imgContainer1.svg`, `imgContainer2.svg`, `imgIcon1.svg`, `imgContainer3.svg`, `imgContainer4.svg`), composite TrueLern mark (`imgImage1.png`, `imgImage2.png`) | Gradient: `#FFFFFF` → `#E0E7FF` (33%) → `rgba(30,78,216,0.2)` (67%) → `#FFFFFF`. Animated 3px progress bar (`#1E4ED8`). Version `v1.0.0` (`rgba(0,55,177,0.4)`). |
| **Screen 2** | `71:150` | 390 × 902 | TrueLern header logo (`truelern_logo.png`), 3D character with laptop illustration (`onboarding_fun.png`), arrow icon (`arrow_right.svg`) | Headline: Hanken Grotesk 24px Bold (`#0F172A`). Body: Be Vietnam Pro 14px Regular (`#434655`). Circular glow `#E0E7FF`. Primary button `#2563EB`. |
| **Screen 3** | `71:179` | 390 × 902 | TrueLern header logo (`truelern_logo.png`), 3D boy with lightbulb illustration (`onboarding_grow.png`), arrow icon (`arrow_right.svg`) | Headline: Hanken Grotesk 24px Bold (`#0F172A`). Body: Be Vietnam Pro 14px Regular (`#434655`). Circular glow `#E0E7FF`. Primary button `#2563EB`. |
| **Screen 4** | `71:208` | 390 × 907 | TrueLern header logo (`truelern_logo.png`), 3D boy at desk with floating tools illustration (`onboarding_limits.png`) | Headline: Hanken Grotesk 24px Bold (`#0F172A`). Body: Be Vietnam Pro 14px Regular (`#434655`). Circular glow `#E0E7FF`. Primary button `#2563EB` ("Get Started"). |
| **Login** | `71:232` | 390 × 966 | TrueLern header logo (`truelern_logo.png`), WhatsApp icon (`whatsapp_icon.svg`), Google icon (`google_icon.png`), Lock & Eye icons | Headline: Hanken Grotesk 24px Bold (`#0F172A`). Subtitle: Be Vietnam Pro 14px (`#434655`). Frosted Card: 24px radius, `#FFFFFF` with blur 40px, shadow `rgba(0,0,0,0.08)`. Input border `#C4C5D7`, Continue button `#0037B1` (radius 8px). Outlined Create Account button `#0037B1` border & text. |

---

## 3. SCREEN-BY-SCREEN DEVICE VERIFICATION TABLE

**Physical Test Device:** Nothing Phone (3a) Lite (`0025565BN000479`), Android 16 (API 36), Clean-install verification.

| Screen | Figma Node | Device Verified | Initial Mismatches | Corrections | Final Result |
|---|---|---|---|---|---|
| **Screen 1: Splash** | `71:128` | YES (Physical Device) | Progress bar thickness and floating background icon positions needed exact scale factors | Added proportional scaling to canvas (390×907), exact gradient angles, exact 3px progress bar, and 7 ghosted SVGs from Figma | **PASS** |
| **Screen 2: Onboarding 1** | `71:150` | YES (Physical Device) | Dot indicator spacing was standard Material; font family defaults | Applied exact pill indicator (24×6px active, 6×6px inactive), exact Hanken Grotesk 24px Bold, Be Vietnam Pro 14px, and 280px glow circle | **PASS** |
| **Screen 3: Onboarding 2** | `71:179` | YES (Physical Device) | Second page illustration aspect ratio and button alignment | Verified PageView index 1 sync with exact asset `onboarding_grow.png` and text strings from node `71:179` | **PASS** |
| **Screen 4: Onboarding 3** | `71:208` | YES (Physical Device) | Button label was "Next" instead of "Get Started" | Updated button dynamically on last page to "Get Started" without arrow icon, matching node `71:208` | **PASS** |
| **Login Screen** | `71:232` | YES (Physical Device) | Previous screen used outdated card layout and labels | Rebuilt presentation with 24px glass card, WhatsApp input with SVG icon, Password input with eye toggle, Continue button (`#0037B1`), Or continue with divider pill, Google auth, and Create Account button | **PASS** |

---

## 4. NAVIGATION FLOW VERIFICATION

- **Screen 1 → Screen 2:** Splash automatically bootstraps session and advances via `context.go('/onboarding')` when unauthenticated. (VERIFIED PASS)
- **Screen 2 → Screen 3:** Tapping "Next" smoothly transitions PageView to "Grow Every Day". (VERIFIED PASS)
- **Screen 3 → Screen 4:** Tapping "Next" smoothly transitions PageView to "Learning Without Limits". (VERIFIED PASS)
- **Screen 4 → Login:** Tapping "Get Started" executes `context.go('/login')`. (VERIFIED PASS)
- **Skip Control:** Tapping "Skip" on any onboarding screen immediately navigates to `/login`. (VERIFIED PASS)
- **Login → Authenticated Parent Flow:** Preserved real production authentication (`POST /api/auth/login`) with `AuthInterceptor`, secure token storage, and session validation. (VERIFIED PASS)

---

## 5. QUALITY GATES & TEST RESULTS

- **Dart Analyzer:** `dart analyze .` → **0 issues found** (PASS)
- **Flutter Test Suite:** `flutter test` → **96 passing tests / 0 failures** (PASS)
- **Runtime Integrity:** Real mobile walkthrough tests (`test/features/classes/real_mobile_walkthrough_test.dart`, `real_classes_runtime_test.dart`, `real_dashboard_runtime_test.dart`) all execute and pass against the real backend without regressions.
