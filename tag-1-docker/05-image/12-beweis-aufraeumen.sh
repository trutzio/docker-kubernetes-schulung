#!/usr/bin/env bash
# Walkthrough: Der Beweis: Aufräumen auf dem Cloud-Server und zurück zum lokalen Daemon
set -euxo pipefail

docker context use do
docker container stop petclinic || true

# Damit die nächsten Kapitel wieder lokal arbeiten
docker context use default
docker context ls
