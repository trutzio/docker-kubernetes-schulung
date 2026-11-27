#!/usr/bin/env bash
# Vergleich docker.io oder docker-ce: Installation von docker-ce aus dem offiziellen Docker-Repository (Debian 13)
# Quelle: https://docs.docker.com/engine/install/debian/
# Alternative aus den Debian-Quellen: 01-linux-docker-io.sh (nur einen der beiden Wege ausführen)
set -euo pipefail

. /etc/os-release
if [[ "$ID" != debian ]]; then
  echo "Dieses Skript ist für Debian gedacht (gefunden: $ID)." >&2
  echo "Andere Distributionen: https://docs.docker.com/engine/install/" >&2
  exit 1
fi

# Stolperstein beim Wechsel: die Pakete aus den Debian-Quellen vertragen sich nicht mit docker-ce.
# Bleibt zum Beispiel docker-buildx liegen, bricht die Installation mit "trying to overwrite" ab.
# Die Daten unter /var/lib/docker bleiben beim Entfernen erhalten.
for pkg in docker.io docker-cli docker-buildx docker-compose docker-doc podman-docker containerd runc; do
  if dpkg -s "$pkg" > /dev/null 2>&1; then
    echo "Entferne unverträgliches Paket: $pkg"
    sudo apt remove -y "$pkg"
  fi
done

set -x

# Voraussetzungen für den Download des GPG-Schlüssels
sudo apt update
sudo apt install -y ca-certificates curl

# GPG-Schlüssel des Docker-Repositorys ablegen
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg \
  -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Docker-Repository als Paketquelle eintragen
echo "deb [arch=$(dpkg --print-architecture) \
signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/debian \
$VERSION_CODENAME stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Engine samt Compose- und Buildx-Plugin installieren
sudo apt update
sudo apt install -y docker-ce docker-ce-cli \
  containerd.io docker-buildx-plugin docker-compose-plugin

# Daemons starten und prüfen: Client UND Server müssen antworten
sudo service docker start
sudo docker version

# Aktuellen User in die Gruppe docker aufnehmen
sudo usermod -aG docker "$(id -un)"

set +x
echo
echo "Fertig. Jetzt ab- und wieder anmelden, danach funktioniert 'docker version' ohne sudo."
