# App Module

`app/` contains the demo application for this project. It is the smallest possible backend-style service i can deploy while still practicing the parts that matter in DevOps and platform work: containerization, runtime configuration, health checks, logging, and Kubernetes deployment patterns.

The app is intentionally simple. Its job is not to show advanced backend logic, but to act as a realistic workload that can be packaged into an image, started in a container, exposed on a port, and verified from the outside. That makes it useful for practicing the full path from code to running service.

## What This Module Contains

- `main.py` is the application itself.
- `Dockerfile` defines how the application is built into a container image.

Together, these files answer the question: "What are we actually running?"

## What The App Does

The app is a small Python HTTP server with two main endpoints:

| Path | Description |
|------|-------------|
| `GET /` | Returns a simple JSON response so we can confirm the app is reachable |
| `GET /health` | Returns a health response used to verify that the app is alive |

It also reads environment variables such as `PORT` and `APP_ENV`, which lets us run the same app in different environments without changing the code.

## Why This Module Exists

In a real system, platform work is not only about writing YAML. We need an actual application to deploy. The `app/` module gives the rest of the repository something concrete to build, run, expose, and debug.

Without `app/`, the Kubernetes resources would mostly be infrastructure examples. With `app/`, the repo becomes a full deployment exercise:

- the app provides the workload
- the container image packages the workload
- the manifests define how Kubernetes runs it
- the scripts make the setup repeatable

## Why The App Needs `manifests/`

The code in `app/` is only the application source. Kubernetes cannot run `main.py` directly just because the file exists in the repository.

The files in `manifests/` describe how that application should run inside the cluster:

- which container image to start
- how many replicas to run
- which port to expose
- how to check health with readiness/liveness probes
- how to inject configuration and secrets
- how to make the app reachable through a `Service` or `Ingress`

In short:

- `app/` defines the software
- `manifests/` define how the platform runs the software

## Why The App Needs `scripts/`

The files in `scripts/` are the operational layer around the app and manifests. They help automate the repeated commands we use while building and testing the lab.

Examples:

- creating a local kind cluster
- applying Kubernetes manifests
- checking rollout status
- gathering logs, events, and pod details for debugging

This is important because DevOps work is not only "write config once." It is also about repeatability and troubleshooting. The scripts make it easier to recreate the environment and explain what was done.

In short:

- `app/` is the workload
- `manifests/` are the deployment definition
- `scripts/` are the repeatable operational workflow

## How It Fits Into The Whole Repo

This repository is a lab for learning how an application moves through a deployment path:

1. Write or package an app in `app/`
2. Build it into a container image
3. Deploy it with Kubernetes manifests
4. Expose it with services or ingress
5. Verify and debug it with scripts and cluster commands

That is why `app/` should be read as one part of a larger system, not as a standalone Python exercise.

## Test Locally

If you are standing in the `app/` directory, create and activate a virtual environment:

```bash
python3 -m venv venv
source venv/bin/activate
```

Install the dependencies manually:

```bash
pip install -r requirements.txt
```

Start the app with Uvicorn on port `8000`:

```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

Important:

- If you run the command from inside `app/`, use `main:app`.
- `uvicorn app.main:app` only works if you run it from the repository root.

Test the endpoints in another terminal:

```bash
curl http://localhost:8000/
curl http://localhost:8000/health
```

With a custom environment:

```bash
APP_ENV=staging uvicorn main:app --host 0.0.0.0 --port 8000
```

## Build The Container Image

```bash
docker build -t myapp:latest .
docker run --rm -p 8000:8000 myapp:latest
```

After starting the container, you can test it with:

```bash
curl http://localhost:8000/
curl http://localhost:8000/health
```

## OpenShift / Kubernetes Compatibility

- The container runs as a non-root user (`appuser`), which is useful for OpenShift-style restricted security policies.
- The app exposes a normal HTTP port and is easy to attach to probes, services, and ingress.
- The simple logging and health endpoints make it practical for debugging deployment flow end to end.
