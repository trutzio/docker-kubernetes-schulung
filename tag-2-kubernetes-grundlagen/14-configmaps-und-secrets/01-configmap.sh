#!/usr/bin/env bash
# Walkthrough: Einstellungen in die ConfigMap
# Das Manifest liegt in petclinic-k8s/petclinic-config.yaml.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-k8s"

set -x
cat petclinic-config.yaml
kubectl apply -f petclinic-config.yaml
kubectl get configmap petclinic-config -o yaml
