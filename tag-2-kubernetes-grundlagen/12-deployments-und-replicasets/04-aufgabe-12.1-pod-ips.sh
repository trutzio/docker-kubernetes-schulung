#!/usr/bin/env bash
# Lösung 12.1: IP-Adressen und Node der Pods; welche IP bekommt ein Ersatz-Pod?
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

pod="$(ein_pod app=petclinic)"
set -x
kubectl get pods -o wide
kubectl delete pod "$pod"
kubectl rollout status deployment/petclinic

# Der Ersatz hat einen neuen Namen UND eine neue IP
kubectl get pods -o wide
