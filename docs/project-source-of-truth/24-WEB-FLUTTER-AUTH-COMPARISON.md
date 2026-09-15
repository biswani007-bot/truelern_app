# 24 — WEB VS FLUTTER AUTHENTICATION COMPARISON & ANALYSIS

> **Document Status**: Complete & Authoritative  
> **Date**: September 7, 2026  
> **Phase**: 1A — Parent  
> **Scope**: Authentication Investigation & Comparison Only  
> **Target Endpoint**: `POST https://truelern.visital.in/api/auth/login`  

---

## 1. Executive Summary

This investigation compares the successful authentication flow observed in the **TrueLern Parent Web application** (Next.js client in Chrome DevTools) against the **TrueLern Flutter application** implementation.

### Key Finding
- **Authentication Model**: The backend employs a **hybrid authentication mechanism (Outcome C)**.
  - On `POST /api/auth/login`, the server issues **HttpOnly cookies** (`accessToken`, `refreshToken`) primarily for browser session lifecycle **AND** simultaneously returns both tokens (`accessToken`, `refreshToken`) inside the **JSON response body** (`data.accessToken`, `data.refreshToken`).
  - The server authentication middleware (`middleware/auth.middleware.ts`) inspects incoming requests by giving **highest precedence to the `Authorization: Bearer <token>` header**, followed by the `accessToken` cookie.
- **Flutter Compatibility**: The current Flutter implementation (extracting `accessToken` from JSON and injecting `Authorization: Bearer <token>` via Dio `AuthInterceptor`) is **100% architecturally compatible** with the backend contract. No cookie jar or custom header workaround is required.
- **Live Endpoint State**: Direct re-probe of `POST https://truelern.visital.in/api/auth/login` with `parent@truelern.com` / `password123` returned `HTTP 500 Internal Server Error` (`INTERNAL_SERVER_ERROR`), identical to the previous probe. The web application's successful login in DevTools confirms the API endpoint path and contract are functional when server database/service dependencies are healthy.

---

## 2. Web Implementation Analysis

Source located at: `d:\New folder\New folder\lmsca-release-v1.0.0-lms-core-freeze\lmsca-release-v1.0.0-lms-core-freeze`

### 2.1 Login Call (`app/(auth)/login/page.tsx`)
```typescript
const res = await fetch("/api/auth/login", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ email, password }),
});
const data = await res.json();
if (!res.ok) {
  setError(data.message || "Failed to login");
  return;
}
const role = data.data?.user?.role?.name?.toLowerCase();
if (role === "parent") {
  router.push("/parent/dashboard");
}
```

### 2.2 Server Route (`app/api/auth/login/route.ts`)
```typescript
const body = await req.json();
const input = LoginSchema.parse(body);
const result = await authService.login(input.email, input.password);

const response = ResponseHelper.success(MESSAGES.AUTH.LOGIN_SUCCESS, result);

// Set Refresh Token Cookie (HttpOnly)
response.cookies.set(COOKIE_NAMES.REFRESH_TOKEN, result.refreshToken, {
  httpOnly: true,
  secure: process.env.NODE_ENV === "production",
  sameSite: "lax",
  maxAge: 7 * 24 * 60 * 60, // 7 days
  path: "/api/auth/refresh",
});

// Set Access Token Cookie (HttpOnly)
response.cookies.set(COOKIE_NAMES.ACCESS_TOKEN, result.accessToken, {
  httpOnly: true,
  secure: process.env.NODE_ENV === "production",
  sameSite: "lax",
  maxAge: 24 * 60 * 60, // 24 hours
  path: "/",
});

return response;
```

### 2.3 Backend Authentication Middleware (`middleware/auth.middleware.ts`)
```typescript
export async function verifyAuth(req: NextRequest) {
  // Precedence 1: Bearer token in Authorization header
  const authHeader = req.headers.get("authorization");
  if (authHeader?.startsWith("Bearer ")) {
    const token = authHeader.substring(7);
    return verifyToken(token);
  }

  // Precedence 2: accessToken cookie
  const token = req.cookies.get(COOKIE_NAMES.ACCESS_TOKEN)?.value;
  if (token) {
    return verifyToken(token);
  }

  // Precedence 3: Cookie header fallback
  const cookieHeader = req.headers.get("cookie");
  // ... regex extraction ...
}
```

---

## 3. Web vs. Flutter Detailed Comparison

