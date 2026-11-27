#!/usr/bin/env bash
# Walkthrough: Die Deployments umstellen
# Die Manifeste liegen in petclinic-k8s/.
# Voraussetzung: 01-configmap.sh und 02-secret.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-k8s"

set -x
cat petclinic-deployment.yaml petclinic-db-deployment.yaml

kubectl apply -f petclinic-db-deployment.yaml -f petclinic-deployment.yaml
kubectl rollout status deployment/petclinic-db
kubectl rollout status deployment/petclinic

# Alle Werte sind angekommen, obwohl keiner mehr im Deployment steht
kubectl exec deployment/petclinic -- env | grep -E 'POSTGRES|SPRING'
set +x

# Der Datenbank-Pod wurde neu gestartet, die Datenbank ist also frisch (siehe Lösung 13.3):
# die App-Pods neu starten, damit sie ihre Tabellen wieder anlegen
if ! warte_auf_url "http://localhost:8080/owners?lastName=" 40; then
  (set -x; kubectl rollout restart deployment/petclinic; kubectl rollout status deployment/petclinic)
  warte_auf_url "http://localhost:8080/owners?lastName="
fi
zeige_url http://localhost:8080
