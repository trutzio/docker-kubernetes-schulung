#!/usr/bin/env bash
# Walkthrough: Ein Service für Petclinic
# Das Manifest liegt in petclinic-service-clusterip.yaml (im Kapitel: petclinic-service.yaml, erster Stand).
# Voraussetzung: das Deployment petclinic aus dem Kapitel Deployments und ReplicaSets
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")"

set -x
cat petclinic-service-clusterip.yaml
kubectl apply -f petclinic-service-clusterip.yaml

# Die feste virtuelle IP des Service
kubectl get services

# Wohin der Service verteilt: die IP-Adressen der drei Petclinic-Pods
kubectl get endpointslices
set +x

schritt "Namensauflösung sichtbar machen: A-Record auf die CLUSTER-IP, SERVER ist der DNS-Server des Clusters"
(set -x; kubectl run netshoot --rm -i --restart=Never --image=nicolaka/netshoot -- dig petclinic.petclinic.svc.cluster.local < /dev/null)

schritt "Die Petclinic aus dem Cluster heraus über den Servicenamen aufrufen"
warte_auf_petclinic
(set -x; kubectl run netshoot --rm -i --restart=Never --image=nicolaka/netshoot -- curl -s -o /dev/null -w '%{http_code}\n' http://petclinic:8080 < /dev/null)
