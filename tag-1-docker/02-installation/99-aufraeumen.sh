#!/usr/bin/env bash
# Aufräumen nach den Walkthroughs docker context und Docker API:
# zurück zum lokalen Daemon und den Übungs-Kontext local entfernen.
# Der Kontext do bleibt bestehen: das Image-Kapitel braucht ihn für den Beweis auf dem Cloud-Server.
# Aufruf: ./99-aufraeumen.sh          (do bleibt)
#         ./99-aufraeumen.sh --alle   (do wird auch entfernt)
set -euo pipefail

kontexte=(local)
if [[ "${1:-}" == --alle ]]; then
  kontexte+=(do)
fi

set -x
docker context use default
set +x

for kontext in "${kontexte[@]}"; do
  if docker context inspect "$kontext" > /dev/null 2>&1; then
    (set -x; docker context rm "$kontext")
  fi
done

set -x
docker context ls
