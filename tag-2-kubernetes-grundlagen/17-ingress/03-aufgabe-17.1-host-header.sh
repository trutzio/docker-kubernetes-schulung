#!/usr/bin/env bash
# Lösung 17.1: die Petclinic über die IP-Adresse aufrufen, mit dem Hostnamen im Header
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
# Ohne passenden Hostnamen: 404
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1/

# Mit dem Header Host: Traefik liefert die Petclinic aus
curl -s -o /dev/null -w '%{http_code}\n' -H 'Host: petclinic.localhost' http://127.0.0.1/
