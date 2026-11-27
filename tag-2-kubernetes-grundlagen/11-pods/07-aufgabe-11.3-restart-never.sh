#!/usr/bin/env bash
# Lösung 11.3: restartPolicy Never
# Das Manifest liegt in k8s-uebungen/petclinic-absturz-never-pod.yaml.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/k8s-uebungen"

# restartPolicy lässt sich an einem bestehenden Pod nicht ändern: einen alten Pod vorher löschen
kubectl delete pod petclinic-absturz --ignore-not-found

set -x
cat petclinic-absturz-never-pod.yaml
kubectl apply -f petclinic-absturz-never-pod.yaml
set +x

echo "... warte, bis die App sich beendet hat"
kubectl wait --for=jsonpath='{.status.phase}'=Failed pod/petclinic-absturz --timeout=120s > /dev/null

# Status Error, RESTARTS bleibt bei 0: Kubernetes startet den Container nicht neu
(set -x; kubectl get pods; kubectl delete pod petclinic-absturz)
