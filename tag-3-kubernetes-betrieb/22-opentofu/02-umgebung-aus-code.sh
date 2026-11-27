#!/usr/bin/env bash
# Walkthrough: Eine Umgebung aus Code
# Die Datei liegt in tofu-demo/main.tf. Das Skript beantwortet die Rückfrage von tofu apply selbst (-auto-approve).
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/tofu-demo"

set -x
cat main.tf

# Provider herunterladen
tofu init

# Was würde passieren? Noch ist nichts geändert
tofu plan

tofu apply -auto-approve
kubectl -n tofu-demo rollout status deployment/podinfo
kubectl get pods,ingress,configmap -n tofu-demo
set +x

warte_auf_url http://podinfo.localhost
zeige_url http://podinfo.localhost
command -v curl > /dev/null && curl -s http://podinfo.localhost | grep message

(set -x; tofu state list)
