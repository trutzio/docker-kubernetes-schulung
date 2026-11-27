#!/usr/bin/env bash
# Walkthrough: Lebenszyklus am nginx-Container
# Der Container bekommt hier den festen Namen "lebenszyklus", damit das Skript ohne Container-Id auskommt.
set -euxo pipefail

# Container erzeugen, aber nicht starten (das Image wird bei Bedarf heruntergeladen)
docker container create --name lebenszyklus nginx:latest

# Nur laufende Container: der neue ist nicht sichtbar
docker container ls

# Alle Container: der neue hat den Status Created
docker container ls -a

# Starten, Status ist jetzt Up
docker container start lebenszyklus
docker container ls

# Logs des laufenden Prozesses im Container
docker container logs lebenszyklus

# Stoppen: nicht mehr unter den laufenden, aber mit Status Exited noch vorhanden
docker container stop lebenszyklus
docker container ls
docker container ls -a

# Endgültig löschen
docker container rm lebenszyklus
docker container ls -a
