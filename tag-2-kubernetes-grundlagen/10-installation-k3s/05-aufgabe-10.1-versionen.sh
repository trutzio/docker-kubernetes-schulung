#!/usr/bin/env bash
# Lösung 10.1: Kubernetes-Version des Clusters und containerd-Version des Nodes
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
# Server Version ist die Kubernetes-Version des Clusters
kubectl version

# Spalte CONTAINER-RUNTIME
kubectl get nodes -o wide

# Gezielt nur dieses eine Feld
kubectl get node -o jsonpath='{.items[0].status.nodeInfo.containerRuntimeVersion}'
set +x
echo