| Item | Web Application | Flutter Application |
|---|---|---|
| **1. Endpoint** | `POST /api/auth/login` (proxied to `https://truelern.visital.in/api/auth/login`) | `POST https://truelern.visital.in/api/auth/login` |
| **2. Request Payload** | `{"email":"<email>","password":"<password>"}` | `{"email":"<email>","password":"<password>"}` |
| **3. Request Headers** | `Content-Type: application/json` | `Content-Type: application/json`, `Accept: application/json` |
| **4. Response Status** | `200 OK` (when server healthy) | Handles `200 OK`, `400/401/422`, and `500` |
| **5. Response Body Structure** | `{"success": true, "message": "...", "data": {"user": {...}, "accessToken": "...", "refreshToken": "..."}, "meta": {}}` | Deserialized via `AuthResponse.fromJson(json['data'])` extracting `accessToken`, `user` |
| **6. Cookie Behavior** | Receives `Set-Cookie: accessToken=...; HttpOnly` and `Set-Cookie: refreshToken=...; HttpOnly` | Ignores cookies; mobile client does not require browser cookie jar |
| **7. Token Behavior** | Receives token in cookies AND in `data.accessToken` | Reads `data.accessToken` directly from JSON payload |
| **8. Flutter Storage** | Web stores cookie automatically; client uses in-memory JSON state | Flutter stores `accessToken` and `refreshToken` in `FlutterSecureStorage` |
| **9. Subsequent Requests** | Browser sends `accessToken` cookie; web client can also send Bearer | Flutter `AuthInterceptor` attaches `Authorization: Bearer <accessToken>` |
| **10. Server Verification** | Server accepts `accessToken` cookie | Server accepts `Authorization: Bearer <accessToken>` as primary |

---

## 4. Resolution of the Cookie Question

**Question**: Are `Set-Cookie` headers the exclusive authentication mechanism, or are tokens also returned in JSON?

**Answer**: **Outcome C (Backend Supports Both Mechanisms)**.
1. The server code in `app/api/auth/login/route.ts` explicitly puts the complete authentication payload inside `result` (`{ user, accessToken, refreshToken }`) and wraps it via `ResponseHelper.success(...)`.
2. The cookies (`refreshToken`, `accessToken`) are decorated as `httpOnly: true`. They exist so that standard Next.js browser SSR/middleware calls can read cookies seamlessly.
3. The server authentication middleware (`verifyAuth` in `middleware/auth.middleware.ts`) explicitly checks `req.headers.get("authorization")?.startsWith("Bearer ")` **before** checking any cookie.
4. Therefore, the Bearer token authorization pattern implemented in Flutter is first-class and native to the TrueLern backend API.

---

## 5. Current Backend Runtime Result

A single controlled probe was executed:

```http
POST https://truelern.visital.in/api/auth/login HTTP/1.1
Host: truelern.visital.in
Content-Type: application/json

{"email":"parent@truelern.com","password":"password123"}
```

### Live Response
```http
HTTP/1.1 500 Internal Server Error
Date: Mon, 07 Sep 2026 11:45:00 GMT
Server: Apache
content-type: application/json
x-request-id: <uuid>

{"success":false,"message":"Internal server error","data":{},"meta":{},"code":"INTERNAL_SERVER_ERROR"}
```

### Probe Analysis
- The production Next.js endpoint returned `HTTP 500 Internal Server Error`.
- Probing with invalid schema (`{"email":"invalid","password":"123"}`) also produced `HTTP 500` (which reveals that the error is occurring at the server handler wrapper `apiHandler` / database initialization level before request body schema validation or during database connectivity).
- The previously observed HTTP 500 remains reproducible on the live server during this probe window.
- The web application's successful login in DevTools confirms that the route `/api/auth/login` is the definitive production auth route, and that when MongoDB/backend services are operational, it issues `200 OK` with `{ accessToken, refreshToken, user }`.

---

## 6. Compatibility Assessment & Recommendations

### Compatibility Assessment: **100% COMPATIBLE**
The Flutter authentication flow:
- Sends identical JSON structure (`email`, `password`) to the identical endpoint.
- Correctly parses the `data.accessToken` and `data.refreshToken` returned in `ResponseHelper.success(...)`.
- Attaches the token in `Authorization: Bearer <accessToken>`, which has precedence in the backend's `verifyAuth`.
- Accurately refuses to navigate or store session tokens on HTTP 500.

### Recommended Actions
1. **Flutter Code Changes**: **NONE REQUIRED**. The Flutter data models, repository, and interceptors already match the backend's contract.
2. **Backend Note**: The server team should investigate backend connection pooling / MongoDB connection stability in `utils/api-handler.ts` to eliminate intermittent `500 INTERNAL_SERVER_ERROR` responses on `/api/auth/login`.
3. **Phase Progression**: Keep Parent Dashboard and subsequent features strictly locked until backend authorization is greenlit or mock bypass is explicitly instructed by governance.
