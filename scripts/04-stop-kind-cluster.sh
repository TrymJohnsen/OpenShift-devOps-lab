#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${1:-interview-lab}"

echo "Deleting entire kind cluster: ${CLUSTER_NAME}"
kind delete cluster --name "${CLUSTER_NAME}"

echo
echo "Kind cluster deleted."
echo "To create it again later, run:"
echo "  ./scripts/01-create-kind-cluster.sh ${CLUSTER_NAME}"
