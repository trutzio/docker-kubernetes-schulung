#!/usr/bin/env bash
# Walkthrough: Journey-Moment: das Petclinic-Image selbst bauen
# Der Quellcode landet in tag-1-docker/spring-petclinic, die Dockerfile kommt aus dem Ordner petclinic/.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
hier="$(cd "$(dirname "$0")" && pwd)"
cd "$hier/.."

if [[ ! -d spring-petclinic ]]; then
  (set -x; git clone https://github.com/spring-projects/spring-petclinic.git)
fi
cd spring-petclinic

set -x
# Dockerfile ins Projektverzeichnis legen
cp "$hier/petclinic/Dockerfile" Dockerfile
cat Dockerfile

# Der erste Build dauert einige Minuten: Maven lädt alle Abhängigkeiten herunter
docker buildx build --tag petclinic:local .

# Ohne Datenbank-Konfiguration nimmt Petclinic die eingebaute In-Memory-Datenbank
docker container run -d --rm --name petclinic -p 8080:8080 petclinic:local
set +x

warte_auf_log petclinic 'Started PetClinicApplication'
zeige_url "http://localhost:8080"

stoppe petclinic
