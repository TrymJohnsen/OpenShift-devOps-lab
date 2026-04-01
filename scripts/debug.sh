#!/usr/bin/env bash
# debug.sh – common debugging commands for the lab namespace
set -euo pipefail

NAMESPACE="${1:-lab}"

echo "=== Pods ==="
kubectl get pods -n "${NAMESPACE}" -o wide

echo ""
echo "=== Recent events (last 20) ==="
kubectl get events -n "${NAMESPACE}" \
  --sort-by='.lastTimestamp' \
  --field-selector=type=Warning 2>/dev/null || \
kubectl get events -n "${NAMESPACE}" --sort-by='.lastTimestamp'

echo ""
echo "=== Services ==="
kubectl get svc -n "${NAMESPACE}"

echo ""
echo "=== Ingress ==="
kubectl get ingress -n "${NAMESPACE}"

echo ""
echo "Tip: to follow logs for a pod run:"
echo "  kubectl logs -f <pod-name> -n ${NAMESPACE}"
echo ""
echo "Tip: to shell into a pod run:"
echo "  kubectl exec -it <pod-name> -n ${NAMESPACE} -- /bin/sh"
