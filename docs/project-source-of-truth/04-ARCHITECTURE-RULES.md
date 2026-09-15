# 04 — Architecture Rules & Engineering Structure

## 1. Current Repository Audit & Baseline

| Architectural Facet | Current State | Verification Status | Notes |
|---|---|:---:|---|
| **Flutter Version** | `3.47.2 (stable)` | `[VERIFIED]` | Installed at `D:\flutter`. Framework revision `d3b14c8769`. |
| **Dart Version** | `3.13.2` | `[VERIFIED]` | Bundled with Flutter 3.47.2. |
| **Workspace Status** | Clean / Uninitialized | `[VERIFIED]` | Previous scaffold removed per explicit user instruction. |
| **Android Toolchain** | SDK 36.0.0, Build-Tools 36.0.0, JDK 17 | `[VERIFIED]` | Installed at `D:\Android\Sdk` and `D:\Java\jdk-17`. `flutter doctor -v` passed. |
| **State Management** | Riverpod (`flutter_riverpod`) | `[VERIFIED ARCHITECTURE TARGET]` | Strict reactive state management via Notifiers and Providers. |
| **Routing System** | `go_router` | `[VERIFIED ARCHITECTURE TARGET]` | Declarative, URL-aware routing with redirect guards for auth. |
| **Networking Client** | `dio` + Interceptors | `[VERIFIED ARCHITECTURE TARGET]` | Standardized REST client with automatic JWT token refresh. |
| **Secure Storage** | `flutter_secure_storage` | `[VERIFIED ARCHITECTURE TARGET]` | AES/Keystore-backed storage for access and refresh tokens. |
| **Key-Value Storage** | `shared_preferences` | `[VERIFIED ARCHITECTURE TARGET]` | Non-sensitive flags (theme mode, active child ID cache). |

---

## 2. Core Architectural Invariant

All data flow must strictly adhere to the unidirectional five-layer architecture:

```
┌────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                   │
│         (StatelessWidget / ConsumerWidget)             │
└───────────────────────────┬────────────────────────────┘
                            │ Dispatches User Intents / Listens to State
                            ▼
┌────────────────────────────────────────────────────────┐
│                   CONTROLLER LAYER                     │
│        (AsyncNotifier / StateNotifier Provider)        │
└───────────────────────────┬────────────────────────────┘
                            │ Invokes Domain Operations
                            ▼
┌────────────────────────────────────────────────────────┐
│                   REPOSITORY LAYER                     │
│         (Abstract Contract + Concrete Impl)            │
└───────────────────────────┬────────────────────────────┘
                            │ Calls Data Sources
                            ▼
┌────────────────────────────────────────────────────────┐
│                   DATA SOURCE LAYER                    │
│           (Remote Dio Client / Local Cache)            │
└───────────────────────────┬────────────────────────────┘
                            │ Executes HTTP Network Request
                            ▼
┌────────────────────────────────────────────────────────┐
│                  PRODUCTION BACKEND                    │
│            (Next.js REST API + MongoDB)                │
└────────────────────────────────────────────────────────┘
```

### Critical Rules
1. **UI Layer Isolation**: A Widget must NEVER instantiate an HTTP client, call an API endpoint, or execute raw JSON serialization. UI widgets only consume UI state and invoke methods on the controller/notifier.
2. **Single Networking System**: There shall be exactly ONE HTTP networking client singleton configured in the entire project (`core/network/api_client.dart`). Creating second `http` packages, ad-hoc `HttpClient` instances, or duplicate network clients is strictly prohibited.
3. **Single State Management System**: Riverpod is the sole approved state management library. Introducing `Bloc`, `GetX`, `Provider`, or raw global variables is forbidden.
4. **No Direct Backend Mutating**: Flutter code must never attempt to execute database queries or invoke administrative bypass routes.

---

## 3. Approved Standard Folder Structure

