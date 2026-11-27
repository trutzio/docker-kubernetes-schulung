#!/usr/bin/env bash
# Lösung 13.2: einen Petclinic-Pod löschen, der Service verteilt weiter
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

pod="$(ein_pod app=petclinic)"

schritt "Vorher: drei Adressen hinter dem Service petclinic"
(set -x; kubectl get endpointslices)

(set -x; kubectl delete pod "$pod" --wait=false)
zeige_url http://localhost:8080

(set -x; kubectl rollout status deployment/petclinic)

schritt "Nachher: wieder drei Adressen, eine davon neu"
(set -x; kubectl get endpointslices)
zeige_url http://localhost:8080
