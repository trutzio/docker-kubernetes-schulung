#!/usr/bin/env bash
# Aufräumen vor dem Compose-Kapitel: alle Container dieses Kapitels stoppen, damit Port 8080
# für pgAdmin und den Compose-Stack frei ist (Lösung 6.1, letzter Schritt, und Lösung 6.3).
# Das Volume petclinic-data bleibt bestehen.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

stoppe web petclinic petclinic-db pgtest

if docker network inspect petclinic-net > /dev/null 2>&1; then
  (set -x; docker network rm petclinic-net)
fi

set -x
docker container ls -a
docker volume ls
