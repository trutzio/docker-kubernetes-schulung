#!/usr/bin/env bash
# Lösung 21.2: steht das Passwort noch im Repository?
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
pruefe_gitops_repo
cd "$GITOPS_REPO"

schritt "Im aktuellen Stand: nichts mehr"
(set -x; git grep -n 'password: petclinic') || echo "(nichts gefunden)"

schritt "In der Historie: das Passwort ist weiterhin lesbar"
(set -x; git log -p -- petclinic-chart/values.yaml | grep -n 'password: petclinic')
