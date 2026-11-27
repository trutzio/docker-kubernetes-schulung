#!/usr/bin/env bash
# Lösung 6.1 (Teil 2): Datenbank-Container löschen, neu starten, der Owner hat überlebt
# Voraussetzung: 03-aufgabe-6.1-petclinic-mit-volume.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

zeige_owner() {
  (set -x; docker container exec petclinic-db psql -U petclinic -d petclinic \
    -c 'select id, first_name, last_name from owners order by id desc limit 5;')
}

schritt "Die neuesten Owner vor dem Container-Tod"
zeige_owner

schritt "Datenbank-Container stoppen: dank --rm ist er gelöscht, die App zeigt jetzt Fehler"
stoppe petclinic-db

schritt "Denselben run-Befehl erneut ausführen"
set -x
docker container run -d --rm --name petclinic-db --network petclinic-net \
  -v petclinic-data:/var/lib/postgresql/data \
  -e POSTGRES_USER=petclinic -e POSTGRES_PASSWORD=petclinic -e POSTGRES_DB=petclinic postgres:17
set +x
warte_auf_postgres petclinic-db petclinic

schritt "Die Owner sind noch da: die Daten lagen im Volume, nicht im Container"
zeige_owner
zeige_url "http://localhost:8080/owners?lastName="
