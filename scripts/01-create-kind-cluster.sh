# shebang blir tolket av os, ikke bash selv. denne sier at det er bash som skal brukes til å kjøre skriptet.
# env bash finner riktig bash på systemet
#!/usr/bin/env bash

# -e stopper hvis en kommando feiler
# -u feiler hvis du bruker en variabel som ikke er satt
# -o pipefail gjør at skriptet feiler hvis en kommando i en pipe feiler
set -euo pipefail 

# bruker første arg jeg gir scriptet, eller fallback interview-lab hvis ingen arg er gitt
CLUSTER_NAME="${1:-interview-lab}"
K8S_VERSION="v1.31.0"
KIND_NODE_IMAGE="kindest/node:${K8S_VERSION}"

# printer til terminal
echo "Creating kind cluster: ${CLUSTER_NAME}"
echo "Using Kubernetes version: ${K8S_VERSION}"

# selve lokale k8s cluster opprettelsen
kind create cluster --name "${CLUSTER_NAME}" --image "${KIND_NODE_IMAGE}"

# spacing, cluster info, node info
echo
echo "Cluster info:"
kubectl cluster-info
kubectl get nodes -o wide
