# 22 — Flutter Core Architecture Foundation (Phase 1A Action 3)

> [!IMPORTANT]
> **GOVERNANCE & IMPLEMENTATION BOUNDARY STATUS**:
> This document records the architectural foundation and reusable core infrastructure implemented for the TrueLern unified mobile application under Phase 1A Action 3.
> - **CORE FOUNDATION**: **`[IMPLEMENTED & VERIFIED]`**
> - **PARENT FEATURE SCREENS**: **`[NOT IMPLEMENTED / NOT STARTED]`**
> - **STUDENT EXPERIENCE (PHASE 1B)**: **`[NOT STARTED]`**
> - **PRODUCTION API BASE**: `https://truelern.visital.in/api`
> - **AUTHENTICATION RUNTIME GATE**: `POST /api/auth/login` HTTP 500 preserved; zero fake tokens or mock logins created.

---

## 1. Final Core Directory & Architecture Structure

```text
lib/
├── app.dart                          # TrueLernApp (MaterialApp.router with theme & router)
├── main.dart                         # Entry point wrapping ProviderScope
└── core/
    ├── config/
    │   └── app_config.dart           # AppConfig (production baseUrl: https://truelern.visital.in/api, timeouts)
    ├── constants/
    │   ├── api_constants.dart        # Header keys, content-types, pagination defaults
    │   ├── asset_paths.dart          # Canonical asset path constants (icons, images, illustrations)
    │   └── storage_keys.dart         # Secure storage keys (accessToken, refreshToken, userId)
    ├── error/
    │   ├── error_handler.dart        # Centralized ErrorHandler mapping DioException to Failure
    │   ├── exceptions.dart           # Low-level application exceptions (NetworkException, ServerException, etc.)
    │   └── failures.dart             # Domain-level failure hierarchy (NetworkFailure, ServerFailure, etc.)
    ├── network/
    │   ├── api_client.dart           # Single configured ApiClient wrapping Dio with typed get/post/put/delete
    │   └── auth_interceptor.dart     # QueuedInterceptor attaching Bearer token if present
    ├── router/
    │   ├── app_router.dart           # GoRouter definition with core lifecycle routes & routerProvider
    │   └── route_names.dart          # Type-safe route name and path constants
    ├── storage/
    │   └── secure_storage_service.dart # SecureStorageService abstraction and FlutterSecureStorage implementation
    ├── theme/
    │   ├── app_colors.dart           # Figma-audited color palette
    │   ├── app_dimensions.dart       # 8-pt grid spacing, radii, card/button shadows
    │   ├── app_theme.dart            # Material 3 ThemeData with custom ColorScheme and Inter typography
    │   └── app_typography.dart       # GoogleFonts.inter text styles
    └── utils/
        └── app_logger.dart           # Debug-mode logging utility via dart:developer
```

---

## 2. Layer-by-Layer Architectural Specifications

### 2.1 Riverpod State Architecture
- **Root**: `ProviderScope` initialized in `lib/main.dart` wrapping `TrueLernApp`.
- **Foundation Providers**:
  - `appConfigProvider`: Exposes immutable `AppConfig.production`.
  - `secureStorageProvider`: Injects `SecureStorageService`.
  - `dioProvider`: Configures singleton `Dio` with base options, JSON headers, and `AuthInterceptor`.
  - `apiClientProvider`: Injects `ApiClient`.
  - `appThemeProvider`: Injects Material 3 `ThemeData`.
  - `routerProvider`: Injects configured `GoRouter`.
- **Constraint**: Zero feature-specific or business-logic providers (no dashboard, assignments, or child state) created in this step.

### 2.2 GoRouter Navigation Architecture
- **Initial Route**: `AppRoutePaths.splash` (`/splash`).
- **Lifecycle Support**:
  1. Bootstrap / Splash: `/splash`
  2. Authentication: `/login`
  3. Parent Shell: `/parent` with sub-routes `/parent/dashboard`, `/parent/classes`, `/parent/assignments`, `/parent/invoices`, `/parent/profile`.
