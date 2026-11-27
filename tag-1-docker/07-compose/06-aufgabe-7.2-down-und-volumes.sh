#!/usr/bin/env bash
# Lösung 7.2: Überlebt ein Owner "docker compose down"? Und was ändert "down -v"?
# Vorher im Browser unter http://localhost:8080 einen Owner anlegen.
# ACHTUNG: der zweite Teil löscht mit "down -v" absichtlich das Volume des Stacks.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-stack"

zeige_owner() {
  (set -x; docker compose exec -T petclinic-db psql -U petclinic -d petclinic < /dev/null \
    -c 'select count(*) as anzahl_owner, max(last_name) as letzter_name from owners;')
}
hoch() {
  (set -x; docker compose up -d)
  warte_auf_log petclinic-stack-petclinic-1 'Started PetClinicApplication'
}

schritt "Stand vorher"
zeige_owner

schritt "down und wieder up: der Owner ist noch da, down entfernt keine benannten Volumes"
(set -x; docker compose down)
hoch
zeige_owner

read -r -p "Jetzt 'down -v' ausprobieren? Das löscht die Daten des Stacks. [j/N] " antwort
if [[ "$antwort" != [jJ] ]]; then
  exit 0
fi

schritt "down -v und wieder up: die Datenbank ist frisch initialisiert, eigene Owner sind weg"
(set -x; docker compose down -v)
hoch
zeige_owner
