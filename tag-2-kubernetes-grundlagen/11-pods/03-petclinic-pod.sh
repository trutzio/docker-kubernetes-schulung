#!/usr/bin/env bash
# Walkthrough: Journey-Moment: Petclinic läuft im Cluster
# Das Manifest liegt in k8s-uebungen/petclinic-pod.yaml.
# Voraussetzung: 02-image-importieren.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/k8s-uebungen"

set -x
cat petclinic-pod.yaml

# Manifest an den Cluster schicken
kubectl apply -f petclinic-pod.yaml
kubectl wait --for=condition=Ready pod/petclinic --timeout=120s
kubectl get pods
set +x

# Spring-Boot-Start abwarten (selbst zuschauen: kubectl logs -f petclinic)
warte_auf_log petclinic 'Started PetClinicApplication'

mit_port_forward pod/petclinic 8080:8080

schritt "Das vollständige Objekt mit allen Standardwerten und dem Abschnitt status"
(set -x; kubectl get pod petclinic -o yaml | sed -n '1,40p')

echo
echo "Der Pod läuft weiter. Selbst ansehen: kubectl port-forward pod/petclinic 8080:8080"