- **Placeholders**: Infrastructure uses `CoreRouterPlaceholderScreen` to verify navigation flows without implementing feature UI screens.
- **Identifiers**: Strictly aligned with [`18-PARENT-FLUTTER-IMPLEMENTATION-BLUEPRINT.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/18-PARENT-FLUTTER-IMPLEMENTATION-BLUEPRINT.md) and [`16-PARENT-MASTER-NAVIGATION-FLOW.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/16-PARENT-MASTER-NAVIGATION-FLOW.md).

### 2.3 Dio Networking Architecture
- **Base URL**: `https://truelern.visital.in/api` (strictly enforced via `AppConfig`).
- **Timeouts**: 15 seconds connect, 15 seconds receive, 15 seconds send.
- **Headers**: Standard `application/json` content-type and accept headers.
- **Error Mapping**: All exceptions during `get`, `post`, `put`, `delete` pass through `ErrorHandler.handle()` to throw typed `Failure` objects.
- **Constraint**: No production API calls are executed during app startup.

### 2.4 Auth Interceptor Architecture
- **Token Injection**: Asynchronously queries `SecureStorageService.getAccessToken()`. If present, injects `Authorization: Bearer <token>`.
- **Safety Invariant**: If no token exists, the request proceeds unauthenticated. Does NOT generate synthetic/fake JWTs, mock sessions, or bypasses.
- **401 Handling**: Generic interceptor hook ready for session expiration handling.

### 2.5 Secure Storage Architecture
- **Contract**: `SecureStorageService` interface defining save/get/delete for access token, refresh token, user ID, and `clearAuthSession()`.
- **Implementation**: `FlutterSecureStorageServiceImpl` backed by `FlutterSecureStorage` (standard AES-GCM with RSA OAEP key wrapping on Android).

### 2.6 Configuration Architecture
- **Source of Truth**: `AppConfig.production`.
- **Multi-Environment Strategy**: Extensible via `AppEnvironment` enum and `--dart-define` compilation flags without requiring third-party environment packages.

### 2.7 Error Architecture
- **Domain Failures (`Failure`)**: Sealed class hierarchy with `NetworkFailure`, `TimeoutFailure`, `ServerFailure`, `AuthFailure`, `ValidationFailure`, `UnknownFailure`.
- **Low-Level Exceptions (`AppException`)**: `NetworkException`, `TimeoutException`, `ServerException`, `AuthException`, `StorageException`.
- **Mapper (`ErrorHandler`)**: Converts `DioExceptionType` and backend HTTP status codes into domain failures.

