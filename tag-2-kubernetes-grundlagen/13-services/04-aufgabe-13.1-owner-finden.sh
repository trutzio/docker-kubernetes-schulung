#!/usr/bin/env bash
# Lösung 13.1: den neuen Owner per psql in der Datenbank wiederfinden
# Vorher im Browser unter http://localhost:8080 über "Find Owners" und "Add Owner" einen Owner anlegen.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
kubectl exec deployment/petclinic-db -- psql -U petclinic -d petclinic -c 'select * from owners;'
