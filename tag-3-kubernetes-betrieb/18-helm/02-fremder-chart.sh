#!/usr/bin/env bash
# Walkthrough: Helm installieren und ein fremder Chart (Schritte 4 bis 9)
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
chart=oci://ghcr.io/stefanprodan/charts/podinfo

set -x
# Demo-Anwendung podinfo aus einer OCI-Registry installieren
helm install podinfo "$chart" --namespace demo --create-namespace
kubectl -n demo rollout status deployment/podinfo
kubectl get all -n demo

# Alle Stellschrauben des Charts (hier gekürzt)
helm show values "$chart" | sed -n '1,25p'

# Einen Wert ändern
helm upgrade podinfo "$chart" -n demo --set replicaCount=2
kubectl -n demo rollout status deployment/podinfo
kubectl get pods -n demo

helm history podinfo -n demo

# Aufräumen
helm uninstall podinfo -n demo
kubectl delete namespace demo
