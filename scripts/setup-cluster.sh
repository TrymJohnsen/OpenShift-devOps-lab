#!/usr/bin/env bash
# setup-cluster.sh – create a local k3d cluster for the lab
set -euo pipefail

CLUSTER_NAME="devops-lab"

echo "==> Creating k3d cluster: ${CLUSTER_NAME}"
k3d cluster create "${CLUSTER_NAME}" \
  --port "8080:80@loadbalancer" \
  --agents 1

echo "==> Verifying cluster nodes"
kubectl get nodes

echo "==> Cluster ready. Use 'kubectl config use-context k3d-${CLUSTER_NAME}' if needed."
