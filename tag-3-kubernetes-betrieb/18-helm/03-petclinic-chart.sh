#!/usr/bin/env bash
# Walkthrough: Journey-Moment: Petclinic wird zum Chart
# Der fertige Chart liegt in petclinic-chart/ (im Kapitel entsteht er aus den Manifesten von Tag 2).
# Voraussetzung: der Stack von Tag 2 läuft (tag-2-kubernetes-grundlagen/17-ingress).
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")"
tag2="../../tag-2-kubernetes-grundlagen/17-ingress/petclinic-k8s"

set -x
ls -R petclinic-chart
cat petclinic-chart/Chart.yaml petclinic-chart/values.yaml

# Die Platzhalter in den Templates
grep -rn '{{' petclinic-chart/templates

helm lint petclinic-chart

# Die fertig ausgefüllten Manifeste, ohne etwas zu installieren (hier nur die ersetzten Zeilen)
helm template petclinic petclinic-chart | grep -E 'replicas:|image:|host:|password:|storage:'
set +x

schritt "Der Wechsel: den von Hand angelegten Stack entfernen, der PVC mit den Daten bleibt"
if kubectl get deployment petclinic > /dev/null 2>&1 && ! helm status petclinic > /dev/null 2>&1; then
  (set -x; kubectl delete -f "$tag2/"; kubectl wait --for=delete pod -l 'app in (petclinic, petclinic-db)' --timeout=120s)
fi

(set -x; helm install petclinic petclinic-chart; kubectl rollout status statefulset/petclinic-db; kubectl rollout status deployment/petclinic)
warte_auf_url http://petclinic.localhost
(set -x; helm list; kubectl get pods)
zeige_url http://petclinic.localhost
