#!/usr/bin/env bash
# Walkthrough: Ports veröffentlichen
# Die Container heißen hier "nginx-zufallsport" und "nginx-8080" und laufen danach weiter
# (der Walkthrough exec und die Aufgaben 3.4 und 3.5 brauchen "nginx-zufallsport").
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
# -P bildet alle offenen Ports des Containers auf zufällige, freie Ports des Hosts ab
docker container run -d -P --name nginx-zufallsport nginx:latest

# Die Spalte PORTS zeigt das Mapping
docker container ls
set +x

port="$(docker container port nginx-zufallsport 80/tcp | head -n 1 | sed 's/.*://')"
sleep 1
zeige_url "http://localhost:$port"

set -x
# -p legt das Mapping explizit fest: Port 8080 des Hosts geht auf Port 80 im Container
docker container run -d -p 8080:80 --name nginx-8080 nginx:latest
set +x

sleep 1
zeige_url "http://localhost:8080"
