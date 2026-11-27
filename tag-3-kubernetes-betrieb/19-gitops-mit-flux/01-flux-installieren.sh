#!/usr/bin/env bash
# Walkthrough: Flux installieren und mit GitHub verbinden (Schritte 3 und 4: die Kommandozeile flux)
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
curl -s https://fluxcd.io/install.sh | sudo bash
flux --version

# Erfüllt der Cluster die Voraussetzungen?
flux check --pre