### 2.8 Design System & Theme Architecture
- **Tokens Derived From**: [`14-FIGMA-DESIGN-SYSTEM-AUDIT.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/14-FIGMA-DESIGN-SYSTEM-AUDIT.md).
- **Color Palette (`AppColors`)**: Primary Cobalt `#2563EB`, Deep Indigo `#1E40AF`, Dark Slate `#0F172A`, Accent Cyan `#0EA5E9`, Canvas Background `#F8FAFC`, Status colors (Emerald, Amber, Rose).
- **Typography (`AppTypography`)**: Centralized scale using `GoogleFonts.inter` across display (32-36px), title (16-20px), body (14px), caption (11-12px), and button styles.
- **Dimensions (`AppDimensions`)**: 8-pt spacing grid, radii (12px buttons, 16px cards, 24px sheets, 9999px pills), card/button shadows.
- **Theme (`AppTheme`)**: Material 3 `ThemeData` configuring color scheme, app bar, cards, elevated buttons, outlined buttons, input decoration, and dividers.

### 2.9 Asset Infrastructure
- **Constants (`AssetPaths`)**: Structured directory references (`assets/icons`, `assets/images`, `assets/illustrations`) for vector icons and images.
- **Constraint**: Zero speculative assets or mock SVGs imported.

---

## 3. Testing & Verification Approach

All core foundation modules are verified through automated unit and widget tests:

| Test File | Target Module | Verifications Performed | Status |
|---|---|---|:---:|
| [`test/core/config_test.dart`](file:///d:/New%20folder/New%20folder/truelearn/test/core/config_test.dart) | `AppConfig` | Exposes `https://truelern.visital.in/api`, 15s timeouts, production environment | **PASS** |
| [`test/core/storage_test.dart`](file:///d:/New%20folder/New%20folder/truelearn/test/core/storage_test.dart) | `SecureStorageService` | Service instantiation, StorageKeys consistency | **PASS** |
| [`test/core/error_test.dart`](file:///d:/New%20folder/New%20folder/truelearn/test/core/error_test.dart) | `ErrorHandler` | Maps timeouts, network errors, 401, 422 (validation errors), 500 to typed Failures | **PASS** |
| [`test/core/theme_test.dart`](file:///d:/New%20folder/New%20folder/truelearn/test/core/theme_test.dart) | `AppTheme`, `AppColors` | Material 3 theme instantiation, color token values, 8-pt grid constants | **PASS** |
| [`test/core/router_test.dart`](file:///d:/New%20folder/New%20folder/truelearn/test/core/router_test.dart) | `routerProvider`, `AppRoutePaths` | Initial location `/splash`, blueprint route hierarchy | **PASS** |
| [`test/widget_test.dart`](file:///d:/New%20folder/New%20folder/truelearn/test/widget_test.dart) | `TrueLernApp` | Application root pumps with ProviderScope and renders initial bootstrap route | **PASS** |

**Automated Test Summary**: **16 of 16 tests passing** (`flutter test` exit code 0).
**Static Analysis**: `flutter analyze` reports **No issues found!** (0 errors, 0 warnings, 0 lints).

---

## 4. Architectural Decisions & Deferrals

### 4.1 Decisions Made
1. **Single Networking Client**: Enforced via `ApiClient` wrapping a single `Dio` provider configured from `AppConfig`.
2. **Strict Interceptor Security**: `AuthInterceptor` only reads tokens from `SecureStorageService`; never fabricates tokens or bypasses authentication.
3. **Typography Centralization**: `GoogleFonts.inter` is consumed exclusively through `AppTypography` and `AppTheme`. Individual widgets will not invoke `GoogleFonts` directly.
4. **Compile-Time Temp Protection (`TEMP` / `TMP` to `D:\.tmp`)**:
   - **Status**: Persisted as Windows User-level environment variables (`TEMP=D:\.tmp`, `TMP=D:\.tmp`).
   - **Trigger & Root Cause**: During `flutter test`, the Dart test compiler (`flutter_test_compiler`) wrote intermediate `output.dill` kernel blobs (50-150 MB) to `%USERPROFILE%\AppData\Local\Temp` on `C:\`, triggering `FileSystemException: OS Error: There is not enough space on the disk, errno = 112` against the constrained ~83 MB free space on `C:\`.
   - **Mitigation & Retention**: Configured `D:\.tmp` with 138+ GB of free storage. Retained at User level to safeguard all future compiler and test executions against `C:\` disk exhaustion. Left intact pending user maintenance policy.

### 4.2 Decisions Intentionally Deferred
1. **Feature Repositories & Models**: Deferred to subsequent screen-specific implementation phases.
2. **Active Child Provider (`activeChildIdProvider`)**: Deferred to Child Context implementation.
3. **Production Authentication Resolution**: Deferred until backend team resolves `POST /api/auth/login` HTTP 500 error.

---

## 5. Governance Lock Status

```
============================================================
TRUELEARN AIO FLUTTER — ACTION 3 CORE ARCHITECTURE STATUS
============================================================
PHASE 1A — PARENT:
[LOCKED — APPROVED PLANNING BASELINE]

CORE FOUNDATION:
[IMPLEMENTED & VERIFIED]

PARENT FEATURE SCREENS:
[NOT IMPLEMENTED / NOT STARTED]

STUDENT (PHASE 1B):
[NOT STARTED]

BACKEND:
[NOT MODIFIED]

AUTHENTICATION RUNTIME:
[BLOCKED — PRODUCTION LOGIN HTTP 500]
============================================================
```
