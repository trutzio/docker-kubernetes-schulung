#!/usr/bin/env bash
# Walkthrough: Ordner einbinden mit Bind Mounts
# Gearbeitet wird im Ordner arbeitsverzeichnis/ neben diesem Skript.
# Die Befehle laufen nicht interaktiv; die Shell aus dem Kapitel startest du mit:
#   docker container run -i -t --rm -v "$(pwd)/test:/test" busybox
set -euxo pipefail
mkdir -p "$(dirname "$0")/arbeitsverzeichnis"
cd "$(dirname "$0")/arbeitsverzeichnis"

# Ohne Mount: alles im Dateisystem gehört zum Image
docker container run --rm busybox ls /

# Auf dem Host: Ordner mit Testdatei
mkdir -p test
echo 'hello' > test/test.txt

# Den Host-Ordner als /test einbinden: der Container sieht die Datei vom Host
docker container run --rm -v "$(pwd)/test:/test" busybox cat /test/test.txt

# Löschen im Container löscht AUCH auf dem Host: ein Bind Mount ist keine Kopie
docker container run --rm -v "$(pwd)/test:/test" busybox rm /test/test.txt
ls -la test
