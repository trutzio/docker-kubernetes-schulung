#!/usr/bin/env bash
# Walkthrough: cert-manager installieren
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
helm install cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --namespace cert-manager --create-namespace --set crds.enabled=true --wait

kubectl get pods -n cert-manager

# Die neuen Objektarten
kubectl api-resources | grep cert-manager
