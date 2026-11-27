#!/usr/bin/env bash
# Lösung 21.1: das Secret demo-secret löschen, der Operator legt es wieder an
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

(set -x; kubectl delete secret demo-secret)
echo "... warte auf das neue Secret (spätestens nach 15 Sekunden)"
for ((i = 0; i < 30; i++)); do
  kubectl get secret demo-secret > /dev/null 2>&1 && break
  sleep 2
done
(set -x; kubectl get secret demo-secret)
