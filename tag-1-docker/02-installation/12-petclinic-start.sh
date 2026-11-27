#!/usr/bin/env bash
# Walkthrough: Journey-Kickoff: Petclinic läuft
set -euo pipefail

set -x
# Kurs-App Spring Petclinic aus einem fertigen Image von Docker Hub starten
docker container run -d --rm --name petclinic -p 8080:8080 trutzio/spring-petclinic:3.4.0-SNAPSHOT
set +x

echo
echo "Warte auf die Zeile 'Started PetClinicApplication', dann im Browser: http://localhost:8080"
echo "(läuft Docker auf dem Cloud-Server, localhost durch die Server-IP ersetzen)"
echo "Ctrl-C beendet nur die Log-Anzeige, nicht den Container. Stoppen: ./13-petclinic-stop.sh"
echo

# Start der Java-Anwendung verfolgen
docker container logs -f petclinic
