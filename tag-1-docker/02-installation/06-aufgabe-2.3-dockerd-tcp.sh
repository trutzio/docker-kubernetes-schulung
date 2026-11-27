#!/usr/bin/env bash
# Lösung 2.3: dockerd händisch starten, sodass er Verbindungen über TCP von außen akzeptiert
#
# ACHTUNG: Port 2375 ist unverschlüsselt und unauthentifiziert. Jeder mit Netzwerkzugriff
# kontrolliert damit den ganzen Server. Dieses Skript gehört ausschließlich auf den
# Wegwerf-Cloud-Server (CoreOS), nie auf den Arbeitsrechner oder einen Rechner im Firmennetz.
#
# dockerd läuft im Vordergrund. Ctrl-C beendet ihn, danach stellt das Skript
# den Normalzustand wieder her (Port 2375 ist dann wieder zu).
set -euo pipefail

read -r -p "Ist das hier der Wegwerf-Cloud-Server? Port 2375 wird ungeschützt geöffnet. [j/N] " antwort
if [[ "$antwort" != [jJ] ]]; then
  echo "Abgebrochen."
  exit 1
fi

# Normalzustand wiederherstellen, egal wie das Skript endet
aufraeumen() {
  echo
  echo "Stelle den Normalzustand wieder her: sudo systemctl start docker"
  sudo systemctl start docker
}
trap aufraeumen EXIT
trap : INT

# Der Original-Startbefehl steht unter ExecStart in der docker.service-Datei
grep ExecStart /usr/lib/systemd/system/docker.service || true

# Daemon stoppen (samt Socket, sonst startet systemd ihn bei der nächsten Anfrage wieder)
sudo systemctl stop docker.socket docker.service

echo
echo "dockerd lauscht jetzt auf tcp://0.0.0.0:2375. Test von einem anderen Rechner:"
echo "  docker -H tcp://[ip]:2375 version"
echo "Beenden mit Ctrl-C."
echo

# Original-Befehl aus ExecStart (CoreOS), ergänzt um die TCP-Option.
# --tls=false bestätigt ausdrücklich den Betrieb ohne TLS: ohne die Option verzögert
# dockerd den Start um 15 Sekunden und zeigt eine Deprecation-Warnung.
sudo dockerd -H tcp://0.0.0.0:2375 --tls=false \
    --containerd=/run/containerd/containerd.sock \
    --selinux-enabled \
    --userland-proxy-path /usr/bin/docker-proxy \
    --init-path /usr/bin/tini-static || true
