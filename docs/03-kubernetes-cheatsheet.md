# Kubernetes cheatsheet

## Core objects
| Object | Purpose |
|--------|---------|
| Namespace | Logical isolation boundary |
| Deployment | Desired state for a set of pods (replicas, rolling updates) |
| Pod | Smallest deployable unit (one or more containers) |
| Service | Stable network endpoint for pods (ClusterIP / NodePort / LoadBalancer) |
| Ingress | HTTP(S) routing rules into Services |
| ConfigMap | Non-sensitive configuration injected as env vars or files |
| Secret | Sensitive data (base64-encoded) injected as env vars or files |

## Essential kubectl commands
```bash
# Context / cluster
kubectl config get-contexts
kubectl config use-context <name>
kubectl config current-context

# Namespaces
kubectl get namespaces
kubectl create namespace interview-lab
kubectl config set-context --current --namespace=interview-lab

# Apply / delete manifests
kubectl apply -f manifests/
kubectl delete -f manifests/

# Pods
kubectl get pods -n interview-lab
kubectl get pods -A                       # all namespaces
kubectl describe pod <name> -n interview-lab
kubectl logs <pod> -n interview-lab
kubectl logs <pod> -n interview-lab -f              # follow
kubectl logs <pod> -n interview-lab -c <container>  # multi-container pod
kubectl exec -it <pod> -n interview-lab -- /bin/sh

# Deployments
kubectl get deployments -n interview-lab
kubectl rollout status deployment/<name> -n interview-lab
kubectl rollout history deployment/<name> -n interview-lab
kubectl rollout undo deployment/<name> -n interview-lab
kubectl scale deployment/<name> --replicas=3 -n interview-lab

# Services / Ingress
kubectl get svc -n interview-lab
kubectl get ingress -n interview-lab

# Events (very useful for debugging)
kubectl get events -n interview-lab --sort-by='.lastTimestamp' # | tail -n 5
```

## Health checks (probes)
```yaml
# In the container spec of a Deployment:
readinessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 10

livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 15
  periodSeconds: 20
  failureThreshold: 3
```
- **Readiness**: pod receives traffic only when ready.
- **Liveness**: pod is restarted when it fails.
- doesnt need port forwarding as httpget happens internally in the cluster

## Resource requests and limits
```yaml
resources:
  requests:
    cpu: "100m"       # 0.1 vCPU guaranteed
    memory: "128Mi"
  limits:
    cpu: "500m"       # 0.5 vCPU max
    memory: "256Mi"
```
- Requests = scheduling guarantee.
- Limits = hard cap (CPU throttled, memory OOM-killed).

## ConfigMap
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: lab
data:
  APP_ENV: "production"
  LOG_LEVEL: "info"
```
```yaml
# Inject all keys as env vars in a pod spec:
envFrom:
  - configMapRef:
      name: app-config
```

## Secret
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
  namespace: lab
type: Opaque
data:
  DATABASE_PASSWORD: cGFzc3dvcmQxMjM=   # base64-encoded
```
```yaml
# Inject as env var:
env:
  - name: DATABASE_PASSWORD
    valueFrom:
      secretKeyRef:
        name: app-secret
        key: DATABASE_PASSWORD
```

## RBAC (minimal example)
```yaml
# Role: allow reads in the 'lab' namespace
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: lab
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/log"]
    verbs: ["get", "list", "watch"]
---
# Bind the role to a user
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: lab
subjects:
  - kind: User
    name: developer
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

## Debugging workflow
1. `kubectl get pods` – check status (CrashLoopBackOff, Pending, OOMKilled …)
2. `kubectl describe pod <name>` – events section at the bottom
3. `kubectl logs <pod>` – application output
4. `kubectl exec -it <pod> -- /bin/sh` – shell into container
5. `kubectl get events --sort-by='.lastTimestamp'` – cluster-level events
