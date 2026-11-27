#!/usr/bin/env bash
# Walkthrough: Der erste Pod
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
# Pod webserver aus dem Image nginx:latest
kubectl run webserver --image=nginx

# Warten, bis das Image geladen ist und der Container läuft
kubectl wait --for=condition=Ready pod/webserver --timeout=120s

kubectl get pods

# Zusätzlich IP-Adresse und Node
kubectl get pods -o wide

# Alle Details; ganz unten die Events
kubectl describe pod webserver

kubectl logs webserver
set +x

# Lokalen Port 8080 auf Port 80 im Pod leiten
mit_port_forward pod/webserver 8080:80

set -x
# Einen Befehl im Container ausführen (interaktiv: kubectl exec -i -t webserver -- bash)
kubectl exec webserver -- ls /usr/share/nginx/html

kubectl delete pod webserver
