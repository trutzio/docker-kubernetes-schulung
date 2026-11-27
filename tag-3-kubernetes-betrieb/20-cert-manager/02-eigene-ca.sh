#!/usr/bin/env bash
# Walkthrough: Eine eigene Zertifizierungsstelle
# Das Manifest liegt in kurs-ca.yaml.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")"

set -x
cat kurs-ca.yaml
kubectl apply -f kurs-ca.yaml
kubectl wait clusterissuer/kurs-ca --for=condition=Ready --timeout=120s

kubectl get clusterissuers
kubectl get certificate -n cert-manager
