#!/usr/bin/env bash
# Lösung 11.1: Kommt ein gelöschter Pod von selbst wieder?
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
kubectl delete pod petclinic
sleep 5

# Der Pod ist weg und bleibt weg: niemand passt auf ihn auf
kubectl get pods
