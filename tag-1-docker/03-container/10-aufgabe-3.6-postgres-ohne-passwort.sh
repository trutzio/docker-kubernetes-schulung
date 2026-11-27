#!/usr/bin/env bash
# Lösung 3.6: Warum stoppt der Postgres-Container sofort wieder?
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
docker container run -d -P --name pg-ohne-passwort postgres:17
sleep 3

# Status Exited
docker container ls -a --filter name=pg-ohne-passwort

# Der Grund steht im Log: superuser password is not specified
docker container logs pg-ohne-passwort

# Mit Passwort startet Postgres durch
docker container run -d -P --name pg-mit-passwort -e POSTGRES_PASSWORD=secret postgres:17
set +x

warte_auf_postgres pg-mit-passwort
set -x
docker container logs pg-mit-passwort | grep 'ready to accept connections'
docker container ls --filter name=pg-mit-passwort
