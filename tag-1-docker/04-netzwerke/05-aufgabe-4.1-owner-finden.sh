#!/usr/bin/env bash
# Lösung 4.1: den neuen Owner per psql in der Datenbank wiederfinden
# Vorher im Browser unter http://localhost:8080 über "Find Owners" und "Add Owner" einen Owner anlegen.
set -euxo pipefail

docker container run --rm --network petclinic-net -e PGPASSWORD=petclinic postgres:17 \
  psql -h petclinic-db -U petclinic -d petclinic -c 'select * from owners;'
