#!/usr/bin/env bash
# Walkthrough: Petclinic bekommt einen Hostnamen
# Die Manifeste liegen in petclinic-k8s/ (petclinic-service.yaml ohne type, petclinic-ingress.yaml).
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-k8s"

set -x
# Der Service braucht keinen eigenen Zugang von außen mehr: zurück zu ClusterIP
cat petclinic-service.yaml
kubectl apply -f petclinic-service.yaml
kubectl get services

cat petclinic-ingress.yaml
kubectl apply -f petclinic-ingress.yaml
set +x

warte_auf_url http://petclinic.localhost
(set -x; kubectl get ingress)
zeige_url http://petclinic.localhost

schritt "Für den Hostnamen localhost gibt es keine Regel: 404 page not found"
(set -x; curl -i -s http://localhost | sed -n '1p;$p')
echo
