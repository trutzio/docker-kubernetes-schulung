#!/usr/bin/env bash
# Walkthrough: Installation in der Cloud (DigitalOcean mit CoreOS)
# Auf dem Cloud-Server ausführen, nach der Anmeldung mit: ssh core@[ip]
set -euxo pipefail

# Status des containerd Daemons (Exit-Code ungleich 0, wenn er nicht läuft)
sudo systemctl status containerd --no-pager || true

# containerd starten, falls er nicht läuft
sudo systemctl start containerd

# Der laufende Daemon ist ein ganz normaler Linux-Prozess
ps ax | grep '[c]ontainerd'
