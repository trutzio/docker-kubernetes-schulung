#!/usr/bin/env bash
# Walkthrough: Images verwalten
# docker login (Aufgabe 5.1) ist interaktiv und läuft deshalb von Hand: docker login
set -euxo pipefail

# Alle Images auf dem Docker Server
docker image ls

# Ein Image herunterladen
docker pull alpine:latest
docker image ls alpine

# Ein Image wieder entfernen
docker image rm alpine:latest
