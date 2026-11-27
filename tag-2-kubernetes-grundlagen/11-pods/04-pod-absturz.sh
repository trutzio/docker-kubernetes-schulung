#!/usr/bin/env bash
# Walkthrough: Wenn ein Pod abstürzt
# Das Manifest liegt in k8s-uebungen/petclinic-absturz-pod.yaml.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/k8s-uebungen"

set -x
cat petclinic-absturz-pod.yaml
kubectl apply -f petclinic-absturz-pod.yaml
set +x

schritt "Eine Minute zuschauen: Running, Error, CrashLoopBackOff, RESTARTS zählt hoch"
(set -x; timeout 60 kubectl get pods -w) || true

schritt "Der Grund steht im Log: Connection to localhost:5432 refused"
(set -x; kubectl logs petclinic-absturz | grep -E 'refused|APPLICATION FAILED' | sed -n '1,5p') || true

schritt "Die Events: Back-off restarting failed container"
(set -x; kubectl describe pod petclinic-absturz | tail -n 12)

(set -x; kubectl delete pod petclinic-absturz)
