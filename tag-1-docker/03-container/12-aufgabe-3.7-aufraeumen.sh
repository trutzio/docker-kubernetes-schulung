#!/usr/bin/env bash
# Lösung 3.7: alle Container aus diesem Kapitel entfernen
# Das Skript entfernt gezielt die Container, die die Skripte dieses Kapitels angelegt haben,
# und lässt alle anderen Container auf deinem Rechner in Ruhe.
# Die Option -v entfernt die anonymen Volumes gleich mit, die das Postgres-Image anlegt.
set -euo pipefail

for container in lebenszyklus rmtest nginx-vordergrund nginx-hintergrund nginx-zufallsport \
  nginx-8080 nginx-8081 nginx-8082 nginx-doppelt pg-ohne-passwort pg-mit-passwort pgserver; do
  if docker container inspect "$container" > /dev/null 2>&1; then
    (set -x; docker container rm -f -v "$container")
  fi
done

set -x
docker container ls -a

# Tipp für später: entfernt alle gestoppten Container auf einmal, mit Sicherheitsabfrage
# docker container prune
