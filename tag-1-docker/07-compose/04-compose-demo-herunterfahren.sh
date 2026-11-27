#!/usr/bin/env bash
# Aufräumen vor dem Petclinic-Stack (Journey-Moment, Schritt 1): pgAdmin belegt Port 8080,
# die Demo-Datenbank Port 5432 (den braucht später der Entwickler-Workflow).
# Mit -v verschwinden auch die beiden Demo-Volumes.
set -euxo pipefail
cd "$(dirname "$0")/compose-demo"

docker compose -f compose.profil.yaml --profile=admin down -v
docker compose ls
