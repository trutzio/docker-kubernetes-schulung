#!/usr/bin/env bash
# Walkthrough: Die Änderungs-Schleife: ändern, bauen, ersetzen
# Voraussetzung: 06-petclinic-image-bauen.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
hier="$(cd "$(dirname "$0")" && pwd)"
cd "$hier/../spring-petclinic"

datei=src/main/resources/messages/messages.properties
setze_gruss() {
  sed "s/^welcome=.*/welcome=$1/" "$datei" > "$datei.neu" && mv "$datei.neu" "$datei"
  grep '^welcome=' "$datei"
}

schritt "Der alte Stand läuft: dieser Container spielt das Produktivsystem"
(set -x; docker container run -d --rm --name petclinic -p 8080:8080 petclinic:local)

schritt "Code ändern: ein eigener Gruß"
setze_gruss "Willkommen in der trutzigen Tierklinik"

schritt "Image neu bauen: der komplette Maven-Schritt läuft wieder"
time (set -x; docker buildx build --tag petclinic:local .)

schritt "Neuer Container neben dem alten schlägt fehl: port is already allocated"
(set -x; docker container run -d --rm --name petclinic-neu -p 8080:8080 petclinic:local) || true
# Der fehlgeschlagene Container bleibt im Status Created liegen und blockiert den Namen
docker container rm -f petclinic-neu > /dev/null 2>&1 || true

schritt "Erst den alten stoppen, dann den neuen starten"
stoppe petclinic
(set -x; docker container run -d --rm --name petclinic-neu -p 8080:8080 petclinic:local)
warte_auf_log petclinic-neu 'Started PetClinicApplication'
zeige_url "http://localhost:8080"
if command -v curl > /dev/null; then
  curl -s http://localhost:8080 | grep -i 'tierklinik' || true
fi

schritt "Dockerfile cache-freundlich machen: Abhängigkeiten in einen eigenen Layer vor dem Quellcode"
(set -x; cp "$hier/petclinic/Dockerfile.cache-freundlich" Dockerfile)
cat Dockerfile

schritt "Einmal bauen: füllt den neuen Abhängigkeits-Layer, lädt also noch einmal alles"
time (set -x; docker buildx build --tag petclinic:local .)

schritt "Wieder etwas am Gruß ändern und erneut bauen: jetzt laufen nur noch COPY src und das Kompilieren"
setze_gruss "Willkommen in der sehr trutzigen Tierklinik"
time (set -x; docker buildx build --tag petclinic:local .)

stoppe petclinic-neu
