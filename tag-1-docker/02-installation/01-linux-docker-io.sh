#!/usr/bin/env bash
# Walkthrough: Lokale Installation (Linux) mit docker.io aus den Debian-Quellen (Debian 13)
# Alternative mit aktueller Engine: 02-linux-docker-ce.sh (nur einen der beiden Wege ausführen)
set -euxo pipefail

# Client docker, die Daemons dockerd und containerd sowie die Plugins buildx und compose installieren
sudo apt update
sudo apt install -y docker.io docker-buildx docker-compose

# Daemons dockerd und containerd starten
sudo service docker start

# Antworten Client UND Server, läuft die Installation
# (noch mit sudo: der Socket /var/run/docker.sock gehört der Gruppe docker)
sudo docker version

# Aktuellen User in die Gruppe docker aufnehmen
sudo usermod -aG docker "$(id -un)"

set +x
echo
echo "Fertig. Jetzt ab- und wieder anmelden, danach funktioniert 'docker version' ohne sudo."
