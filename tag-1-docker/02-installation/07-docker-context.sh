#!/usr/bin/env bash
# Walkthrough: docker context
# Auf dem eigenen Rechner ausführen. Der Kontext spricht über SSH mit dem Cloud-Server:
# Voraussetzung ist, dass "ssh core@<ip>" funktioniert und core dort docker ohne sudo aufrufen darf (Lösung 2.2).
# Aufruf: ./07-docker-context.sh <ip-des-cloud-servers> [user]     (user: Standard core)
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Aufruf: $0 <ip-des-cloud-servers> [user]" >&2
  exit 1
fi
ip="$1"
user="${2:-core}"

# Zurück zum lokalen Daemon, falls unterwegs etwas schiefgeht
trap 'docker context use default > /dev/null' ERR

set -x

# Alle Docker-Kontexte auflisten, der Stern markiert den aktiven
docker context ls

# Kontext do erzeugen, der über SSH mit dem Docker Server in der Cloud spricht
# (solange der TCP-Port aus Aufgabe 2.3 offen ist, ginge auch host=tcp://<ip>:2375)
docker context inspect do > /dev/null 2>&1 ||
  docker context create --docker "host=ssh://$user@$ip" do

# Zum Kontext do wechseln
docker context use do

# Version des lokalen Clients und des ENTFERNTEN Servers
docker version

# Ausführliche Informationen über den entfernten Server
docker info

# Zurück zum lokalen Docker Server; der Kontext do bleibt für das Kapitel Docker Image bestehen
docker context use default
docker context ls
