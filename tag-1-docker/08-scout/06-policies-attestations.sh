#!/usr/bin/env bash
# Walkthrough: Policies, SBOM und Provenance (Vertiefung)
# Voraussetzung: 04-scout-demo-fix.sh und der containerd image store (siehe Kapitel Docker Architektur)
# Aufruf: ./06-policies-attestations.sh <dein-dockerhub-user>
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Aufruf: $0 <dein-dockerhub-user>" >&2
  exit 1
fi
user="$1"
cd "$(dirname "$0")/../scout-demo-service"

set -x
# Standard-Organisation für die folgenden Befehle
docker scout config organization "$user"

# Zeigt jetzt zusätzlich den Policy-Status des zuletzt gebauten Images
docker scout quickview
set +x

# Typischer Verstoß: das Image läuft als Root. Fix: einen User anlegen und mit USER umschalten.
if ! grep -q '^USER appuser' Dockerfile; then
  printf '\nRUN addgroup -S appuser && adduser -S -G appuser appuser\nUSER appuser\n' >> Dockerfile
fi
tail -n 5 Dockerfile

set -x
# Nächste Version mit zwei Attestations: SBOM (Stückliste) und Provenance (Herkunftsnachweis)
docker buildx build --provenance=true --sbom=true --push --tag "$user/scout-demo:v3" .

docker scout quickview "$user/scout-demo:v3"
