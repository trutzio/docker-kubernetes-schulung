#!/usr/bin/env bash
# Lösung 5.5: das Petclinic-Image zu Docker Hub schieben
# Voraussetzung: docker login (Aufgabe 5.1) und 06-petclinic-image-bauen.sh
# Aufruf: ./10-aufgabe-5.5-docker-hub-push.sh <dein-dockerhub-user>
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Aufruf: $0 <dein-dockerhub-user>" >&2
  exit 1
fi
user="$1"

set -x
# Registry weggelassen = Docker Hub
docker tag petclinic:local "$user/spring-petclinic:local"

docker push "$user/spring-petclinic:local"
set +x

echo
echo "Im Browser prüfen: https://hub.docker.com/r/$user/spring-petclinic"
