#!/usr/bin/env bash
# Walkthrough: Eigenes Image mit Dockerfile
# Die Dockerfile liegt im Ordner eigenes-image/.
set -euxo pipefail
cd "$(dirname "$0")/eigenes-image"

cat Dockerfile

# Image test:latest bauen; der Punkt am Ende ist der Build-Kontext
docker buildx build --tag test:latest .

# Unten die Layer von postgres:17, oben unsere zwei ENV-Einträge
docker image history test:latest

# Nur das Passwort muss noch rein, User und Datenbank stecken schon im Image
docker container run -d --rm --name testdb-server -e POSTGRES_PASSWORD=secret test:latest
