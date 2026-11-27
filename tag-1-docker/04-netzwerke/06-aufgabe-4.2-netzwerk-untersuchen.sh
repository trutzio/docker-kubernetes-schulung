#!/usr/bin/env bash
# Lösung 4.2: welche Container hängen im Netzwerk petclinic-net, mit welchen IP-Adressen?
set -euxo pipefail

docker network inspect petclinic-net

# Gezielter: nur die Container
docker network inspect --format '{{json .Containers}}' petclinic-net
