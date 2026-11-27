#!/usr/bin/env bash
# Walkthrough: Journey-Moment: der komplette Petclinic-Stack
# Voraussetzung: petclinic:local aus dem Image-Kapitel, Port 8080 frei.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-stack"

set -x
cat compose.yaml

# Der ganze Stack mit einem Befehl
docker compose up -d
docker compose ps
set +x

warte_auf_log petclinic-stack-petclinic-1 'Started PetClinicApplication'
zeige_url "http://localhost:8080"
