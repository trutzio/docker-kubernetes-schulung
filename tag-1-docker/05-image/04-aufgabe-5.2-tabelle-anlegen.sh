#!/usr/bin/env bash
# Lösung 5.2: per psql im Container testdb-server eine Tabelle anlegen
# Voraussetzung: 03-eigenes-image.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

warte_auf_postgres testdb-server testuser

set -x
# User und Datenbank kommen aus den ENV-Befehlen unserer Dockerfile
docker container exec testdb-server psql -U testuser -d testdb -c 'CREATE TABLE test(name varchar(256));'
docker container exec testdb-server psql -U testuser -d testdb -c '\dt'
set +x

stoppe testdb-server
