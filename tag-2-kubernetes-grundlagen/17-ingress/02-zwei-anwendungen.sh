#!/usr/bin/env bash
# Walkthrough: Zwei Anwendungen, ein Eingang
# Voraussetzung: 01-hostname.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
kubectl create deployment webserver --image=nginx
kubectl expose deployment webserver --port=80
kubectl create ingress webserver --class=traefik --rule="webserver.localhost/*=webserver:80"
kubectl rollout status deployment/webserver
set +x

warte_auf_url http://webserver.localhost
# Zwei Regeln mit derselben Adresse
(set -x; kubectl get ingress)
zeige_url http://webserver.localhost
zeige_url http://petclinic.localhost

schritt "Welches Manifest hat der Kurzbefehl erzeugt?"
(set -x; kubectl get ingress webserver -o yaml | sed -n '/^spec:/,/^status:/p')

(set -x; kubectl delete ingress,service,deployment webserver)
