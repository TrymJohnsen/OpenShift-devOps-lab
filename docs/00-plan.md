# 7-day interview prep plan (DevOps, OpenShift-first concepts)

Goal: Be able to speak confidently about how I would operate workloads on OpenShift, and demonstrate Kubernetes operational knowledge locally.

## Day 1 – Linux essentials + WSL2 setup
- Linux commands: processes, systemd logs, networking basics
- Output: update `docs/01-linux-cheatsheet.md` with commands + examples

## Day 2 – Containers basics
- Image vs container, ports, env vars, volumes
- Build and run a simple container locally
- Output: update `docs/02-containers-cheatsheet.md`

## Day 3 – Kubernetes core objects
- Namespace, Deployment, Service, Ingress
- Apply a minimal app from `manifests/`
- Output: first working YAML in `manifests/`

## Day 4 – Health + config + resources
- Add readiness/liveness probes
- Add ConfigMap + Secret
- Add requests/limits
- Output: document decisions in `docs/03-kubernetes-cheatsheet.md`

## Day 5 – Debugging drills (most interview value)
- Intentionally break things and fix them
- Output: add 3–5 troubleshooting stories in `docs/05-troubleshooting-stories.md`

## Day 6 – OpenShift mapping (Routes/SCC/RBAC/GitOps)
- Explain: how the same would be done on OpenShift (oc, Route, SCC, Projects)
- Output: `docs/04-openshift-notes.md`

## Day 7 – Interview rehearsal
- Prepare 6 short stories (STAR format)
- Prepare 10 "I would do X because Y" statements about OpenShift operations
- Quick review of all docs and README polish
