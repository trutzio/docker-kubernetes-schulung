#!/usr/bin/env bash
# Walkthrough: Von außen erreichbar
# Das Manifest liegt in petclinic-k8s/petclinic-service.yaml (mit type: LoadBalancer).
# Voraussetzung: 02-petclinic-trifft-postgres.sh; Port 8080 muss frei sein.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-k8s"

set -x
cat petclinic-service.yaml
kubectl apply -f petclinic-service.yaml
set +x

warte_auf_url http://localhost:8080

set -x
# Typ LoadBalancer, EXTERNAL-IP, Ports 8080:3xxxx
kubectl get services

# Der kleine Load Balancer von k3s: Pod svclb-petclinic-...
kubectl get pods -n kube-system | grep svclb
set +x

zeige_url http://localhost:8080

# Die zweite Portnummer ist ein NodePort
nodeport="$(kubectl get service petclinic -o jsonpath='{.spec.ports[0].nodePort}')"
zeige_url "http://localhost:$nodeport"
