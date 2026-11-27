#!/usr/bin/env bash
# Walkthrough: Journey-Moment: der ganze Stack mit einem Befehl
# Die sechs Manifeste liegen in petclinic-k8s/.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")"

set -x
ls petclinic-k8s/

# Das Gegenstück zu docker compose down
kubectl delete -f petclinic-k8s/ --ignore-not-found
kubectl wait --for=delete pod -l 'app in (petclinic, petclinic-db)' --timeout=120s
kubectl get all

# Das Gegenstück zu docker compose up -d
kubectl apply -f petclinic-k8s/
kubectl rollout status deployment/petclinic-db
kubectl rollout status deployment/petclinic
set +x

warte_auf_url "http://localhost:8080/owners?lastName="

# Zwei Deployments, zwei ReplicaSets, vier Pods, zwei Services
(set -x; kubectl get all)
zeige_url http://localhost:8080
