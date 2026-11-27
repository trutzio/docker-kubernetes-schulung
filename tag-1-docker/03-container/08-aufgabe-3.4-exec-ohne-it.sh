#!/usr/bin/env bash
# Lösung 3.4: exec ohne die Optionen -i und -t
# Voraussetzung: 05-ports.sh (Container "nginx-zufallsport" läuft)
set -euxo pipefail

# Die Bash startet und beendet sich sofort wieder: ohne -i bekommt sie keine Eingabe
docker container exec nginx-zufallsport bash

# ls erwartet keine Eingabe, die Ausgabe erscheint direkt
docker container exec nginx-zufallsport ls /usr/share/nginx/html
