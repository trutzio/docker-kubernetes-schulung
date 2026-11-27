#!/usr/bin/env bash
# Walkthrough: Compose installieren und der erste Service
# Die Datei liegt in compose-demo/compose.yaml, das Projekt heißt nach dem Verzeichnis: compose-demo.
set -euxo pipefail
cd "$(dirname "$0")/compose-demo"

# Installation prüfen
docker compose version

cat compose.yaml

# Alle in der Datei definierten Services starten
docker compose up -d

# Container compose-demo-database-1, Volume compose-demo_postgres_volume, Netzwerk compose-demo_default
docker container ls
docker volume ls
docker network ls

sleep 3
docker compose logs database
