#!/usr/bin/env bash
# Lösung 15.1: ein Owner überlebt das Löschen des Datenbank-Pods
# Vorher im Browser einen Owner anlegen; das Skript zeigt die neuesten Owner vorher und nachher.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

zeige_owner() {
  (set -x; kubectl exec petclinic-db-0 -- psql -U petclinic -d petclinic \
    -c 'select id, first_name, last_name from owners order by id desc limit 5;')
}

schritt "Vorher"
zeige_owner

schritt "Pod löschen: das StatefulSet startet einen neuen mit demselben Namen und demselben PVC"
(set -x; kubectl delete pod petclinic-db-0; kubectl rollout status statefulset/petclinic-db; kubectl get pods)
sleep 5

schritt "Nachher: die Daten sind erhalten"
zeige_owner
