#!/usr/bin/env bash
# Walkthrough: Petclinic als Deployment
# Das Manifest liegt in petclinic-k8s/petclinic-deployment.yaml.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-k8s"

set -x
cat petclinic-deployment.yaml
kubectl apply -f petclinic-deployment.yaml

# Warten, bis alle drei Pods laufen
kubectl rollout status deployment/petclinic

# Die ganze Kette: ein Deployment, ein ReplicaSet, drei Pods
kubectl get deployments,replicasets,pods
set +x

mit_port_forward deployment/petclinic 8080:8080
