#!/usr/bin/env bash
# Walkthrough: Ein erster Rundgang durch den Cluster
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
# Spalte CONTAINER-RUNTIME: containerd, kein Docker
kubectl get nodes -o wide

# Alles, was im Cluster schon läuft: coredns, traefik, local-path-provisioner, metrics-server
kubectl get pods -A

# Aktueller Verbrauch (der metrics-server braucht nach der Installation etwa eine Minute)
kubectl top node || true

# Alle Arten von Objekten samt Kurznamen
kubectl api-resources | sed -n '1,20p'

# Dokumentation zu jedem Feld direkt im Terminal
kubectl explain pod.spec.containers | sed -n '1,25p'
