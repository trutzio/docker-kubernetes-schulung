#!/usr/bin/env bash
# Lösung 8.2: Wie viele Pakete stecken im Petclinic-Image?
set -euxo pipefail

# Stückliste als lesbare Tabelle (ohne --format list kommt JSON)
docker scout sbom --format list petclinic:local

# Zeilen zählen
docker scout sbom --format list petclinic:local | wc -l
