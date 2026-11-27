#!/usr/bin/env bash
# Lösung 16.1: Readiness Probe mit pg_isready für die Datenbank
# Das Manifest liegt in petclinic-k8s/petclinic-db-statefulset.yaml.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-k8s"

set -x
cat petclinic-db-statefulset.yaml

# Das StatefulSet ersetzt den Pod petclinic-db-0, die Daten bleiben dank PVC erhalten
kubectl apply -f petclinic-db-statefulset.yaml
kubectl rollout status statefulset/petclinic-db

kubectl describe pod petclinic-db-0 | grep Readiness
kubectl get pods
