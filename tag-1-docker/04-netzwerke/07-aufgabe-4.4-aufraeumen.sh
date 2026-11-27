#!/usr/bin/env bash
# Lösung 4.4: beide Petclinic-Container stoppen, die Netzwerke test und petclinic-net entfernen
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

if docker container inspect petclinic-db > /dev/null 2>&1; then
  schritt "Ein Netzwerk mit Containern lässt sich nicht entfernen: has active endpoints"
  (set -x; docker network rm petclinic-net) || true
fi

# Dank --rm sind die Container nach dem Stoppen auch entfernt
stoppe petclinic petclinic-db pgserver

for netz in test petclinic-net; do
  if docker network inspect "$netz" > /dev/null 2>&1; then
    (set -x; docker network rm "$netz")
  fi
done

set -x
docker network ls
docker container ls -a
