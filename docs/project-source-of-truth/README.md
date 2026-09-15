# TrueLern AIO Flutter — Authoritative Project Source of Truth & Governance

> [!IMPORTANT]
> **DO NOT IMPLEMENT OUTSIDE THE APPROVED SCOPE.**
> This directory is the single authoritative planning, governance, and architectural specification area for the TrueLern AIO Flutter mobile application. All implementation work must strictly conform to these documents.
>
> **PROJECT PHASE STATUS**:
> - **PHASE 1A — PARENT**: **`[LOCKED — APPROVED PLANNING BASELINE]`**
> - **FLUTTER PROJECT**: **`[SCAFFOLDED — FOUNDATION ONLY]`**
> - **FLUTTER IMPLEMENTATION**: **`[NOT STARTED]`**
> - **BACKEND IMPLEMENTATION**: **`[NOT STARTED]`**
> - **PHASE 1B — STUDENT**: **`[NOT STARTED]`**
> - **AUTHENTICATED FLUTTER RUNTIME**: **`[BLOCKED — PRODUCTION LOGIN HTTP 500]`**
>
> Phase 1A Parent Flutter project scaffold initialized for Android & Windows (com.truelern.app).
> Application architecture, dependencies, and screen implementation remain strictly NOT STARTED. Authenticated runtime testing remains blocked by production login 500.

---

## 1. Governance Principles

1. **Authoritative Baseline**: Every design decision, routing contract, data model, and user workflow must trace directly to the documents in this directory.
2. **Scope Enforcement**: Scope expansions, new features, invented business flows, or unapproved screens are strictly forbidden. Any scope adjustment requires explicit stakeholder approval.
3. **No API Assumptions**: Client engineers must never invent endpoints, synthesize fake response envelopes, or assume backend capabilities that do not exist.
4. **Figma Fidelity & Deviations**: Screens must precisely reflect the approved Figma/Stitch design specifications. Any visual or UX deviation must be formally documented and approved before code is written.
5. **Requirements Integrity**: Implementation code must never silently alter or override product requirements.
6. **Backend Boundary**: Mobile engineers must not modify or refactor backend code during mobile implementation unless an authorized contract task is explicitly scheduled.
7. **Runtime Verification**: A feature is never considered "Done" merely because it compiles, passes static analysis, or renders in isolation. Complete runtime verification on physical or virtual Android devices against verified API endpoints is mandatory.
8. **Document Maintenance**: When an approved architectural, scope, or API decision changes, these source-of-truth documents must be updated immediately via an entry in [`10-CHANGE-LOG.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/10-CHANGE-LOG.md).

---

## 2. Source-of-Truth Document Index

| Document | Purpose | Authority Level |
|---|---|---|
| [`00-SCOPE.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/00-SCOPE.md) | Strict scope contract, boundaries, and scope change protocol | Level 1 |
| [`01-PRODUCT-SOURCE-OF-TRUTH.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/01-PRODUCT-SOURCE-OF-TRUTH.md) | Business requirements, user roles, workflows, and functional contracts | Level 1 |
| [`02-FIGMA-SOURCE-OF-TRUTH.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/02-FIGMA-SOURCE-OF-TRUTH.md) | UI layout, screen groups, visual language, and interaction specs | Level 2 |
| [`03-API-SOURCE-OF-TRUTH.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/03-API-SOURCE-OF-TRUTH.md) | Verified backend endpoints, auth schemes, schemas, and dependencies | Level 3 |
| [`04-ARCHITECTURE-RULES.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/04-ARCHITECTURE-RULES.md) | Architectural layers, Riverpod patterns, router, and data flow | Level 4 |
| [`05-UI-UX-RULES.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/05-UI-UX-RULES.md) | Design system rules, tokens, states, accessibility, and micro-interactions | Standard |
| [`06-IMPLEMENTATION-RULES.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/06-IMPLEMENTATION-RULES.md) | 20 mandatory engineering commandments for implementation | Standard |
| [`07-TESTING-VERIFICATION-RULES.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/07-TESTING-VERIFICATION-RULES.md) | Strict definition of "Done" and verification protocols | Standard |
| [`08-SCREEN-MASTER-INVENTORY.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/08-SCREEN-MASTER-INVENTORY.md) | Master inventory of all candidate & approved application screens | Standard |
| [`09-API-SCREEN-MATRIX.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/09-API-SCREEN-MATRIX.md) | End-to-end Screen → Action → API → State → UI mapping | Standard |
| [`10-CHANGE-LOG.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/10-CHANGE-LOG.md) | Immutable audit log of governance and architecture modifications | Audit |
| [`11-API-AUDIT-REPORT.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/11-API-AUDIT-REPORT.md) | Authoritative API audit, contract analysis, and dependency breakdown | Reference |
| [`12-API-RUNTIME-VERIFICATION.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/12-API-RUNTIME-VERIFICATION.md) | Runtime server verification matrix, safety gates, and live behavior | Gate |
| [`14-FIGMA-DESIGN-SYSTEM-AUDIT.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/14-FIGMA-DESIGN-SYSTEM-AUDIT.md) | Complete design tokens, components, and typography audit | Specification |
| [`15-PHASE-1-IMPLEMENTATION-READINESS.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/15-PHASE-1-IMPLEMENTATION-READINESS.md) | Phase 1 readiness matrix and blocker classification | Governance |
| [`16-PARENT-MASTER-NAVIGATION-FLOW.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/16-PARENT-MASTER-NAVIGATION-FLOW.md) | Parent verified navigation flows and modal structures | Architecture |
| [`17-PARENT-RECONCILIATION-FINAL.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/17-PARENT-RECONCILIATION-FINAL.md) | Master Parent Reconciliation Specification & Locked Planning Baseline | Level 1 Master |
| [`18-PARENT-FLUTTER-IMPLEMENTATION-BLUEPRINT.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/18-PARENT-FLUTTER-IMPLEMENTATION-BLUEPRINT.md) | Detailed Flutter Implementation Blueprint for Parent Phase 1A | Architecture Blueprint |
| [`19-FLUTTER-FOUNDATION-AUDIT.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/19-FLUTTER-FOUNDATION-AUDIT.md) | Flutter Foundation & Environment Toolchain Audit | Foundation Audit |
| [`20-FLUTTER-BUILD-ENVIRONMENT.md`](file:///d:/New%20folder/New%20folder/truelearn/docs/project-source-of-truth/20-FLUTTER-BUILD-ENVIRONMENT.md) | Flutter Build Environment & Host Storage Risk Assessment | Infrastructure Audit |

---

## 3. Status Notation Standards

To eliminate ambiguity across all documentation, items are tagged strictly with one of the following labels:

- `[VERIFIED]`: Confirmed against authoritative source files (code, backend contracts, or signed PRD).
- `[NEEDS CONFIRMATION]`: Mentioned in requirements or UI candidates, but exact specification or UX parameters require client/stakeholder sign-off.
- `[NOT FOUND]`: Capability or document referenced in discussions but missing entirely from repository source materials.
- `[OUT OF SCOPE]`: Explicitly excluded from the mobile application scope.
- `[DEPENDENCY]` / `[BACKEND DEPENDENCY]`: Feature desired by UI/PRD that requires missing backend endpoint implementation or infrastructure support.
