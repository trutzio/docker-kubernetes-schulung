#!/usr/bin/env bash
# Walkthrough: Benutzerdefiniertes Netzwerk mit DNS
# Voraussetzung: 01-weg-ueber-ip.sh (Container "pgserver" läuft)
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
docker network create test
docker network ls

# Den laufenden Server nachträglich in das Netzwerk hängen
docker network connect test pgserver

# Jetzt zwei Netzwerke: bridge und test
docker container inspect --format '{{json .NetworkSettings.Networks}}' pgserver
set +x

schritt "Schlägt immer noch fehl: der Client hängt selbst nicht im Netzwerk test"
set -x
docker container run --rm -e PGPASSWORD=secret postgres:17 \
  psql -h pgserver -U postgres -c '\conninfo' || true
set +x

schritt "Mit --network test steht die Verbindung: Namensauflösung über den Containernamen"
set -x
docker container run --rm --network test -e PGPASSWORD=secret postgres:17 \
  psql -h pgserver -U postgres -c '\conninfo'
set +x

# Server stoppen (dank --rm entfernt), das Netzwerk test bleibt bis Aufgabe 4.4 bestehen
stoppe pgserver
