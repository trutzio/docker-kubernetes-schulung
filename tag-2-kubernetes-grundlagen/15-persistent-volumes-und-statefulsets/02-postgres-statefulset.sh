#!/usr/bin/env bash
# Walkthrough: Journey-Moment: Postgres zieht ins StatefulSet
# Das Manifest liegt in petclinic-k8s/petclinic-db-statefulset.yaml.
# Voraussetzung: der Stack aus dem Kapitel ConfigMaps und Secrets läuft.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-k8s"

set -x
cat petclinic-db-statefulset.yaml

# Das alte Deployment der Datenbank entfernen, das StatefulSet ersetzt es
kubectl delete deployment petclinic-db --ignore-not-found
kubectl apply -f petclinic-db-statefulset.yaml
kubectl rollout status statefulset/petclinic-db

# Der Pod heißt petclinic-db-0, aus der Vorlage ist der PVC data-petclinic-db-0 entstanden
kubectl get statefulsets,pods,pvc

# App-Pods neu starten, damit sie ihre Tabellen in der frischen Datenbank anlegen
kubectl rollout restart deployment/petclinic
set +x
warte_auf_petclinic
warte_auf_url "http://localhost:8080/owners?lastName="
zeige_url http://localhost:8080
