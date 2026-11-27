#!/usr/bin/env bash
# Walkthrough: Probes für die Petclinic
# Das Manifest liegt in petclinic-deployment-nur-probes.yaml (Stand nach diesem Walkthrough, noch ohne resources).
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")"

schritt "Die Endpunkte von Spring Boot"
(set -x; curl -s http://localhost:8080/actuator/health/readiness; echo; curl -s http://localhost:8080/actuator/health/liveness; echo)

(set -x; cat petclinic-deployment-nur-probes.yaml; kubectl apply -f petclinic-deployment-nur-probes.yaml)

schritt "Zuschauen: neue Pods stehen auf 0/1, bis Spring Boot antwortet; erst dann geht ein alter"
(set -x; timeout 45 kubectl get pods -w) || true
(set -x; kubectl rollout status deployment/petclinic)

schritt "Die drei Probes im Pod"
pod="$(ein_pod app=petclinic)"
(set -x; kubectl describe pod "$pod" | grep -E 'Liveness|Readiness|Startup')
