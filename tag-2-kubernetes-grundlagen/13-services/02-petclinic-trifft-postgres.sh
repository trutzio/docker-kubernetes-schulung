#!/usr/bin/env bash
# Walkthrough: Journey-Moment: Petclinic trifft Postgres
# Die Manifeste liegen in petclinic-k8s/.
# Voraussetzung: 01-service.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-k8s"

set -x
cat petclinic-db-deployment.yaml petclinic-db-service.yaml

# Datenbank und ihr Service
kubectl apply -f petclinic-db-deployment.yaml -f petclinic-db-service.yaml
kubectl rollout status deployment/petclinic-db

# Die App bekommt ihre vier Variablen; Kubernetes tauscht die drei Pods per Rolling Update aus
cat petclinic-deployment.yaml
kubectl apply -f petclinic-deployment.yaml
kubectl rollout status deployment/petclinic

# Dreimal Petclinic, einmal Postgres
kubectl get pods
set +x

warte_auf_log deployment/petclinic 'Started PetClinicApplication'

schritt "Beweis, dass die Daten in Postgres liegen: die von der App angelegten Tabellen"
(set -x; kubectl exec deployment/petclinic-db -- psql -U petclinic -d petclinic -c '\dt')
