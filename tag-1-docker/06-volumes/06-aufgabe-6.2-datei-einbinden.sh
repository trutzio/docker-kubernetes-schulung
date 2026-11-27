#!/usr/bin/env bash
# Lösung 6.2: eine einzelne Datei einbinden, anderer Name im Container, vertippter Host-Pfad
set -euxo pipefail
mkdir -p "$(dirname "$0")/arbeitsverzeichnis"
cd "$(dirname "$0")/arbeitsverzeichnis"

echo 'hallo' > test.txt

# Der Name im Container ist frei wählbar
docker container run --rm -v "$(pwd)/test.txt:/im/container/anders.txt" busybox cat /im/container/anders.txt

# Vertippt: tset.txt gibt es nicht. Kein Fehler, Docker legt den Pfad als LEERES VERZEICHNIS an
docker container run --rm -v "$(pwd)/tset.txt:/im/container/anders.txt" busybox ls -la /im/container/
ls -ld tset.txt

# Aufräumen: das Verzeichnis gehört root, deshalb über einen Container entfernen
docker container run --rm -v "$(pwd):/arbeit" busybox rmdir /arbeit/tset.txt
