#!/usr/bin/env bash
# Lösung 3.1: Kann ein Container entfernt werden, während er noch läuft?
set -euxo pipefail

docker container run -d --name rmtest nginx:latest

# Schlägt fehl: "container is running: stop the container before removing or force remove"
docker container rm rmtest || true

# Mit -f (force) wird in einem Schritt gestoppt und entfernt
docker container rm -f rmtest

docker container ls -a
