#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-interview-lab}"
NAMESPACE="${NAMESPACE:-interview-lab}"
IMAGE_NAME="${IMAGE_NAME:-myapp}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
IMAGE_REF="${IMAGE_NAME}:${IMAGE_TAG}"

echo "Building backend image: ${IMAGE_REF}"
docker build -t "${IMAGE_REF}" app/

echo
echo "Loading image into kind cluster: ${CLUSTER_NAME}"
kind load docker-image "${IMAGE_REF}" --name "${CLUSTER_NAME}"

echo
echo "Applying Kubernetes manifests..."
kubectl apply -f manifests/00-namespace.yaml
kubectl apply -f manifests/

echo
echo "Waiting for rollouts..."
kubectl -n "${NAMESPACE}" rollout status deploy/backend --timeout=240s
kubectl -n "${NAMESPACE}" rollout status deploy/nginx --timeout=240s

echo
echo "Resources:"
kubectl -n "${NAMESPACE}" get all
kubectl -n "${NAMESPACE}" get ingress
