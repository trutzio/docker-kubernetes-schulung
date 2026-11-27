#!/usr/bin/env bash
# Walkthrough: Docker API (Server-Seite, Terminal 1), lokal auf dem Debian-Rechner
# Stoppt den Docker Daemon und startet ihn händisch im Debug-Modus.
# Aufruf: ./08-docker-api-server.sh unix   (Schritte 1 bis 2: Unix Socket)
#         ./08-docker-api-server.sh tcp    (Schritt 5: TCP-Port 2375, nur auf 127.0.0.1)
#
# dockerd läuft im Vordergrund und zeigt das Debug-Log. In einem zweiten Terminal
# 09-docker-api-client.sh mit demselben Modus starten. Ctrl-C beendet dockerd,
# danach stellt das Skript den Normalzustand wieder her.
set -euo pipefail

modus="${1:-unix}"
case "$modus" in
  unix) optionen=(-H unix:///var/run/docker.sock) ;;
  # Nur 127.0.0.1: erreichbar vom eigenen Rechner, nicht aus dem Netzwerk.
  # --tls=false bestätigt ausdrücklich den Betrieb ohne TLS: ohne die Option verzögert
  # dockerd den Start um 15 Sekunden.
  tcp)  optionen=(--tls=false -H tcp://127.0.0.1:2375) ;;
  *)
    echo "Aufruf: $0 [unix|tcp]" >&2
    exit 1
    ;;
esac

# Normalzustand wiederherstellen, egal wie das Skript endet
aufraeumen() {
  echo
  echo "Stelle den Normalzustand wieder her: sudo systemctl start docker"
  sudo systemctl start docker
}
trap aufraeumen EXIT
trap : INT

# Daemon samt Socket stoppen, sonst startet systemd ihn bei der nächsten Anfrage wieder
(set -x; sudo systemctl stop docker.socket docker.service)

echo
echo "dockerd läuft gleich im Debug-Modus. Beenden mit Ctrl-C."
echo "Zweites Terminal: ./09-docker-api-client.sh $modus"
echo

(set -x; sudo dockerd --debug "${optionen[@]}") || true
