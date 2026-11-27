#!/usr/bin/env bash
# Lösung 12.2: ein Update auf ein Image, das es nicht gibt
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

(set -x; kubectl set image deployment/petclinic petclinic=petclinic:gibtsnicht)

schritt "Der neue Pod kommt nicht hoch (ErrImagePull, ImagePullBackOff), die drei alten laufen weiter"
sleep 25
(set -x; kubectl get pods)

schritt "Das Rolling Update bleibt hängen"
(set -x; kubectl rollout status deployment/petclinic --timeout=10s) || true

schritt "Zurückdrehen: der fehlerhafte Pod verschwindet"
(set -x; kubectl rollout undo deployment/petclinic; kubectl rollout status deployment/petclinic; kubectl get pods)
