#!/usr/bin/env bash
# Lösung 6.1 (Teil 1): Petclinic-Stack mit Volume und dem eigenen Image petclinic:local
# Voraussetzung: petclinic:local aus dem Image-Kapitel (05-image/06-petclinic-image-bauen.sh)
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

docker network inspect petclinic-net > /dev/null 2>&1 || (set -x; docker network create petclinic-net)
docker volume inspect petclinic-data > /dev/null 2>&1 || (set -x; docker volume create petclinic-data)

set -x
# Datenbank mit Volume
docker container run -d --rm --name petclinic-db --network petclinic-net \
  -v petclinic-data:/var/lib/postgresql/data \
  -e POSTGRES_USER=petclinic -e POSTGRES_PASSWORD=petclinic -e POSTGRES_DB=petclinic postgres:17
set +x
warte_auf_postgres petclinic-db petclinic

set -x
# Derselbe Befehl wie im Netzwerke-Kapitel, nur mit dem eigenen Image
docker container run -d --rm --name petclinic --network petclinic-net -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=postgres \
  -e POSTGRES_URL=jdbc:postgresql://petclinic-db/petclinic \
  -e POSTGRES_USER=petclinic -e POSTGRES_PASS=petclinic \
  petclinic:local
set +x

warte_auf_log petclinic 'Started PetClinicApplication'
zeige_url "http://localhost:8080"

echo
echo "Jetzt im Browser einen Owner anlegen (Find Owners, Add Owner)."
echo "Danach: ./04-aufgabe-6.1-datenbank-neu-starten.sh"
