#!/usr/bin/env bash
# Walkthrough: Das Problem: Daten sterben mit dem Container
# psql läuft hier nicht interaktiv, die Befehle kommen über -c.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

starte() {
  (set -x; docker container run -d --rm --name pgtest -e POSTGRES_PASSWORD=secret postgres:17)
  warte_auf_postgres pgtest
}

schritt "Postgres ohne eigenes Volume starten und Daten anlegen"
starte
set -x
docker container exec pgtest psql -U postgres -c "CREATE TABLE kunden(name varchar(64)); INSERT INTO kunden VALUES ('trutz');"
docker container exec pgtest psql -U postgres -c '\dt'
set +x

schritt "Stoppen: dank --rm ist der Container damit gelöscht"
stoppe pgtest

schritt "Derselbe run-Befehl noch einmal: die Tabelle ist weg"
starte
(set -x; docker container exec pgtest psql -U postgres -c '\dt')

stoppe pgtest
