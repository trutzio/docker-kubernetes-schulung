#!/usr/bin/env bash
# Lösung 20.2: das Secret petclinic-tls löschen, cert-manager stellt ein neues Zertifikat aus
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
hier="$(cd "$(dirname "$0")" && pwd)"

(set -x; kubectl delete secret petclinic-tls)
echo "... warte auf das neue Secret"
for ((i = 0; i < 60; i++)); do
  kubectl get secret petclinic-tls > /dev/null 2>&1 && break
  sleep 2
done
(set -x; kubectl get secret petclinic-tls; kubectl wait certificate/petclinic-tls --for=condition=Ready --timeout=120s)
sleep 3
(set -x; curl -s --cacert "$hier/kurs-ca.crt" -o /dev/null -w '%{http_code}\n' https://petclinic.localhost)
