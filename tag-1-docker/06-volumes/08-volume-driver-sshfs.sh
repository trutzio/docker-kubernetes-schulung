#!/usr/bin/env bash
# Walkthrough: Volume Driver: Volumes auf entfernten Rechnern (Vertiefung)
# Voraussetzung: eine Debian-13-Maschine mit Passwort-Authentifizierung für root.
# Aufruf: ./08-volume-driver-sshfs.sh <ip>
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Aufruf: $0 <ip>" >&2
  exit 1
fi
ip="$1"

# Das Passwort wird abgefragt statt als Argument übergeben, damit es nicht in der Shell-Historie landet
read -r -s -p "root-Passwort für $ip: " passwort
echo

set -x
# Volume Driver, der Volumes über SSH auf entfernte Rechner legt
docker plugin install --grant-all-permissions vieux/sshfs
docker plugin ls
set +x

echo "+ docker volume create --driver vieux/sshfs -o sshcmd=root@$ip:/root -o password=[passwort] sshvolume"
docker volume create --driver vieux/sshfs -o "sshcmd=root@$ip:/root" -o "password=$passwort" sshvolume

set -x
# Für den Container ist das Remote-Volume ein Verzeichnis wie jedes andere
docker container run --rm -v sshvolume:/sshvolume busybox sh -c 'echo hallo > /sshvolume/vom-container.txt && ls -la /sshvolume'
set +x

echo
echo "Die Datei vom-container.txt liegt jetzt auf $ip unter /root."
echo "Aufräumen: docker volume rm sshvolume && docker plugin disable vieux/sshfs && docker plugin rm vieux/sshfs"
