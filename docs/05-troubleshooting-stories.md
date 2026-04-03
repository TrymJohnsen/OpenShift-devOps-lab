# Troubleshooting stories (for interview)

## Story 1: Pod is running, but the app does not respond
- Symptom: The pod showed as `Running`, but the application was not reachable from outside the pod.
- What I checked (commands): I started with `kubectl logs <pod-name> -n interview-lab` to look for crashes, exceptions, or obvious port/configuration mistakes. Then I used `kubectl describe pod <pod-name> -n interview-lab` to inspect pod events, image pull issues, restart history, and whether the pod was stuck in a crash loop.
- Root cause: One common cause in this kind of issue is a port mismatch. For example, the container listens on `8000`, but the `Service` is configured incorrectly or points to the wrong target port. Another common cause is that the `Service` selector does not actually match the pod labels, so traffic never reaches the app.
- Fix: I verified the container port in the `Deployment`, the `port` and `targetPort` in the `Service`, and whether the service had live endpoints. I also tested the application directly with `kubectl port-forward pod/<pod-name> 8081:8000` and `curl http://localhost:8081`. If that direct test worked, I knew the app itself was fine and the problem was in the `Service` layer, not the container.
- What I learned: A pod being `Running` does not mean the application path is correct end to end. I learned to separate the problem into layers: app process, pod, service, and routing.

### Commands I would use in this scenario
```bash
kubectl logs <pod-name> -n interview-lab
kubectl describe pod <pod-name> -n interview-lab
kubectl port-forward pod/<pod-name> -n interview-lab 8081:8000
curl http://localhost:8081
kubectl get endpoints <service-name> -n interview-lab
```

### Fast diagnosis flow
1. Check logs for crashes, exceptions, or the app listening on the wrong port.
2. Check `describe` for events, image pull errors, or restart loops.
3. Compare container port and service `targetPort` to catch mismatches.
4. Port-forward directly to the pod and test with `curl`.
5. Check service endpoints to confirm whether the service is actually finding pods.

### What the results tell me
- If `kubectl port-forward` to the pod works, the app is running and reachable inside Kubernetes.
- If the pod works directly but the service does not, the issue is usually the `Service` config, wrong `targetPort`, wrong selector, or missing endpoints.
- If `kubectl get endpoints <service-name> -n interview-lab` returns no endpoints, the service is not matching any pods. That usually means label mismatch or selector mismatch.


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
