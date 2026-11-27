#!/usr/bin/env bash
# Walkthrough: Volumes erzeugen und einbinden
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

starte() {
  (set -x; docker container run -d --rm --name pgtest -e POSTGRES_PASSWORD=secret \
    -v data:/var/lib/postgresql/data postgres:17)
  warte_auf_postgres pgtest
}

set -x
docker volume create data
docker volume ls
set +x

schritt "Postgres mit dem Volume als Datenverzeichnis starten und Daten anlegen"
starte
(set -x; docker container exec pgtest psql -U postgres -c "CREATE TABLE kunden(name varchar(64)); INSERT INTO kunden VALUES ('trutz');")

schritt "Container stoppen (und damit löschen), dann denselben run-Befehl erneut"
stoppe pgtest
starte

schritt "Die Tabelle ist noch da: ein frischer Container mit den alten Daten"
set -x
docker container exec pgtest psql -U postgres -c '\dt'
docker container exec pgtest psql -U postgres -c 'select * from kunden;'

# Metadaten des Volumes, darunter der Mountpoint auf dem Host
# (Linux-Host: sudo ls -la [mountpoint] zeigt die Postgres-Dateien; bei Docker Desktop liegt der Pfad in der Linux-VM)
docker volume inspect data
set +x

schritt "Aufräumen"
stoppe pgtest
(set -x; docker volume rm data)
