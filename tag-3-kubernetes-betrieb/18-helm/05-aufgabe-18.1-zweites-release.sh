#!/usr/bin/env bash
# Lösung 18.1: derselbe Chart als zweites Release in einem eigenen Namespace
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")"

set -x
helm install petclinic-test petclinic-chart --namespace test --create-namespace \
  --set replicaCount=1 --set ingress.host=test.localhost
kubectl -n test rollout status statefulset/petclinic-db
kubectl -n test rollout status deployment/petclinic
kubectl get pods -n test
set +x

warte_auf_url http://test.localhost
zeige_url http://test.localhost
zeige_url http://petclinic.localhost

# Aufräumen: mit dem Namespace verschwindet auch der PVC der Test-Datenbank
(set -x; helm uninstall petclinic-test -n test; kubectl delete namespace test)
