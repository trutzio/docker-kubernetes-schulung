#!/usr/bin/env bash
# Lösung 16.2: ein zu kleines Limit für den Arbeitsspeicher
# Das Skript ändert die Werte direkt im Cluster; im Kapitel änderst du sie in der Datei.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/petclinic-k8s"

(set -x; kubectl set resources deployment/petclinic -c petclinic --requests=memory=64Mi --limits=memory=64Mi)

schritt "Der neue Pod wird beendet, sobald Java mehr als 64 MiB braucht: OOMKilled, CrashLoopBackOff"
sleep 45
(set -x; kubectl get pods)
(set -x; kubectl describe pods -l app=petclinic | grep -E 'Reason: +OOMKilled' | sort | uniq -c) || true

schritt "Die drei alten Pods laufen weiter, die Anwendung bleibt erreichbar"
zeige_url http://localhost:8080

schritt "Alte Werte wiederherstellen"
(set -x; kubectl apply -f petclinic-deployment.yaml; kubectl rollout status deployment/petclinic)
