#!/usr/bin/env bash
# Lösung 2.1: Welche Engine-Version liefern docker.io und docker-ce, ohne etwas zu installieren?
set -euxo pipefail

# Kandidaten-Version aus den Debian-Quellen
apt policy docker.io

# Kandidaten-Version aus dem Docker-Repository
# (zeigt nur dann einen Kandidaten, wenn das Repository eingetragen ist, siehe 02-linux-docker-ce.sh)
apt policy docker-ce
