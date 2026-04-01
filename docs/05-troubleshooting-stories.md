# Troubleshooting stories

## Story 1 – CrashLoopBackOff: wrong env var reference

**Situation**: Deployed a new version of the app and all pods went into `CrashLoopBackOff` immediately.

**Task**: Find the root cause and restore service.

**Action**:
```bash
kubectl get pods -n lab
# NAME                   READY   STATUS             RESTARTS
# myapp-6d7f9b-xyz       0/1     CrashLoopBackOff   4

kubectl logs myapp-6d7f9b-xyz -n lab
# KeyError: 'DATABASE_URL'

kubectl describe pod myapp-6d7f9b-xyz -n lab
# Environment: DATABASE_URL -> secretKeyRef 'app-secret' key 'DB_URL' (not found)

kubectl get secret app-secret -n lab -o jsonpath='{.data}' | python3 -m json.tool
# Key was 'DATABASE_PASSWORD', not 'DB_URL'
# To decode a specific secret value: kubectl get secret app-secret -n lab -o jsonpath='{.data.DATABASE_PASSWORD}' | base64 -d
```
Fixed the `secretKeyRef` key name in the deployment manifest and re-applied.

**Result**: Pods became `Running` within 30 seconds. Root cause was a copy-paste error in the secret key name.

---

## Story 2 – Pending pod: insufficient resources

**Situation**: A new deployment sat in `Pending` indefinitely on the local k3d cluster.

**Task**: Understand why the scheduler could not place the pod.

**Action**:
```bash
kubectl describe pod myapp-pending -n lab
# Events:
#   Warning  FailedScheduling  ... 0/1 nodes are available:
#   1 Insufficient cpu.

kubectl get nodes -o custom-columns="NODE:.metadata.name,CPU:.status.allocatable.cpu,MEM:.status.allocatable.memory"
# Single node with 2 CPUs total, already heavily allocated

# Reduced requests in manifest:
# cpu: "500m"  ->  "100m"
kubectl apply -f manifests/deployment.yaml
```

**Result**: Pod scheduled and reached `Running` state. Documented requests/limits policy in `docs/03-kubernetes-cheatsheet.md`.

---

## Story 3 – Readiness probe failure: slow startup

**Situation**: Rolling update got stuck; old pods would not terminate and new pods stayed `0/1 Running`.

**Task**: Determine why the new pods were not becoming ready.

**Action**:
```bash
kubectl rollout status deployment/myapp -n lab
# Waiting for deployment "myapp" rollout to finish: 1 out of 2 new replicas have been updated...

kubectl describe pod <new-pod> -n lab
# Readiness probe failed: Get "http://10.42.0.12:8080/health": dial tcp: connection refused
# (app needed ~20 s to initialize before /health responded)

# Added initialDelaySeconds to readinessProbe:
#   initialDelaySeconds: 20   (was 5)
kubectl apply -f manifests/deployment.yaml
```

**Result**: Rolling update completed successfully. Lesson: tune `initialDelaySeconds` to match actual app startup time.

---

## Story 4 – OOMKilled: memory limit too low

**Situation**: Pod kept restarting with status `OOMKilled` under load.

**Task**: Stabilise the pod and set an appropriate memory limit.

**Action**:
```bash
kubectl get pods -n lab
# RESTARTS: 7  STATUS: OOMKilled

kubectl top pod <name> -n lab
# MEMORY: 245Mi (limit was 128Mi)

# Updated manifest:
#   limits.memory: "512Mi"
kubectl apply -f manifests/deployment.yaml
```

**Result**: Pod stopped restarting. Documented memory profiling step as a pre-deploy practice.

---

## Story 5 – Forbidden 403: missing RoleBinding

**Situation**: A developer reported they could not view pod logs in the `lab` namespace.

**Task**: Grant the minimum required permissions.

**Action**:
```bash
# Developer tried:
kubectl logs <pod> -n lab
# Error from server (Forbidden): pods "myapp-xyz" is forbidden:
# User "developer" cannot get resource "pods/log" in API group "" in namespace "lab"

kubectl get rolebindings -n lab
# No binding for 'developer'

# Applied manifests/rbac.yaml (pod-reader Role + RoleBinding for 'developer')
kubectl apply -f manifests/rbac.yaml

kubectl auth can-i get pods/log --as developer -n lab
# yes
```

**Result**: Developer gained read-only access to pods and logs in the `lab` namespace without any cluster-wide privileges.
