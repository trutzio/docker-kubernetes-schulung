#!/usr/bin/env bash
# Walkthrough: Selbstheilung und Skalierung
# Voraussetzung: 01-deployment.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

schritt "Einen Pod löschen: das ReplicaSet ersetzt ihn sofort (Spalte AGE)"
pod="$(ein_pod app=petclinic)"
(set -x; kubectl get pods; kubectl delete pod "$pod"; kubectl get pods)

schritt "Skalieren ist nur eine Zahl im Zielzustand"
(set -x; kubectl scale deployment/petclinic --replicas=5; kubectl rollout status deployment/petclinic; kubectl get pods)

schritt "Gegenprobe am falschen Ort: das Deployment dreht die Änderung am ReplicaSet zurück"
# das aktive ReplicaSet (nach einem Rolling Update gibt es auch alte mit null Pods)
rs="$(kubectl get replicasets -l app=petclinic \
  -o go-template='{{range .items}}{{if .status.replicas}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}' | sed -n '1,1p')"
(set -x; kubectl scale "replicaset/$rs" --replicas=2; sleep 5; kubectl get replicasets)

schritt "Zurück auf drei Kopien"
(set -x; kubectl scale deployment/petclinic --replicas=3; kubectl rollout status deployment/petclinic; kubectl get pods)
