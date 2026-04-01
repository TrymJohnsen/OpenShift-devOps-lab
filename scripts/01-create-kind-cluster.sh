#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${1:-interview-lab}"

echo "Creating kind cluster: ${CLUSTER_NAME}"

kind create cluster --name "${CLUSTER_NAME}"

echo
echo "Cluster info:"
kubectl cluster-info
kubectl get nodes -o wide