#!/usr/bin/env bash
# Walkthrough: Der mühsame Weg über die IP-Adresse
# psql läuft hier nicht interaktiv: das Passwort kommt über PGPASSWORD, die Abfrage über -c.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
# Postgres-Server ganz ohne -p
docker container run -d --rm --name pgserver \
  -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=secret -e POSTGRES_DB=testdb postgres:17
set +x
warte_auf_postgres pgserver

schritt "Naheliegender Versuch mit dem Containernamen: schlägt fehl (could not translate host name)"
set -x
docker container run --rm -e PGPASSWORD=secret postgres:17 \
  psql -h pgserver -U postgres -c '\conninfo' || true

# Auch der Hostname hilft nicht weiter: nur die Container-Id
docker container exec pgserver hostname
set +x

schritt "Die IP-Adresse des Servers im Default-Bridge-Netzwerk"
# Seit Docker Engine 29 gibt es .NetworkSettings.IPAddress nicht mehr,
# die Adresse steht pro Netzwerk unter .NetworkSettings.Networks
ip="$(docker container inspect --format '{{.NetworkSettings.Networks.bridge.IPAddress}}' pgserver)"
echo "+ docker container inspect --format '{{.NetworkSettings.Networks.bridge.IPAddress}}' pgserver"
echo "$ip"

schritt "Über die IP funktioniert es"
set -x
docker container run --rm -e PGPASSWORD=secret postgres:17 \
  psql -h "$ip" -U postgres -c '\conninfo'
set +x

echo
echo "Aber: die IP ändert sich potenziell bei jedem Neustart. Weiter mit 02-netzwerk-mit-dns.sh"
