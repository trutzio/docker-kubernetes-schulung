#!/usr/bin/env bash
# Lösung 15.2: in welchem Verzeichnis des Rechners liegen die Postgres-Dateien?
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
kubectl get pv

# Zeile Path: das Verzeichnis auf dem Node
kubectl describe pv | grep -E '^Name:|Path:'
set +x

pfad="$(kubectl describe pv | sed -n 's/^ *Path: *//p' | sed -n '1p')"
(set -x; sudo ls -la "$pfad")
