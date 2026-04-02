# Troubleshooting stories (for interview)

## Story 1: Pod not Ready (readinessProbe)
- Symptom:
- What I checked (commands):
- Root cause:
- Fix:
- What I learned:

## Story 2: "Forbidden" / permissions (OpenShift angle: SCC/RBAC)
- Symptom:
- What I checked:
- Root cause:
- Fix:
- What I learned:

## Story 3: Bad config / wrong port
- Symptom: `nginx` rollout timed out, pods did not become `Ready`, and `kubectl logs` gave me nothing useful.
- Checks: I used `kubectl get pods`, `kubectl describe pod`, and checked the deployment spec to see how the container was configured.
- Root cause: The pod had `runAsNonRoot: true`, but the nginx container image still expected to start as `root`. Kubernetes blocked the container before it started, which is why there were no app logs and no working `exec`.
- Fix: I updated the nginx deployment image so the container setup matched the non-root security requirement, then reapplied the manifest. Kubernetes created a new ReplicaSet, started new healthy nginx pods, and removed the old failing ones.
- Learning: This showed me that rollout timeouts are often a symptom, not the actual problem. The important part was reading the pod error carefully and understanding how `Deployment` and `ReplicaSet` work during a rolling update.
