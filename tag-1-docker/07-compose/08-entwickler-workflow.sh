#!/usr/bin/env bash
# Walkthrough: Entwickler-Workflow: Umsysteme im Container, App in der IDE
# Voraussetzung: Java 17 oder neuer (Debian 13: sudo apt install default-jdk)
# und das geklonte Repository (tag-1-docker/spring-petclinic).
# Die App läuft im Vordergrund, Ctrl-C beendet sie. Danach: ./09-aufraeumen.sh
set -euo pipefail
hier="$(cd "$(dirname "$0")" && pwd)"

# Der Compose-Stack belegt Port 8080, den die native App gleich braucht
(cd "$hier/petclinic-stack" && set -x && docker compose down)

cd "$hier/../spring-petclinic"

set -x
# Das Muster ist dasselbe wie in unserer eigenen Datei
cat docker-compose.yml

# Gezielt nur den Datenbank-Service des Projekts starten
docker compose up postgres -d

# Spring-Profil setzen (PowerShell: $env:SPRING_PROFILES_ACTIVE="postgres")
export SPRING_PROFILES_ACTIVE=postgres

# Mindestens Java 17
java -version

# Petclinic nativ starten, verbunden mit der Datenbank im Container: http://localhost:8080
./mvnw spring-boot:run
