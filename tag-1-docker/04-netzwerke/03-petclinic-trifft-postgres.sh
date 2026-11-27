#!/usr/bin/env bash
# Walkthrough: Petclinic trifft Postgres
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
docker network create petclinic-net

# Datenbank: kein -p, nur die App soll mit ihr reden
docker container run -d --rm --name petclinic-db --network petclinic-net \
  -e POSTGRES_USER=petclinic -e POSTGRES_PASSWORD=petclinic -e POSTGRES_DB=petclinic postgres:17
set +x
warte_auf_postgres petclinic-db petclinic

set -x
# App: DNS-Name petclinic-db in der JDBC-URL, Port-Mapping nur für die App.
# Achtung Stolperfalle: die Datenbank will POSTGRES_PASSWORD, die App liest POSTGRES_PASS.
docker container run -d --rm --name petclinic --network petclinic-net -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=postgres \
  -e POSTGRES_URL=jdbc:postgresql://petclinic-db/petclinic \
  -e POSTGRES_USER=petclinic -e POSTGRES_PASS=petclinic \
  trutzio/spring-petclinic:3.4.0-SNAPSHOT
set +x

# Spring-Boot-Start abwarten (selbst zuschauen: docker container logs -f petclinic)
warte_auf_log petclinic 'Started PetClinicApplication'
zeige_url "http://localhost:8080"

schritt "Beweis, dass die Daten in Postgres liegen: die von der App angelegten Tabellen"
set -x
docker container run --rm --network petclinic-net -e PGPASSWORD=petclinic postgres:17 \
  psql -h petclinic-db -U petclinic -d petclinic -c '\dt'
