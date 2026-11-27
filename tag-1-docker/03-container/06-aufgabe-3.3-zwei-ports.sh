#!/usr/bin/env bash
# Lösung 3.3: zwei nginx-Container gleichzeitig mit unterschiedlichen, festen Host-Ports
# Ports 8081 und 8082, denn 8080 belegt schon "nginx-8080" aus dem Walkthrough.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
docker container run -d -p 8081:80 --name nginx-8081 nginx:latest
docker container run -d -p 8082:80 --name nginx-8082 nginx:latest
set +x

sleep 1
zeige_url "http://localhost:8081"
zeige_url "http://localhost:8082"

schritt "Derselbe Host-Port zweimal schlägt fehl: port is already allocated"
set -x
docker container run -d -p 8081:80 --name nginx-doppelt nginx:latest || true

# Aufräumen (der fehlgeschlagene Container bleibt im Status Created liegen)
docker container rm -f nginx-8081 nginx-8082 nginx-doppelt
