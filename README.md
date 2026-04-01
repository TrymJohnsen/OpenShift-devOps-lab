# OpenShift DevOps Lab

Hands-on DevOps interview preparation: Linux + containers + Kubernetes fundamentals practiced locally (WSL2 + lightweight Kubernetes), with OpenShift (OCP) concepts documented and mapped to real platform work (Routes, SCC, RBAC, GitOps, debugging).

## What I built (mini platform project)
- A small service deployed on Kubernetes locally
- Health checks (readiness/liveness), resource requests/limits
- Config via ConfigMap + Secret
- Basic RBAC and namespace separation
- Troubleshooting notes: logs/events/describe/exec patterns
- OpenShift mapping: how I would do the same on OpenShift (Route, SCC, Projects, oc workflow, GitOps)

## Repo structure
- `docs/` – notes, checklists, and troubleshooting stories
- `manifests/` – Kubernetes YAML used in the lab
- `scripts/` – commands I ran (repeatable)
- `app/` – optional demo service

## How to run locally (Windows + WSL2)
Prereqs:
- Windows with WSL2 + Ubuntu installed
- kubectl
- a lightweight local Kubernetes (k3d or kind)

High-level steps:
1. Create a local cluster
2. Apply manifests from `manifests/`
3. Verify with `kubectl get pods,svc,ingress -A`
4. Debug using logs/events/describe

(Exact commands in `scripts/`.)

## OpenShift notes (what I focused on for interviews)
- OpenShift Projects vs Kubernetes Namespaces
- Routes vs Ingress
- SCC (security constraints) vs vanilla Kubernetes defaults
- `oc` workflow and day-2 operations (logs, events, rollout, RBAC)
- GitOps approach (OpenShift GitOps/Argo CD conceptually)

## Study plan (1 week)
See `docs/00-plan.md`.

## Source material
- OpenShift Starter Guides (ParksMap labs): https://openshift-labs.github.io/starter-guides-html/
