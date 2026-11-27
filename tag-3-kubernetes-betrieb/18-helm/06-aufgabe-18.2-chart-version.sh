#!/usr/bin/env bash
# Lösung 18.2: die Version des Charts erhöhen
# Das Skript arbeitet auf einer Kopie des Charts, damit die Dateien im Repository unverändert bleiben.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")"

kopie="$(mktemp -d)"
cp -r petclinic-chart "$kopie/"
sed 's/^version: 0.1.0$/version: 0.2.0/' petclinic-chart/Chart.yaml > "$kopie/petclinic-chart/Chart.yaml"

set -x
cat "$kopie/petclinic-chart/Chart.yaml"
helm upgrade petclinic "$kopie/petclinic-chart"

# Spalte CHART: petclinic-0.2.0
helm list
helm history petclinic
