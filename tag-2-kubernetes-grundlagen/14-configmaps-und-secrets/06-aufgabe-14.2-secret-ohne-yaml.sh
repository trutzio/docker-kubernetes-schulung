#!/usr/bin/env bash
# Lösung 14.2: ein Secret ohne YAML-Datei anlegen, auslesen und löschen
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
# Die Base64-Kodierung übernimmt kubectl
kubectl create secret generic test-secret --from-literal=password=geheim

# Der kodierte Wert
kubectl get secret test-secret -o jsonpath='{.data.password}'
set +x
echo
set -x

# Im Klartext
kubectl get secret test-secret -o jsonpath='{.data.password}' | base64 -d
set +x
echo
(set -x; kubectl delete secret test-secret)
