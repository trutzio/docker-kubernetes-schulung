#!/usr/bin/env bash
# Lösung 21.3: das Demo-Beispiel aufräumen
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
kubectl delete externalsecret demo
sleep 5

# Das Secret gehörte dem ExternalSecret und ist mit ihm verschwunden
kubectl get secret demo-secret || true

kubectl -n openbao exec openbao-0 -- bao kv delete secret/demo
