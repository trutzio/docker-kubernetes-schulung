#!/usr/bin/env bash
# Lösung 7.3: Compose baut das Petclinic-Image bei Bedarf selbst (build:)
# Voraussetzung: das geklonte Repository mit Dockerfile aus dem Image-Kapitel (tag-1-docker/spring-petclinic)
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-stack"

set -x
cat compose.build.yaml

# --build baut das Image bei Bedarf neu; ohne --build verwendet Compose das vorhandene
docker compose -f compose.build.yaml up -d --build
docker compose -f compose.build.yaml ps
set +x

warte_auf_log petclinic-stack-petclinic-1 'Started PetClinicApplication'
zeige_url "http://localhost:8080"
