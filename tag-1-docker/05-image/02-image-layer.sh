#!/usr/bin/env bash
# Walkthrough: Blick unter die Haube: Image Layer
# Die Dateien landen im Ordner arbeitsverzeichnis/ neben diesem Skript.
set -euxo pipefail
cd "$(dirname "$0")"

# Layer des nginx-Images samt der Befehle, die sie erzeugt haben
docker image history nginx

# Das komplette Image in eine tar-Datei speichern
rm -rf arbeitsverzeichnis/nginx
mkdir -p arbeitsverzeichnis/nginx
docker image save -o arbeitsverzeichnis/nginx.tar nginx

# Entpacken
tar xf arbeitsverzeichnis/nginx.tar -C arbeitsverzeichnis/nginx

# OCI-Format: blobs enthält die Layer, manifest.json beschreibt, wie sie zusammengehören
ls -la arbeitsverzeichnis/nginx
ls arbeitsverzeichnis/nginx/blobs/sha256 | head
cat arbeitsverzeichnis/nginx/manifest.json
echo

# Zusammenfassende Beschreibung des Images (Layer, ENV, CMD, Ports)
docker image inspect nginx
