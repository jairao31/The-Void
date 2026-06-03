# The Void — Backend Specification Document
# Document 3 of 5
# Version 1.0 | June 2026

---

## OVERVIEW

The backend for The Void V1 is intentionally minimal. The app is local-first — all user data lives on the device. The backend exists for two purposes only:

1. A health check endpoint so Render doesn't spin down the instance
2. A weekly report copy generator (optional — can be done client-side for true MVP)

All auth and storage is handled directly by Firebase SDKs on the client. The Flutter app talks to Firebase directly — not through this backend.

**Base URL (development):** `http://localhost:8000`
**Base URL (production):** `https://the-void-api.onrender.com`

---

## API DESIGN

### Protocol
REST over HTTPS.

### Versioning
No versioning in V1. All routes at root. When V2 introduces breaking changes, prefix with `/v2/`.

### Authentication
V1 backend endpoints are either public (health check) or not user-specific. No JWT verification in backend for V1 — Firebase handles all auth on the client side directly.

### Request/Response format
All requests and responses use `application/json`. No XML. No form data.

### Error format
All errors follow this shape:
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable description of what went wrong.",
    "field": "field_name_if_applicable"
  }
}
```

### Standard HTTP status codes used
| Code | When used |
|---|---|
| 200 | Success |
| 400 | Bad request — invalid input |
| 422 | Validation error — missing required field |
| 500 | Internal server error |
| 503 | Service unavailable (backend waking from sleep) |

---

## ENDPOINTS — COMPLETE LIST

### 1. Health Check

**Purpose:** Keep Render from spinning down the free instance. Also used by monitoring.

```
GET /health
```

**Authentication required:** No

**Request:** None

**Response 200:**
```json
{
  "status": "ok",
  "version": "1.0.0",
  "environment": "production"
}
```

**Business logic:** None. Returns immediately. No database calls.

**Error cases:** None — this endpoint must always return 200. If it can't, the server is down.

---

### 2. Generate Report Summary (optional V1)

**Purpose:** Generate a short, human-readable summary sentence for the weekly report. Can be done client-side with a simple template if backend is not ready.

```
POST /report/generate
```

**Authentication required:** No (data is anonymous aggregates — no PII)

**Request body:**
```json
{
  "total_void_minutes": 47,
  "total_sessions": 8,
  "stillness_score": 34,
  "score_change": 6,
  "longest_session_minutes": 11,
  "thoughts_harvested": 6,
  "best_thought": "Call mum more often. I keep thinking I will."
}
```

**Validation rules:**
- All integer fields must be >= 0
- `total_void_minutes` must be >= 0
- `best_thought` must be <= 500 characters if provided
- `best_thought` is optional — can be null or omitted

**Response 200:**
```json
{
  "summary": "47 minutes of nothing. That's 8 sessions of real stillness this week — your best thought proves it was worth every second.",
  "headline": "Your quietest week yet."
}
```

**Business logic:**
- Generate a summary sentence based on the stats provided
- Template-based for V1 (no AI) — use conditional logic to vary the copy
- If score_change > 0: mention growth
- If longest_session > 10 min: highlight the record
- If best_thought is provided: include a reference to it
- Keep summary under 150 characters
- Keep headline under 40 characters

**Error cases:**
- 400 if any integer field is negative
- 422 if required fields are missing
- 500 with generic message if generation fails

---

## BUSINESS LOGIC & VALIDATION RULES

### Report generation logic (Python)

```python
def generate_summary(data: ReportData) -> ReportSummary:
    parts = []
    
    # Lead with void time
    minutes = data.total_void_minutes
    if minutes < 10:
        parts.append(f"{minutes} minutes of stillness this week.")
    elif minutes < 30:
        parts.append(f"{minutes} minutes of nothing — a solid week.")
    else:
        parts.append(f"{minutes} minutes of nothing. That's significant.")
    
    # Score change
    if data.score_change > 0:
        parts.append(f"Your stillness score grew by {data.score_change} points.")
    
    # Longest session highlight
    if data.longest_session_minutes >= 10:
        parts.append(f"{data.longest_session_minutes} minutes in a single session — that's your kind of quiet.")
    
    summary = " ".join(parts)
    
    # Headline
    if data.score_change > 10:
        headline = "Your best week yet."
    elif data.total_sessions >= 7:
        headline = "Seven sessions. Seven chances to listen."
    else:
        headline = "Still here. Still quiet."
    
    return ReportSummary(summary=summary[:150], headline=headline[:40])
