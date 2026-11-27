#!/usr/bin/env bash
# Walkthrough: External Secrets Operator und SecretStore
# Das Manifest liegt in secretstore.yaml.
# Voraussetzung: 01-openbao-installieren.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")"

set -x
helm install external-secrets oci://ghcr.io/external-secrets/charts/external-secrets \
  --namespace external-secrets --create-namespace --wait

# Der Token, mit dem sich der Operator bei OpenBao anmeldet
kubectl get secret openbao-token > /dev/null 2>&1 || kubectl create secret generic openbao-token --from-literal=token=root

cat secretstore.yaml
kubectl apply -f secretstore.yaml
kubectl wait secretstore/openbao --for=condition=Ready --timeout=120s
kubectl get secretstore
