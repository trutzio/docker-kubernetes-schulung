#!/usr/bin/env bash
# Lösung 2.2: Docker Daemon prüfen, starten und docker ohne sudo ermöglichen
# Auf dem Cloud-Server ausführen
set -euxo pipefail

# Status des Docker Daemons (Exit-Code ungleich 0, wenn er nicht läuft)
sudo systemctl status docker --no-pager || true

# Docker Daemon starten
sudo systemctl start docker

# dockerd läuft als Prozess
ps ax | grep '[d]ockerd'

# Client UND Server antworten (noch mit sudo: der Socket /var/run/docker.sock gehört der Gruppe docker)
sudo docker version

# Aktuellen User in die Gruppe docker aufnehmen
sudo usermod -aG docker "$(id -un)"

set +x
echo
echo "Fertig. Jetzt ab- und wieder anmelden, danach funktioniert 'docker version' ohne sudo."
