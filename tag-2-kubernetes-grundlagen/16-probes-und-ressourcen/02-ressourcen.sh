#!/usr/bin/env bash
# Walkthrough: Ressourcen festlegen
# Das Manifest liegt in petclinic-k8s/petclinic-deployment.yaml (mit Probes und resources).
# Voraussetzung: 01-probes.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-k8s"

set -x
# Aktueller Verbrauch
kubectl top pods || true

cat petclinic-deployment.yaml
kubectl apply -f petclinic-deployment.yaml
kubectl rollout status deployment/petclinic
set +x

pod="$(ein_pod app=petclinic)"
set -x
# Limits und Requests im Pod
kubectl describe pod "$pod" | grep -A 6 -E '^ +Limits:'

# Was der Node schon vergeben hat: die Summe aller Requests
kubectl describe node | grep -A 8 'Allocated resources'
