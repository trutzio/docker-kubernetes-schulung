#!/usr/bin/env bash
# Walkthrough: OpenBao installieren
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
helm repo add openbao https://openbao.github.io/openbao-helm

# Entwicklungsmodus: sofort benutzbar, fester Token "root", Daten nur im Arbeitsspeicher
helm install openbao openbao/openbao --namespace openbao --create-namespace \
  --set server.dev.enabled=true --set injector.enabled=false
set +x

echo "... warte auf den Pod openbao-0"
for ((i = 0; i < 60; i++)); do
  kubectl -n openbao get pod openbao-0 > /dev/null 2>&1 && break
  sleep 2
done

set -x
kubectl -n openbao wait --for=condition=Ready pod/openbao-0 --timeout=180s
kubectl -n openbao exec openbao-0 -- bao status

# Das Datenbank-Passwort der Petclinic ablegen
kubectl -n openbao exec openbao-0 -- bao kv put secret/petclinic password=petclinic
kubectl -n openbao exec openbao-0 -- bao kv get secret/petclinic
