#!/usr/bin/env bash
# Lösung 11.2: die Petclinic direkt über die IP des Pods aufrufen
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/k8s-uebungen"

set -x
kubectl apply -f petclinic-pod.yaml
kubectl wait --for=condition=Ready pod/petclinic --timeout=120s

# Spalte IP
kubectl get pods -o wide
set +x

ip="$(kubectl get pod petclinic -o jsonpath='{.status.podIP}')"
warte_auf_log petclinic 'Started PetClinicApplication'

# Vom Node aus (deinem Rechner) sind Pod-IPs direkt erreichbar, von außerhalb des Clusters nicht
zeige_url "http://$ip:8080"

(set -x; kubectl delete pod petclinic)
