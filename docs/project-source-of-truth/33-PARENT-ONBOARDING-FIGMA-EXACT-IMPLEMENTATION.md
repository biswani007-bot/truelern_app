# 33 — PARENT ONBOARDING FIGMA-EXACT IMPLEMENTATION

**Status:** COMPLETE & DEVICE-VERIFIED  
**Date:** 2026-09-08  
**Scope:** Parent 3-Screen Pre-Login Onboarding Only  
**Authority:** Figma File `TrueLern` (`CiZoTN0EnITFG3e7SFwXrU`), Page `Parent(full app)_TrueLern` (Canvas `69:2`)  
**Student Page (`Truelern_student` / `28:2`):** STRICTLY NOT USED

---

## 1. FIGMA DISCOVERY & NODE AUDIT

Inspection via Figma MCP on `Parent(full app)_TrueLern` confirms the exact three onboarding screens before Login:

1. **Screen 1:** `Onboarding: Learn with Fun` — Node ID: `71:150` (390 × 902)
2. **Screen 2:** `Onboarding: Grow Every Day` — Node ID: `71:179` (390 × 902)
3. **Screen 3:** `Onboarding: Learning Without Limits` — Node ID: `71:208` (390 × 907)
4. **Login:** `Student Login (Redesign)` — Node ID: `71:232` (390 × 966)

*Note: There is no fourth onboarding screen. Screen 3 transitions directly into Login.*

---

## 2. EXACT FIGMA MEASUREMENTS & SPECIFICATIONS

### Header Area (All 3 Screens)
- Container: x=20-24, y=32, w=342, h=80
- TrueLern Brand Logo: w=142.05, h=48 (`assets/images/truelern_logo.png`)
- Skip Button: x=290.25, y=30, w=31.75, h=20, Text `Skip`, font Hanken Grotesk 14px SemiBold (#434655).

### 3D Illustration Area
- Screen 1 (71:150): Container 369×369, background circular glow 296×296 (#E0E7FF), illustration `onboarding_fun.png` (320×310).
- Screen 2 (71:179): Container 341×341, background circular glow 296×296 (#E0E7FF), illustration `onboarding_grow.png` (320×310).
- Screen 3 (71:208): Container 382×382, decorative blob 296.5×296.5 (#E0E7FF), illustration `onboarding_limits.png` (320×310).

### Typography & Copy
- **Headlines:** Hanken Grotesk 24px Bold (700), height: 1.25, letter spacing: -0.3, color: `#0F172A`.
  - Screen 1: "Learn with Fun"
  - Screen 2: "Grow Every Day"
  - Screen 3: "Learning Without Limits"
- **Body / Subtitles:** Be Vietnam Pro 14px Regular (400), height: 1.5, color: `#434655`.
  - Screen 1: "Interactive games and activities\nthat make learning exciting."
  - Screen 2: "Build confidence and essential\nskills step by step."
  - Screen 3: "Safe, easy, and available\nwherever your child is."

### Pagination Dots
- Active Indicator: 32px pill, height: 8px, radius: 4px, color: `#0037B1` / `#2563EB`.
- Inactive Indicators: 8px dot, height: 8px, radius: 4px, color: `#E2E8F0`.
- Spacing: 8px gap between indicators.

### Bottom Action Button
- Height: 56px, full width with 24px horizontal padding (width 342px on 390px reference frame).
- Fill: `#2563EB` solid fill with shadow `rgba(37, 99, 235, 0.28)` blur 14px, offset (0, 4).
- Radius: 12px.
- Screen 1 & 2 CTA: Text "Next" (Hanken Grotesk 15px SemiBold) + right arrow icon (`assets/icons/arrow_right.svg`, 17×17).
- Screen 3 CTA: Text "Get Started" (Hanken Grotesk 15px SemiBold) without arrow icon.

---

## 3. SCREEN-BY-SCREEN DEVICE VERIFICATION

**Physical Test Device:** Nothing Phone (3a) Lite (`0025565BN000479`), Android 16 (API 36).

| Screen | Figma Node | Device | Initial Result | Corrections | Final Result |
|---|---|---|---|---|---|
| **Screen 1: Learn with Fun** | `71:150` | Nothing Phone (3a) Lite | Initial text used default display sizes; background glow was gradient | Changed headline to Hanken Grotesk 24px Bold, body to Be Vietnam Pro 14px Regular, circular glow to solid `#E0E7FF` 296×296, button fill to primary solid `#2563EB` | **PASS** |
| **Screen 2: Grow Every Day** | `71:179` | Nothing Phone (3a) Lite | Text spacing and indicator pill sync needed audit | PageView index 1 verified with exact asset `onboarding_grow.png`, active dot in position 2, and Next CTA | **PASS** |
| **Screen 3: Learning Without Limits** | `71:208` | Nothing Phone (3a) Lite | Button text needed dynamic switch to "Get Started" | PageView index 2 verified with exact asset `onboarding_limits.png`, active dot in position 3, button text "Get Started" without arrow icon | **PASS** |

---

## 4. NAVIGATION FLOW VERIFICATION

- **Screen 1 → Screen 2:** Tapping "Next" smoothly transitions to "Grow Every Day". (PASS)
- **Screen 2 → Screen 3:** Tapping "Next" smoothly transitions to "Learning Without Limits". (PASS)
- **Screen 3 → Login:** Tapping "Get Started" triggers `context.go('/login')`. (PASS)
- **Skip Control:** Tapping "Skip" on any onboarding screen immediately navigates to `/login`. (PASS)
- **Authentication:** Unchanged. Real `POST /api/auth/login` preserved.

---

## 5. QUALITY GATES & TEST RESULTS

- **Dart Analyzer:** `dart analyze .` → **0 issues found** (PASS)
- **Flutter Test Suite:** `flutter test` → **96 passing tests / 0 failures** (PASS)
