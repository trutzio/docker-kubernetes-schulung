#!/usr/bin/env bash
# Lösung 15.3: StatefulSet löschen und neu anlegen, der PVC und die Daten bleiben
# (den PVC selbst löscht das Skript nicht: das wäre das Gegenstück zu "docker compose down -v")
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-k8s"

zaehle() {
  (set -x; kubectl exec petclinic-db-0 -- psql -U petclinic -d petclinic -c 'select count(*) from owners;')
}

schritt "Vorher"
zaehle

schritt "StatefulSet löschen: der PVC bleibt bestehen"
(set -x; kubectl delete statefulset petclinic-db; kubectl wait --for=delete pod/petclinic-db-0 --timeout=90s; kubectl get pvc)

schritt "Neu anlegen: der neue Pod findet den vorhandenen PVC"
(set -x; kubectl apply -f petclinic-db-statefulset.yaml; kubectl rollout status statefulset/petclinic-db)
sleep 5
zaehle
