#!/usr/bin/env bash
# Lösung 6.3: nginx liefert eine eigene index.html aus einem Host-Ordner aus
# Vorher räumt das Skript den Petclinic-Stack aus Aufgabe 6.1 weg (Lösung 6.1, letzter Schritt), der Port 8080 belegt.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
mkdir -p "$(dirname "$0")/arbeitsverzeichnis"
cd "$(dirname "$0")/arbeitsverzeichnis"

# Aufräumen aus Lösung 6.1: Port 8080 freigeben, das Volume petclinic-data bleibt
stoppe petclinic petclinic-db
if docker network inspect petclinic-net > /dev/null 2>&1; then
  (set -x; docker network rm petclinic-net)
fi

set -x
mkdir -p web
echo '<h1>Hallo aus dem Bind Mount</h1>' > web/index.html

docker container run -d --rm --name web -p 8080:80 -v "$(pwd)/web:/usr/share/nginx/html" nginx:latest
set +x

sleep 1
zeige_url "http://localhost:8080"
command -v curl > /dev/null && curl -s http://localhost:8080

schritt "Datei auf dem Host ändern: sofort sichtbar, kein Rebuild, kein Neustart"
(set -x; echo '<h1>Geändert auf dem Host</h1>' > web/index.html)
command -v curl > /dev/null && curl -s http://localhost:8080

echo
echo "Der Container 'web' läuft weiter, damit du es im Browser ausprobieren kannst."
echo "Stoppen: docker container stop web (oder ./09-aufraeumen.sh)"
