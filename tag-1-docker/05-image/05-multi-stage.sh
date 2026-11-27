#!/usr/bin/env bash
# Walkthrough: Multi-Stage Build
# Die Dockerfile liegt im Ordner multi-stage/.
set -euxo pipefail
cd "$(dirname "$0")/multi-stage"

cat Dockerfile

# Beide Stages werden gebaut, getaggt wird nur die letzte
docker buildx build --tag hello:latest .

# Nur zwei Mini-Layer, das Go-Toolchain-Image ist nicht dabei
docker image history hello:latest
docker image ls hello

docker container run --rm hello
