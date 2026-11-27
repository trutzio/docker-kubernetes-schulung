#!/usr/bin/env bash
# Lösung 19.2: den Service petclinic von Hand löschen, Flux legt ihn wieder an
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

(set -x; kubectl delete service petclinic)
zeige_url http://petclinic.localhost

schritt "Flux bemerkt die Abweichung beim nächsten Abgleich (hier sofort angestoßen)"
(set -x; flux reconcile helmrelease petclinic -n petclinic)
echo "... warte auf den Service"
for ((i = 0; i < 60; i++)); do
  kubectl get service petclinic > /dev/null 2>&1 && break
  sleep 2
done
(set -x; kubectl get service petclinic)
warte_auf_url http://petclinic.localhost
zeige_url http://petclinic.localhost
