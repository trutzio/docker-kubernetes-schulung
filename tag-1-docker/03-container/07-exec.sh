#!/usr/bin/env bash
# Walkthrough: In den Container hinein mit exec
# Voraussetzung: 05-ports.sh (Container "nginx-zufallsport" läuft)
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
# Einen Linux-Befehl im Container ausführen
docker container exec nginx-zufallsport ls -la /usr/share/nginx/html

# Eine neue HTML-Datei innerhalb des Containers erzeugen
# (im Kapitel passiert das von Hand in einer interaktiven Shell, siehe Hinweis unten)
docker container exec nginx-zufallsport sh -c "echo '<p>Hello world!</p>' > /usr/share/nginx/html/test.html"

docker container exec nginx-zufallsport ls -la /usr/share/nginx/html
docker container exec nginx-zufallsport cat /usr/share/nginx/html/test.html
set +x

port="$(docker container port nginx-zufallsport 80/tcp | head -n 1 | sed 's/.*://')"
zeige_url "http://localhost:$port/test.html"

echo
echo "Die interaktive Shell aus dem Kapitel startest du selbst (exit beendet sie, der Container läuft weiter):"
echo "  docker container exec -i -t nginx-zufallsport bash"
