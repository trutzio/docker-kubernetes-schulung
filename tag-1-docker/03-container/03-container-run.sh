#!/usr/bin/env bash
# Walkthrough: docker container run
# Die Container heißen hier "nginx-vordergrund" und "nginx-hintergrund".
set -euo pipefail
trap : INT

echo "nginx startet jetzt im Vordergrund und zeigt seinen Log."
echo "Ctrl-C stoppt den Container, danach läuft das Skript weiter."
echo
echo "+ docker container run --name nginx-vordergrund nginx:latest"
docker container run --name nginx-vordergrund nginx:latest || true

set -x

# Der Container ist gestoppt (Status Exited), aber noch da
docker container ls -a

# start blockiert die Konsole nicht
docker container start nginx-vordergrund

docker container stop nginx-vordergrund

# Ein NEUER Container im detached mode: läuft im Hintergrund
docker container run -d --name nginx-hintergrund nginx:latest

# Zwei nginx-Container: einer gestoppt, einer läuft
docker container ls -a
