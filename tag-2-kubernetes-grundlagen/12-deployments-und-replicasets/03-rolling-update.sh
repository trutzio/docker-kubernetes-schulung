#!/usr/bin/env bash
# Walkthrough: Rolling Update
# Voraussetzung: 01-deployment.sh und das geklonte spring-petclinic von Tag 1
# (tag-1-docker/spring-petclinic mit der cache-freundlichen Dockerfile).
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
quelle="$(cd "$(dirname "$0")/../../tag-1-docker" && pwd)/spring-petclinic"

if [[ ! -f "$quelle/Dockerfile" ]]; then
  echo "Das Petclinic-Projekt mit Dockerfile fehlt: $quelle" >&2
  echo "Zuerst: tag-1-docker/05-image/06-petclinic-image-bauen.sh und 08-aenderungs-schleife.sh" >&2
  exit 1
fi

schritt "Neue Version bauen: anderer Gruß, Tag v2"
datei="$quelle/src/main/resources/messages/messages.properties"
sed 's/^welcome=.*/welcome=Willkommen im Cluster/' "$datei" > "$datei.neu" && mv "$datei.neu" "$datei"
grep '^welcome=' "$datei"
(set -x; docker buildx build --tag petclinic:v2 "$quelle")

schritt "Die neue Version in den Cluster bringen"
(set -x; docker image save petclinic:v2 | sudo k3s ctr images import -)

schritt "Image im Deployment ändern: Kubernetes tauscht die Pods Schritt für Schritt aus"
(set -x; kubectl set image deployment/petclinic petclinic=petclinic:v2; kubectl rollout status deployment/petclinic)

# Ein neues ReplicaSet mit drei Pods, das alte steht auf null
(set -x; kubectl get replicasets)

warte_auf_log deployment/petclinic 'Started PetClinicApplication'
mit_port_forward deployment/petclinic 8080:8080
if command -v curl > /dev/null; then
  kubectl port-forward deployment/petclinic 8080:8080 > /dev/null 2>&1 &
  pid=$!
  sleep 3
  curl -s -m 10 http://localhost:8080 | grep -i 'cluster' || true
  kill "$pid" 2> /dev/null || true
  wait "$pid" 2> /dev/null || true
fi

schritt "Die bisherigen Stände und der Weg zurück auf petclinic:local"
(set -x; kubectl rollout history deployment/petclinic; kubectl rollout undo deployment/petclinic; kubectl rollout status deployment/petclinic)
(set -x; kubectl get deployment petclinic -o jsonpath='{.spec.template.spec.containers[0].image}')
echo
