#!/usr/bin/env bash
# Walkthrough: Docker API (Client-Seite, Terminal 2)
# Voraussetzung: in Terminal 1 läuft 08-docker-api-server.sh mit demselben Modus.
# Aufruf: ./09-docker-api-client.sh unix   (Schritte 3 bis 4)
#         ./09-docker-api-client.sh tcp    (Schritte 6 bis 10)
set -euo pipefail

modus="${1:-unix}"

case "$modus" in
  unix)
    set -x

    # Der aktive Kontext muss auf unix:///var/run/docker.sock zeigen
    docker context use default
    docker context ls

    # Im Debug-Log der Server-Seite erscheint ein GET auf /v1.xx/images/json
    docker image ls
    ;;
  tcp)
    # Zurück zum Standard-Kontext, falls unterwegs etwas schiefgeht
    trap 'docker context use default > /dev/null' ERR
    set -x

    # Lokalen TCP-Kontext erzeugen (falls noch nicht vorhanden) und aktivieren
    docker context inspect local > /dev/null 2>&1 ||
      docker context create local --docker "host=tcp://localhost:2375"
    docker context use local

    # Im Debug-Log der Server-Seite erscheint wieder der bekannte Eintrag
    docker image ls

    # Die CLI ist nur ein hübscher HTTP-Client: derselbe Aufruf als roher REST-Request
    # (dieselbe URL funktioniert auch im Browser)
    api_version="$(docker version --format '{{.Server.APIVersion}}')"
    curl -s "http://localhost:2375/v$api_version/images/json"
    echo

    # Aufräumen: zurück zum Standard-Kontext, Übungs-Kontext entfernen
    docker context use default
    docker context rm local
    ;;
  *)
    echo "Aufruf: $0 [unix|tcp]" >&2
    exit 1
    ;;
esac
