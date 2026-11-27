#!/usr/bin/env bash
# Walkthrough: Schwachstelle finden und beheben (Scout-Demo), Schritte 8 und 9: der Fix
# Voraussetzung: 03-scout-demo.sh
# Aufruf: ./04-scout-demo-fix.sh <dein-dockerhub-user>
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Aufruf: $0 <dein-dockerhub-user>" >&2
  exit 1
fi
user="$1"
cd "$(dirname "$0")/../scout-demo-service"

# Der Fix ist eine Zeile: express auf 4.17.3 anheben
sed 's/"express": "[^"]*"/"express": "4.17.3"/' package.json > package.json.neu && mv package.json.neu package.json
grep '"express"' package.json

set -x
# Reparierte Version in einem Schritt bauen und pushen
docker buildx build --push --tag "$user/scout-demo:v2" .
