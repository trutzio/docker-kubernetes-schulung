#!/usr/bin/env bash
# Walkthrough: Ein Secret, das dem Speicher folgt
# Das Manifest liegt in demo-externalsecret.yaml.
# Voraussetzung: 02-eso-und-secretstore.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")"

lies() { kubectl get secret demo-secret -o jsonpath='{.data.gruss}' | base64 -d; echo; }

set -x
kubectl -n openbao exec openbao-0 -- bao kv put secret/demo gruss=hallo
cat demo-externalsecret.yaml
kubectl apply -f demo-externalsecret.yaml
kubectl wait externalsecret/demo --for=condition=Ready --timeout=120s
kubectl get externalsecret
set +x

schritt "Das Secret ist da, obwohl es niemand angelegt hat"
lies

schritt "Rotation: den Wert im Speicher ändern, das Secret im Cluster folgt nach spätestens 15 Sekunden"
(set -x; kubectl -n openbao exec openbao-0 -- bao kv put secret/demo gruss=servus)
sleep 25
lies
