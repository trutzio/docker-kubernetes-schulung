#!/usr/bin/env bash
# Walkthrough: Das Passwort ins Secret
# Das Manifest liegt in petclinic-k8s/petclinic-secret.yaml.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-k8s"

set -x
# Base64-Schreibweise des Passworts (-n: kein Zeilenumbruch)
echo -n 'petclinic' | base64

cat petclinic-secret.yaml
kubectl apply -f petclinic-secret.yaml

# describe zeigt nur Schlüssel und Länge, nicht den Wert
kubectl describe secret petclinic-secret

# Trotzdem im Klartext lesbar: Base64 schützt nichts
kubectl get secret petclinic-secret -o jsonpath='{.data.password}' | base64 -d
set +x
echo
