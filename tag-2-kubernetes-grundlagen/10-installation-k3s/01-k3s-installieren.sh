#!/usr/bin/env bash
# Walkthrough: k3s installieren (Debian 13)
# Vorher den Compose-Stack von Tag 1 herunterfahren: docker compose down im Verzeichnis petclinic-stack
set -euxo pipefail

# Offizielles Installations-Skript: legt /usr/local/bin/k3s ab, richtet den systemd-Dienst ein und startet ihn
curl -sfL https://get.k3s.io | sh -

# Der Dienst läuft
sudo systemctl status k3s --no-pager | sed -n '1,5p'

# Der Node braucht einige Sekunden, bis er sich beim API Server meldet
set +x
echo "... warte auf den Node"
for ((i = 0; i < 60; i++)); do
  [[ -n "$(sudo kubectl get nodes -o name 2> /dev/null)" ]] && break
  sleep 2
done
set -x
sudo kubectl wait --for=condition=Ready node --all --timeout=120s

# Genau ein Node: dein Rechner, Status Ready, Rolle control-plane
sudo kubectl get nodes

# kubectl, crictl und ctr sind nur Verweise auf die eine Programmdatei k3s
ls -l /usr/local/bin/
