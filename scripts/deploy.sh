#!/usr/bin/env bash
# deploy.sh – apply all manifests to the local cluster
set -euo pipefail

NAMESPACE="lab"
MANIFESTS_DIR="$(dirname "$0")/../manifests"

echo "==> Applying namespace"
kubectl apply -f "${MANIFESTS_DIR}/namespace.yaml"

echo "==> Applying config"
kubectl apply -f "${MANIFESTS_DIR}/configmap.yaml"
kubectl apply -f "${MANIFESTS_DIR}/secret.yaml"

echo "==> Applying workload"
kubectl apply -f "${MANIFESTS_DIR}/deployment.yaml"
kubectl apply -f "${MANIFESTS_DIR}/service.yaml"
kubectl apply -f "${MANIFESTS_DIR}/ingress.yaml"

echo "==> Applying RBAC"
kubectl apply -f "${MANIFESTS_DIR}/rbac.yaml"

echo "==> Waiting for rollout"
kubectl rollout status deployment/myapp -n "${NAMESPACE}" --timeout=120s

echo "==> Overview"
kubectl get pods,svc,ingress -n "${NAMESPACE}"
