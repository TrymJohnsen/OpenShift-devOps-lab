# OpenShift DevOps Lab

Hands-on DevOps: Linux + containers + Kubernetes fundamentals practiced locally (WSL2 + lightweight Kubernetes), with OpenShift (OCP) concepts documented and mapped to real platform work (Routes, SCC, RBAC, GitOps, debugging).

## What I built (mini platform project)
- A small service deployed on Kubernetes locally
- Health checks (readiness/liveness), resource requests/limits
- Config via ConfigMap + Secret
- Basic RBAC and namespace separation
- OpenShift mapping: how I would do the same on OpenShift (Route, SCC, Projects, oc workflow, GitOps)

## Repo structure
- `docs/` – notes, checklists, and troubleshooting stories
- `manifests/` – Kubernetes YAML used in the lab
- `scripts/` – commands I ran (repeatable)
- `app/` – easy FastAPI optional demo service

## How to run locally (Windows + WSL2)
Prereqs:
- Windows with WSL2 + Ubuntu installed
- kubectl
- a lightweight local Kubernetes (k3d or kind)

High-level steps:
1. Create a local cluster
2. Apply manifests from `manifests/`
3. Verify with `kubectl get pods,svc,ingress -A`
4. remember to run `kubectl port-forward -n interview-lab svc/backend 8000:8000` to forward from your pc to the cluster as they dont talk together by default
5. Debug using logs/events/describe

(Exact commands in `scripts/`.)

## CI/CD
- Pull requests to `main` can now be validated with GitHub Actions in `.github/workflows/pr-checks.yml`
- The PR pipeline does three useful checks:
  - runs Python tests for the FastAPI app
  - builds the Docker image to catch container build failures early
  - validates Kubernetes manifests with `kubeconform`
- Pushes to `main` can use `.github/workflows/deploy-main.yml` to build and push an image to GitHub Container Registry (`ghcr.io`)
- The actual cluster deploy step is intentionally left as a safe placeholder until you add your OpenShift credentials and target namespace

### Recommended PR flow
1. Create a feature branch
2. Push your branch to GitHub
3. Open a pull request against `main`
4. Wait for the `PR Checks` workflow to pass
5. Merge the PR
6. Let the `Deploy Main` workflow build and publish the image for the cluster

## OpenShift notes (what i focused on for this project)
- OpenShift Projects vs Kubernetes Namespaces
- Routes vs Ingress
- SCC (security constraints) vs vanilla Kubernetes defaults
- `oc` workflow and day-2 operations (logs, events, rollout, RBAC)
- GitOps approach (OpenShift GitOps/Argo CD conceptually)

alias test

## Source material
- OpenShift Starter Guides (ParksMap labs): https://openshift-labs.github.io/starter-guides-html/
