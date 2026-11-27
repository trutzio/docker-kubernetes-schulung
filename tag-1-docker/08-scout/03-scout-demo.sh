#!/usr/bin/env bash
# Walkthrough: Schwachstelle finden und beheben (Scout-Demo), Schritte 1 bis 7
# Voraussetzung: docker login. Das Demo-Projekt landet in tag-1-docker/scout-demo-service.
# Aufruf: ./03-scout-demo.sh <dein-dockerhub-user>
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Aufruf: $0 <dein-dockerhub-user>" >&2
  exit 1
fi
user="$1"
cd "$(dirname "$0")/.."

if [[ ! -d scout-demo-service ]]; then
  (set -x; git clone https://github.com/docker/scout-demo-service.git)
fi
cd scout-demo-service

set -x
# Image bauen und zu Docker Hub laden
docker buildx build --tag "$user/scout-demo:v1" .
docker push "$user/scout-demo:v1"

# Scout für den Account aktivieren und die laufende Analyse für das Repository einschalten
docker scout enroll "$user"
docker scout repo enable --org "$user" "$user/scout-demo"

# Analyse auf das Paket express filtern: Scout nennt die Fix-Version
docker scout cves --only-package express "$user/scout-demo:v1"
set +x

echo
echo "Web-Dashboard: https://scout.docker.com"
echo "Weiter mit dem Fix: ./04-scout-demo-fix.sh $user"
