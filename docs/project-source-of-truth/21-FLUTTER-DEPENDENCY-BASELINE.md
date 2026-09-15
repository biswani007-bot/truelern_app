# 21 — Flutter Dependency Baseline (Phase 1A Action 2B)

> [!IMPORTANT]
> **FOUNDATION DEPENDENCIES PROVISIONED & VERIFIED**:
> This document records the authorized foundation package baseline provisioned for the TrueLern unified mobile application under Phase 1A Action 2B.
> - **Action Status**: `[PROVISIONED & VERIFIED — ZERO IMPLEMENTATION]`
> - **Flutter Version**: `3.47.2` (Channel stable, on `D:\flutter`)
> - **Dart Version**: `3.13.2`
> - **Pub Cache**: `D:\.pub-cache` (Verified: all package roots point to `D:\.pub-cache`)
> - **Application Architecture**: `[NOT STARTED]` (No providers, routes, clients, or feature folders created).
> - **Parent Screens**: `[NOT STARTED]` (All 30 Parent-scoped Figma artifacts unstarted).
> - **Backend Status**: `[NOT MODIFIED]` (`POST /api/auth/login` HTTP 500 runtime blocker preserved).

---

## 1. Toolchain & Environment Baseline

| Parameter | Value | Location | Status |
|---|---|---|:---:|
| **Flutter SDK** | `3.47.2` | `D:\flutter` | **ACTIVE** |
| **Dart SDK** | `3.13.2` | `D:\flutter\bin\cache\dart-sdk` | **ACTIVE** |
| **Android SDK** | `36.0.0` (Platform 36) | `D:\Android\Sdk` | **ACTIVE** |
| **Java JDK** | OpenJDK `17.0.20.1` | `D:\Java\jdk-17` | **ACTIVE** |
| **Active Pub Cache** | `D:\.pub-cache` | `D:\.pub-cache` | **ACTIVE / VERIFIED** |
| **Active Gradle Cache** | `D:\.gradle` | `D:\.gradle` | **ACTIVE / VERIFIED** |

---

## 2. Authorized Dependencies & Purpose Register

Only the explicitly authorized foundation packages were added to [`pubspec.yaml`](file:///d:/New%20folder/New%20folder/truelearn/pubspec.yaml). Zero extraneous or speculative dependencies were added.

| Package | Category | Defined Constraint | Resolved Version | Intended Purpose | Implementation Status |
|---|:---:|:---:|:---:|---|:---:|
| **`flutter_riverpod`** | Production | `^3.4.3` | **`3.4.3`** | Parent application state management | **`NOT IMPLEMENTED`** (Package provisioned only) |
| **`go_router`** | Production | `^18.0.1` | **`18.0.1`** | Application navigation architecture | **`NOT IMPLEMENTED`** (Package provisioned only) |
| **`dio`** | Production | `^5.11.1` | **`5.11.1`** | HTTP/API communication | **`NOT IMPLEMENTED`** (Package provisioned only) |
| **`flutter_secure_storage`** | Production | `^11.0.0` | **`11.0.0`** | Secure authentication/session storage | **`NOT IMPLEMENTED`** (Package provisioned only) |
| **`google_fonts`** | Production | `^8.2.1` | **`8.2.1`** | Figma-aligned typography support | **`NOT IMPLEMENTED`** (Package provisioned only) |
| **`flutter_svg`** | Production | `^2.3.0` | **`2.3.0`** | SVG asset rendering | **`NOT IMPLEMENTED`** (Package provisioned only) |
| **`flutter_lints`** | Development | `^6.0.0` | **`6.0.0`** | Dart/Flutter linting rules | **`ACTIVE`** (Scaffold lint configuration) |

---

## 3. Unauthorized Package Audit

In accordance with Phase 1A governance, the following packages were audited and confirmed **absent** from the project:

- State Management: `provider`, `bloc`, `get`, `get_it`, `riverpod_generator` $\rightarrow$ **NONE ADDED**
- Serialization / CodeGen: `freezed`, `json_serializable`, `retrofit` $\rightarrow$ **NONE ADDED**
- Local Persistence: `hive`, `shared_preferences` $\rightarrow$ **NONE ADDED**
- Cloud / Firebase: Any Firebase packages $\rightarrow$ **NONE ADDED**
- Utility: `cached_network_image`, `permission_handler`, `image_picker`, `url_launcher`, `intl` (direct), `connectivity` $\rightarrow$ **NONE ADDED**
- Commercial / Third-Party: Payment SDKs, Social Login SDKs $\rightarrow$ **NONE ADDED**

The direct production dependencies consist strictly of the 6 authorized packages plus `flutter: sdk: flutter`.

---

## 4. Verification & Validation Results

The dependency baseline was validated through standard Flutter CLI quality gates:

### 4.1 Dependency Resolution (`flutter pub get`)
- **Status**: **`PASS`**
- **Log Summary**: Changed 59 dependencies with 0 errors. All packages downloaded into `D:\.pub-cache`.
- **Package Roots Confirmation**: Inspected `.dart_tool/package_config.json`. Confirmed package roots point directly to `file:///D:/.pub-cache/hosted/pub.dev/...`.

### 4.2 Static Code Analysis (`flutter analyze`)
- **Status**: **`PASS`**
- **Output**: `Analyzing truelearn... No issues found! (ran in 7.7s)`
- **Issues**: 0 errors, 0 warnings, 0 lints.

### 4.3 Automated Tests (`flutter test`)
- **Status**: **`PASS`**
- **Output**: `All tests passed!` (`test/widget_test.dart`).

---

## 5. Warnings & Runtime Blockers

### 5.1 Host Warnings
- **Windows Developer Mode Symlink Notice**: The Flutter CLI reported `Building with plugins requires symlink support. Please enable Developer Mode in your system settings. Run start ms-settings:developers`. Relevant for Windows desktop builds; Android builds compile via Gradle.

### 5.2 Active Runtime Blocker
- **Production Authentication HTTP 500**: `POST https://truelern.visital.in/api/auth/login` returns HTTP 500 Internal Server Error when tested against backend credentials.
- **Enforcement**: Authenticated mobile execution remains gated until backend resolution. Zero fake JWTs or mock authentication bypasses will be written.

---

## 6. Governance Status Register

```
============================================================
TRUELEARN AIO FLUTTER — DEPENDENCY BASELINE STATUS
============================================================
PHASE 1A — PARENT:
[LOCKED — APPROVED PLANNING BASELINE]

ACTION 2B — FOUNDATION DEPENDENCIES:
[PROVISIONED & VERIFIED]

PUB CACHE:
D:\.pub-cache

DEPENDENCY RESOLUTION:
[PASS]

ANALYZER:
[PASS]

TESTS:
[PASS]

UNAUTHORIZED DEPENDENCIES:
[NONE]

FLUTTER ARCHITECTURE:
[NOT STARTED]

PARENT SCREENS:
[NOT STARTED]

BACKEND:
[NOT MODIFIED]

STUDENT:
[NOT STARTED]
============================================================
```
