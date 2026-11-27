#!/usr/bin/env bash
# Lösung 5.4: Warum ist der zweite Build so viel schneller, und was läuft nach einer Änderung neu?
# Voraussetzung: 06-petclinic-image-bauen.sh
set -euo pipefail
cd "$(dirname "$0")/../spring-petclinic"

schritt() { echo; echo "### $*"; }

schritt "Zweiter Build ohne Änderung: alle Layer kommen aus dem Build-Cache (CACHED)"
time (set -x; docker buildx build --tag petclinic:local .)

schritt "Kleinigkeit im Quellcode ändern"
datei=src/main/resources/messages/messages.properties
sed 's/^welcome=.*/welcome=Welcome (Aufgabe 5.4)/' "$datei" > "$datei.neu" && mv "$datei.neu" "$datei"
grep '^welcome=' "$datei"

schritt "Build nach der Änderung: ab COPY . . ist der Cache ungültig, der komplette Maven-Schritt läuft neu"
time (set -x; docker buildx build --tag petclinic:local .)
