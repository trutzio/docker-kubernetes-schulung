#!/usr/bin/env bash
# Lösung 3.5: Überlebt test.html einen Neustart des Containers?
# Voraussetzung: 05-ports.sh und 07-exec.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
# Port-Mapping vor dem Neustart
docker container port nginx-zufallsport

docker container stop nginx-zufallsport
docker container start nginx-zufallsport

# Port-Mapping nach dem Neustart: -P hat einen NEUEN Host-Port vergeben
docker container port nginx-zufallsport
set +x

port="$(docker container port nginx-zufallsport 80/tcp | head -n 1 | sed 's/.*://')"
sleep 1
# Die Datei ist noch da: das Dateisystem des Containers bleibt beim Stoppen erhalten
zeige_url "http://localhost:$port/test.html"
