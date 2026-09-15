# 06 — Implementation Rules (Engineering Commandments)

> [!IMPORTANT]
> These twenty commandments are mandatory for all engineering work on the TrueLern AIO Flutter application. Any pull request or code change violating these rules will be rejected immediately.

---

## The 20 Mandatory Engineering Commandments

### 1. Inspect Before Modifying
Never assume the state of a file, dependency, or system tool. Inspect existing source code, configuration files, and dependencies thoroughly before writing or altering code.

### 2. Reuse Existing Architecture Where Sound
Follow the established unidirectional architecture (`UI → Controller → Repository → DataSource → Backend`). Do not introduce alien patterns or conflicting architectural paradigms.

### 3. Do Not Invent APIs
Never fabricate an endpoint, request payload, or response attribute. If a screen requires data not exposed by the verified backend, mark the requirement as `[BACKEND DEPENDENCY]` and pause the integration.

### 4. Do Not Invent Business Rules
Never guess validation logic, grading calculations, or permissions. Business rules must originate exclusively from the approved PRD and verified backend validation schemas.

### 5. Do Not Use Mock Data for Production Workflows
Every user-facing feature, flow, and report must connect to the live backend API endpoints. Hardcoded lists and fake static data are strictly prohibited in production flows.

### 6. Do Not Hardcode Production Credentials / Secrets
API keys, signing keys, Jitsi tokens, and server secrets must never appear in Dart source files. Use environment configurations (`--dart-define` or `.env` files outside version control).

### 7. Do Not Put Secrets into Source Control
Ensure `.gitignore` excludes keystores, `.env` files, credentials, and local build artifacts (`android/key.properties`, `google-services.json` if containing private tokens).

### 8. Do Not Modify Backend Code as Part of Mobile Work
Mobile engineers must not alter Next.js backend files, database schemas, or server middleware unless a separate backend task is explicitly assigned and authorized.

### 9. Do Not Create Duplicate Services
Maintain a single HTTP networking client singleton (`core/network/api_client.dart`), a single token storage service, and single repository implementations per domain.

### 10. Do Not Create Duplicate Models
All data models (DTOs) for the same backend entity must be declared once in `shared/models/` or the domain feature module. Never maintain conflicting parallel copies of `User`, `Child`, `LiveClass`, or `Assignment`.

### 11. Do Not Create Duplicate Navigation Systems
The application uses `go_router` exclusively. Never mix raw `Navigator.push()` calls, imperative route pushes, or custom tab managers with the central router.

### 12. Reuse Shared UI Components
Leverage existing design system widgets in `core/widgets/` and `shared/widgets/` (e.g., `AppButton`, `AppTextField`, `AppCard`, `ShimmerLoader`, `EmptyStateWidget`). Never write duplicate ad-hoc styling for core controls.

### 13. Match Approved Figma Designs
Component geometry, spacing, color tokens, and typography hierarchy must faithfully match the approved design specifications.

### 14. Keep Scope Locked
Strictly adhere to the scope defined in [`00-SCOPE.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/00-SCOPE.md). Never build unauthorized features, extra settings panels, or unapproved speculative screens.

### 15. Handle Loading, Error, and Empty States
Every API-backed screen must gracefully handle all four UI states: Loading (shimmer), Populated, Empty (meaningful illustration), and Error (informative message with retry action).

### 16. Test Actual API Integration
Validate network requests against the real backend API (verifying HTTP status codes, headers, response envelopes, and error deserialization).

### 17. Test Actual Android Runtime Behavior
Validate app compilation, layout rendering, and hardware interactions (camera, microphone for Jitsi) on the verified Android toolchain (SDK 36).

### 18. Do Not Claim Completion Based Only on Static Analysis / Build
A passing `flutter analyze` or `flutter test` command does not constitute a completed feature. Complete verification requires end-to-end runtime execution and user flow validation.

### 19. Document Deviations
If an edge case forces a temporary divergence from the design or specification, the deviation must be documented immediately in the feature commit and the source-of-truth records.

### 20. Update Source-of-Truth Documents When Decisions Change
Whenever a stakeholder-approved decision alters scope, architecture, or an API contract, immediately update the corresponding document in `docs/project-source-of-truth/` and log the entry in [`10-CHANGE-LOG.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/10-CHANGE-LOG.md).

---

## Mandatory API Gate Rule for Future Development

> [!CAUTION]
> **API GATE FOR FUTURE DEVELOPMENT**:
> **Contract verification does not equal runtime verification.**
>
> Flutter implementation may rely on an API contract for planning and typed integration design, but authenticated production behavior must be runtime verified before the corresponding feature is declared complete.
>
> Flutter development may only consume APIs classified as **`[CONTRACT VERIFIED]`** and, where runtime behavior matters, **`[RUNTIME VERIFIED]`**.
>
> An endpoint may not be invented, guessed, copied from another project, or constructed from a PRD requirement.
>
> If a required API is unavailable, implementation must stop at the dependency boundary and the issue must be reported.
