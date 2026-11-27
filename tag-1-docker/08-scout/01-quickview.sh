#!/usr/bin/env bash
# Walkthrough: Quickview: was steckt in unserem Petclinic-Image? (und Lösung 8.1)
# Voraussetzung: petclinic:local aus dem Image-Kapitel, docker login und das CLI-Plugin docker scout
# (unter Debian 13 nachinstallieren: https://docs.docker.com/scout/install/).
set -euo pipefail

if ! docker scout version > /dev/null 2>&1; then
  echo "docker scout ist nicht installiert: https://docs.docker.com/scout/install/" >&2
  exit 1
fi

set -x
# Übersicht der CVEs nach Schweregrad, für das Image und sein Basis-Image
docker scout quickview petclinic:local

# Die einzelnen Schwachstellen mit CVE-Nummer, betroffenem Paket und Fix-Version
docker scout cves petclinic:local

# Basis-Image-Alternativen und wie viele CVEs ein Wechsel beseitigen würde
docker scout recommendations petclinic:local
