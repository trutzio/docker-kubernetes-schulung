#!/usr/bin/env bash
# Walkthrough: Compose-Profile
# Statt den Schnipsel einzufügen, nimmt das Skript die fertige Datei compose.profil.yaml.
# Voraussetzung: 02-mehrere-container.sh
set -euxo pipefail
cd "$(dirname "$0")/compose-demo"

cat compose.profil.yaml

# Mit Profil: beide Services fahren herunter
docker compose -f compose.profil.yaml --profile=admin down

# Ohne Profil startet nur noch database
docker compose -f compose.profil.yaml up -d
docker compose -f compose.profil.yaml ps

# Mit Profil starten beide Services
docker compose -f compose.profil.yaml --profile=admin up -d
docker compose -f compose.profil.yaml --profile=admin ps
