#!/usr/bin/env bash
# Walkthrough: Helm installieren und ein fremder Chart (Schritte 1 bis 3)
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
# Offizielles Installations-Skript, installiert nach /usr/local/bin/helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | bash

helm version

# Alle Releases im Cluster: traefik ist schon da, von k3s installiert
helm list -A
