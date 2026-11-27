#!/usr/bin/env bash
# Walkthrough: Der Beweis: dein Image läuft überall
# Voraussetzung: 10-aufgabe-5.5-docker-hub-push.sh und der SSH-Kontext "do" aus dem Installations-Kapitel
# (02-installation/07-docker-context.sh).
# Aufruf: ./11-beweis-cloud-server.sh <dein-dockerhub-user>
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Aufruf: $0 <dein-dockerhub-user>" >&2
  exit 1
fi
user="$1"

if ! docker context inspect do > /dev/null 2>&1; then
  echo "Der Kontext 'do' fehlt. Anlegen mit: ../02-installation/07-docker-context.sh <ip>" >&2
  exit 1
fi

# Zurück zum lokalen Daemon, falls unterwegs etwas schiefgeht
trap 'docker context use default > /dev/null' ERR

set -x
# Alle folgenden Befehle laufen auf dem Cloud-Server
docker context use do

# Zieht dein Image aus Docker Hub und startet es auf dem Server
docker container run -d --rm --name petclinic -p 8080:8080 "$user/spring-petclinic:local"
set +x

server="$(docker context inspect --format '{{.Endpoints.docker.Host}}' do | sed -e 's#^[a-z]*://##' -e 's#:[0-9]*$##' -e 's#^.*@##')"
echo
echo "Im Browser: http://$server:8080 (der Start dauert einige Sekunden)"
echo "Danach aufräumen mit: ./12-beweis-aufraeumen.sh"
