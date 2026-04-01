#!/usr/bin/env bash
set -euo pipefail

echo "Applying Kubernetes manifests..."
kubectl apply -f manifests/00-namespace.yaml
kubectl apply -f manifests/

echo
echo "Wait for rollout..."
kubectl -n interview-lab rollout status deploy/nginx --timeout=120s

echo
echo "Resources:"
kubectl -n interview-lab get all
kubectl -n interview-lab get ingress