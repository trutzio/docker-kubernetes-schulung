#!/usr/bin/env bash
# Lösung 3.2: beide nginx-Container laufen lassen, dann mit einem einzigen Befehl entfernen
# Voraussetzung: 03-container-run.sh
set -euxo pipefail

# Den gestoppten Container starten, jetzt laufen beide
docker container start nginx-vordergrund
docker container ls

# rm akzeptiert mehrere Container, -f stoppt sie vorher
docker container rm -f nginx-vordergrund nginx-hintergrund

docker container ls -a