When the project is initialized in Phase 1, the `lib/` directory must strictly follow this domain-driven, feature-first structure:

```text
lib/
├── main.dart                       # Entry point, ProviderScope initialization
├── app/
│   ├── app.dart                    # MaterialApp.router with global theme & router
│   ├── config/
│   │   ├── app_config.dart         # Environment configuration (Prod vs Dev)
│   │   └── env_variables.dart
│   ├── router/
│   │   ├── app_router.dart         # GoRouter definitions & auth redirect logic
│   │   └── route_names.dart        # Type-safe route name constants
│   └── theme/
│       ├── app_colors.dart         # Brand palette & dark/light color tokens
│       ├── app_dimensions.dart     # Spacing, border radius, elevation constants
│       ├── app_text_styles.dart    # Typography scale
│       └── app_theme.dart          # ThemeData instances for Light and Dark modes
├── core/
│   ├── constants/                  # Storage keys, asset paths, API constants
│   ├── errors/                     # Failure models, API exceptions, error mappers
│   ├── network/                    # Dio client, AuthInterceptor, NetworkInfo
│   ├── storage/                    # SecureTokenStorage, PreferencesService
│   ├── utils/                      # Formatters, date parsers, validators
│   └── widgets/                    # Base buttons, input fields, loading states, error cards
├── features/
│   ├── auth/                       # Login, token refresh, password reset
│   ├── parent/                     # Ward switcher, parent dashboard, child academics
│   ├── student/                    # Learning dashboard, programs, topics, progress
│   ├── live_class/                 # Live class timetable, Jitsi token, live room
│   ├── assignments/                # Assignment list, submission form, evaluations
│   ├── assessments/                # Timed quizzes, question renderer, submission
│   ├── finance/                    # Invoices, receipt viewer, fee statements
│   └── notifications/              # In-app feed, read/archive actions, preferences
└── shared/
    ├── models/                     # Shared DTOs (User, Child, PaginationMeta, ApiResponse)
    └── widgets/                    # AppHeader, AppBottomNav, AppDrawer, WardAvatar
```

---

## 4. Feature Module Layering Standard

Every feature module within `features/<feature_name>/` must be partitioned into three clean sub-packages:

```text
features/<feature_name>/
├── data/
│   ├── datasources/
│   │   ├── <feature>_remote_data_source.dart
│   │   └── <feature>_local_data_source.dart
│   ├── models/
│   │   └── <feature>_dto.dart      # JSON serializable data transfer objects
│   └── repositories/
│       └── <feature>_repository_impl.dart
├── domain/
│   ├── models/
│   │   └── <feature>_entity.dart   # Immutable business entities
│   └── repositories/
│       └── i_<feature>_repository.dart # Abstract interface
└── presentation/
    ├── controllers/
    │   ├── <feature>_controller.dart # AsyncNotifierProvider
    │   └── <feature>_state.dart      # Immutable UI state union (Loading, Error, Data)
    ├── screens/
    │   └── <feature>_screen.dart
    └── widgets/
        └── <feature>_sub_widget.dart
```

---

## 5. Token Interception & Session Continuity Rule

The HTTP client must include an `AuthInterceptor` implementing this exact lifecycle:

```
[Outgoing Request] ──► Inject "Authorization: Bearer <accessToken>"
                             │
                      [Server Response]
                             │
          ┌──────────────────┴──────────────────┐
          │ HTTP 200/201                        │ HTTP 401 Unauthorized
          ▼                                     ▼
    Return Payload                 Lock Request Queue
                                         │
                                   Call POST /api/auth/refresh
                                   with stored refreshToken
                                         │
                         ┌───────────────┴───────────────┐
                         │ Token Refresh Success         │ Refresh Expired / Failed
                         ▼                               ▼
                   Store new accessToken           Clear secure storage
                   Retry original request          Trigger AuthState -> Unauthenticated
                   Unlock Request Queue            Redirect to Login Screen
```
