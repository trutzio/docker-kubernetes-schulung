#!/usr/bin/env bash
# Walkthrough: Dem eingebauten DNS-Server zuschauen
# Voraussetzung: 03-petclinic-trifft-postgres.sh
set -euxo pipefail

# ANSWER SECTION: A-Record für petclinic-db; SERVER: 127.0.0.11 ist Dockers eingebauter DNS-Server
docker container run --rm --network petclinic-net nicolaka/netshoot dig petclinic-db
