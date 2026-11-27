#!/usr/bin/env bash
# Walkthrough: Journey-Moment: HTTPS für die Petclinic
# Das geänderte Template liegt in petclinic-chart/templates/petclinic-ingress.yaml;
# das Skript kopiert es in die Arbeitskopie des GitOps-Repositorys und pusht.
# Voraussetzung: 02-eigene-ca.sh und das Kapitel GitOps mit Flux
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
hier="$(cd "$(dirname "$0")" && pwd)"
pruefe_gitops_repo

set -x
cp "$hier/petclinic-chart/templates/petclinic-ingress.yaml" "$GITOPS_REPO/petclinic-chart/templates/petclinic-ingress.yaml"
cat "$GITOPS_REPO/petclinic-chart/templates/petclinic-ingress.yaml"
set +x

gitops_push "TLS für den Ingress"
echo "... warte auf das Zertifikat"
for ((i = 0; i < 60; i++)); do
  kubectl get certificate petclinic-tls > /dev/null 2>&1 && break
  sleep 2
done
(set -x; kubectl wait certificate/petclinic-tls --for=condition=Ready --timeout=120s; kubectl get certificate; kubectl get secret petclinic-tls)

schritt "HTTPS mit -k (ohne Prüfung des Zertifikats)"
(set -x; curl -sk -o /dev/null -w '%{http_code}\n' https://petclinic.localhost)

schritt "Ohne -k scheitert die Prüfung: curl kennt unsere CA nicht"
(set -x; curl -s -o /dev/null https://petclinic.localhost) || echo "(Zertifikatsfehler, wie erwartet)"

schritt "Mit dem Zertifikat der CA funktioniert es ohne Warnung"
(set -x; kubectl get secret kurs-ca -n cert-manager -o jsonpath='{.data.ca\.crt}' | base64 -d > "$hier/kurs-ca.crt")
(set -x; curl -s --cacert "$hier/kurs-ca.crt" -o /dev/null -w '%{http_code}\n' https://petclinic.localhost)

schritt "Aussteller und Ablaufdatum"
(set -x; curl -kv https://petclinic.localhost 2>&1 | grep -E 'issuer|expire')
