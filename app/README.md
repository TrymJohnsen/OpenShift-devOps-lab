# myapp – demo service

A minimal Python HTTP server used as the lab workload.

## Endpoints

| Path | Description |
|------|-------------|
| `GET /` | Returns a hello message and current env |
| `GET /health` | Health check (used by readiness/liveness probes) |

## Run locally
```bash
python main.py
# or
APP_ENV=staging python main.py
```

## Build image
```bash
docker build -t myapp:latest .
docker run --rm -p 8080:8080 myapp:latest
```

## OpenShift compatibility
- Runs as a non-root user (`appuser`) to satisfy the `restricted` SCC.
- No privileged capabilities required.
