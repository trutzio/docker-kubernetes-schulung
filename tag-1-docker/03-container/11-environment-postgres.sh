#!/usr/bin/env bash
# Walkthrough: Container konfigurieren mit Environment-Variablen
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
# -e setzt Environment-Variablen, --name vergibt einen Namen, --rm entfernt den Container beim Stoppen
docker container run -d -p 5432:5432 --rm --name pgserver \
  -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=secret -e POSTGRES_DB=testdb postgres:17

docker container ls

# Die komplette Konfiguration als JSON (hier gekürzt auf die ersten Zeilen)
docker container inspect pgserver | head -n 20

# Gezielt die Environment-Variablen herausfiltern
docker container inspect --format '{{json .Config.Env}}' pgserver
set +x

warte_auf_postgres pgserver

set -x
# psql INNERHALB des Server-Containers: listet die Datenbanken, testdb ist dabei
# (interaktiv: docker container exec -i -t pgserver psql -U postgres, beenden mit \q)
docker container exec pgserver psql -U postgres -c '\l'
set +x

# Stoppen; dank --rm ist der Container danach auch entfernt
stoppe pgserver
docker container ls -a
