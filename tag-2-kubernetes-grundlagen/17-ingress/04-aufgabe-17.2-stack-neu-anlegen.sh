#!/usr/bin/env bash
# Lösung 17.2: der Abschluss von Tag 2. Den ganzen Stack löschen und wieder anlegen, die Daten überleben.
# Die sieben Manifeste liegen in petclinic-k8s/.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")"

zaehle() {
  (set -x; kubectl exec petclinic-db-0 -- psql -U petclinic -d petclinic -c 'select count(*) from owners;')
}

(set -x; ls petclinic-k8s/)
schritt "Vorher"
zaehle

schritt "Alles löschen: der Namespace ist leer, nur der PVC bleibt"
(set -x; kubectl delete -f petclinic-k8s/; kubectl wait --for=delete pod -l 'app in (petclinic, petclinic-db)' --timeout=120s; kubectl get all; kubectl get pvc)

schritt "Alles wieder anlegen, mit einem Befehl"
(set -x; kubectl apply -f petclinic-k8s/; kubectl rollout status statefulset/petclinic-db; kubectl rollout status deployment/petclinic)
warte_auf_url http://petclinic.localhost

schritt "Nachher: der neue Datenbank-Pod hat den alten PVC wiedergefunden"
zaehle
(set -x; kubectl get all,ingress,pvc)
zeige_url http://petclinic.localhost