```

---

## BACKGROUND JOBS & QUEUES

### V1: None

The Void V1 has no background jobs. All processing happens:
- On the Flutter client (score calculation, thought tagging, report generation)
- On Firebase directly (auth token refresh, storage upload/download)

No queues. No cron jobs. No webhooks in V1.

**V2 will add:**
- RevenueCat webhook processor (subscription state changes)
- Scheduled cleanup job (delete backups for deleted accounts)

---

## THIRD-PARTY INTEGRATIONS

### Firebase (client-side — not through backend)

The Flutter app integrates directly with Firebase. The backend does NOT proxy Firebase calls.

**Firebase Auth**
- Used for: email passwordless sign-in + Google OAuth
- SDK: `firebase_auth` Flutter package
- Data sent: email address or Google account
- Data received: Firebase UID, ID token
- The backend never receives or stores Firebase tokens

**Firebase Storage**
- Used for: storing encrypted backup blobs
- SDK: `firebase_storage` Flutter package
- Storage path: `backups/{firebase_uid}/backup.enc`
- Data uploaded: AES-256 encrypted binary blob
- Data received: download URL on restore
- Max file size: ~200KB per backup (single user's data)

**Firebase Cloud Messaging**
- Used for: delivering the "Now." and Sunday report notifications
- SDK: `flutter_local_notifications` + `firebase_messaging`
- For V1: local notifications only (no server-side push triggers needed)
- FCM token stored locally on device — not sent to backend

### No other third-party integrations in V1.

---

## CACHING STRATEGY

### V1: No server-side caching

The backend is stateless and serves no user-specific data. No cache needed.

### Client-side caching (handled by Flutter/drift)

| Data | Cache strategy |
|---|---|
| Stillness score | Read from SQLite on every app open — always fresh |
| Session list | Riverpod StreamProvider — reactive to DB changes |
| Thought list | Riverpod StreamProvider — reactive to DB changes |
| Weekly report data | Computed fresh every Sunday from SQLite |
| Milestone status | Checked after every session, cached in SQLite |
| Theme preference | SharedPreferences — read once on app start |

---

## LOGGING & ERROR MONITORING

### Backend logging

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)s %(name)s %(message)s'
)
logger = logging.getLogger(__name__)

# What gets logged:
# INFO — every request: method, path, status code, duration
# WARNING — validation errors, unexpected input
# ERROR — unhandled exceptions with full stack trace
```

**Log levels:**
| Level | When |
|---|---|
| INFO | Every request, startup, shutdown |
| WARNING | Bad input, deprecated usage, slow responses (>500ms) |
| ERROR | Unhandled exceptions, Firebase errors |

**What is NEVER logged:**
- User data (thoughts, session content)
- Passwords or encryption keys
- Firebase tokens or user IDs
- IP addresses (privacy commitment)

### Flutter error handling

```dart
// Wrap all async operations in try/catch
// Never let unhandled exceptions crash the app silently

// Pattern used throughout:
try {
  await someOperation();
} on FirebaseException catch (e) {
  // Handle Firebase-specific errors
  throw AppException.fromFirebase(e);
} on SocketException {
  // No internet
  throw AppException.noInternet();
} catch (e, stackTrace) {
  // Unexpected error — log locally
  debugPrint('Unexpected error: $e\n$stackTrace');
  throw AppException.unknown();
}
```

### No crash reporting SDK in V1

No Crashlytics, Sentry, or Datadog in V1. Privacy commitment means no third-party SDKs that could collect data. Errors are logged to:
- Render logs (backend)
- Device console (Flutter, development only)

---

## DEPLOYMENT — RENDER

### render.yaml (in project root)

```yaml
services:
  - type: web
    name: the-void-api
    env: python
    buildCommand: cd backend && pip install -r requirements.txt
    startCommand: cd backend && uvicorn main:app --host 0.0.0.0 --port $PORT
    plan: free
    envVars:
      - key: APP_ENV
        value: production
      - key: APP_VERSION
        value: 1.0.0
```

### Render free tier behaviour
- Spins down after 15 minutes of inactivity
- First request after sleep: ~30 second cold start
- Acceptable for V1 — backend is rarely called
- Upgrade to $7/mo "Starter" plan when you have consistent traffic

### Keep-alive (optional)
Set up an external cron (e.g. cron-job.org, free) to ping `GET /health` every 10 minutes to prevent spin-down. Only do this if cold starts become a problem.

---

## FASTAPI PROJECT STRUCTURE

```
backend/
├── main.py
├── requirements.txt
├── .env.example
├── render.yaml
├── routers/
│   ├── __init__.py
│   ├── health.py
│   └── report.py
├── models/
│   ├── __init__.py
│   └── report_models.py
└── services/
    ├── __init__.py
    └── report_service.py
```

### main.py — complete

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import health, report
import logging

logging.basicConfig(level=logging.INFO)

app = FastAPI(
    title="The Void API",
    version="1.0.0",
    docs_url=None,   # disable Swagger UI in production
    redoc_url=None,  # disable ReDoc in production
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # tighten to app bundle ID in V2
    allow_methods=["GET", "POST"],
    allow_headers=["Content-Type"],
)

app.include_router(health.router)
app.include_router(report.router, prefix="/report")

@app.on_event("startup")
async def startup():
    logging.info("The Void API starting up")
```

### requirements.txt — complete

```
fastapi==0.104.1
uvicorn==0.24.0
pydantic==2.5.0
python-dotenv==1.0.0
httpx==0.25.2
```

---

*End of Backend Specification — Document 3 of 5*
*The Void · Version 1.0 · June 2026*
