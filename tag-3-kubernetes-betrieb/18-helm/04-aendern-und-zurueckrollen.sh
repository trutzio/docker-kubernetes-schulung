#!/usr/bin/env bash
# Walkthrough: Ändern und zurückrollen
# Voraussetzung: 03-petclinic-chart.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")"

set -x
# Einen Wert auf der Kommandozeile überschreiben
helm upgrade petclinic petclinic-chart --set replicaCount=2
kubectl get deployment petclinic

# Welche Werte weichen von den Standardwerten ab?
helm get values petclinic

helm history petclinic

# Zurück zur ersten Revision: wieder drei Replicas
helm rollback petclinic 1
kubectl get deployment petclinic

# Den Chart verpacken
helm package petclinic-chart
ls -l petclinic-0.1.0.tgz
