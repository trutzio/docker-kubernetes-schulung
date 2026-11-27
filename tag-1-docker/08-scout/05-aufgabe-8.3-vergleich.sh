#!/usr/bin/env bash
# Lösung 8.3: v1 und v2 direkt miteinander vergleichen
# Aufruf: ./05-aufgabe-8.3-vergleich.sh <dein-dockerhub-user>
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Aufruf: $0 <dein-dockerhub-user>" >&2
  exit 1
fi
user="$1"

set -x
docker scout compare --to "$user/scout-demo:v1" "$user/scout-demo:v2"
