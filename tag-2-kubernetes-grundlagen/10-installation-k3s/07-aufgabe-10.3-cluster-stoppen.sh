#!/usr/bin/env bash
# Lösung 10.3: Was passiert mit kubectl, wenn der Cluster nicht läuft?
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

# Den Dienst in jedem Fall wieder starten
trap 'sudo systemctl start k3s' EXIT

# k3s-killall.sh stoppt den Dienst UND alle Container des Clusters
# (systemctl stop k3s allein stoppt nur den Dienst, die Container laufen weiter)
(set -x; sudo /usr/local/bin/k3s-killall.sh > /dev/null)
sleep 3

schritt "Ohne API Server geht nichts: connection refused"
(set -x; kubectl get nodes) || true

schritt "Dienst wieder starten"
(set -x; sudo systemctl start k3s)
trap - EXIT
echo "... warte auf den API Server"
for ((i = 0; i < 60; i++)); do
  kubectl get nodes > /dev/null 2>&1 && break
  sleep 2
done
(set -x; kubectl wait --for=condition=Ready node --all --timeout=120s; kubectl get nodes)
