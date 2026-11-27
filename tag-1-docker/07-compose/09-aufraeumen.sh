#!/usr/bin/env bash
# Aufräumen nach dem Entwickler-Workflow: Datenbank-Service des Petclinic-Projekts herunterfahren
# und den Compose-Stack wieder starten (Zielzustand von Tag 1).
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
hier="$(cd "$(dirname "$0")" && pwd)"

if [[ -d "$hier/../spring-petclinic" ]]; then
  (cd "$hier/../spring-petclinic" && set -x && docker compose down)
fi

cd "$hier/petclinic-stack"
(set -x; docker compose up -d)
warte_auf_log petclinic-stack-petclinic-1 'Started PetClinicApplication'
zeige_url "http://localhost:8080"

echo
echo "Stack stoppen: (cd petclinic-stack && docker compose down)"
