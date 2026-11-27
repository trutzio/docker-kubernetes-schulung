#!/usr/bin/env bash
# Walkthrough: Mehrere Container
# Statt die compose.yaml zu erweitern, nimmt das Skript die fertige Datei compose.pgadmin.yaml.
# Voraussetzung: 01-erster-service.sh; Port 8080 muss frei sein (siehe 06-volumes/09-aufraeumen.sh).
set -euxo pipefail
cd "$(dirname "$0")/compose-demo"

cat compose.pgadmin.yaml

# Alle Services herunterfahren; die Volumes bleiben bestehen
docker compose down
docker volume ls

# Beide Services hochfahren: dbadmin startet erst nach database (depends_on)
docker compose -f compose.pgadmin.yaml up -d
docker compose -f compose.pgadmin.yaml ps

set +x
echo
echo "pgAdmin braucht etwa eine halbe Minute zum Starten, dann im Browser: http://localhost:8080"
echo "Anmeldung: postgres@test.de / password (Aufgabe 7.1: Server mit Host 'database' anlegen)"
