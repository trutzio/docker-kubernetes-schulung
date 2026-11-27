#!/usr/bin/env bash
# Lösung 12.3: das Deployment löschen und wieder anlegen
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-k8s"

set -x
kubectl delete -f petclinic-deployment.yaml
kubectl wait --for=delete pod -l app=petclinic --timeout=90s

# ReplicaSet und Pods sind mit verschwunden
kubectl get deployments,replicasets,pods

# Ein Befehl, und der Zielzustand aus der Datei ist wiederhergestellt
kubectl apply -f petclinic-deployment.yaml
kubectl rollout status deployment/petclinic
kubectl get deployments,replicasets,pods
