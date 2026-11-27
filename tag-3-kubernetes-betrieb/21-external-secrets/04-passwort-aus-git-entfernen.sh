#!/usr/bin/env bash
# Walkthrough: Journey-Moment: das Passwort verschwindet aus Git
# Der geänderte Chart liegt in petclinic-chart/ (ExternalSecret statt Secret, values.yaml ohne Passwort);
# das Skript überträgt die Änderungen in die Arbeitskopie des GitOps-Repositorys und pusht.
# Voraussetzung: 02-eso-und-secretstore.sh und das Kapitel GitOps mit Flux
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
hier="$(cd "$(dirname "$0")" && pwd)"
pruefe_gitops_repo

set -x
rm -f "$GITOPS_REPO/petclinic-chart/templates/petclinic-secret.yaml"
cp "$hier/petclinic-chart/templates/petclinic-externalsecret.yaml" "$GITOPS_REPO/petclinic-chart/templates/"
cp "$hier/petclinic-chart/values.yaml" "$GITOPS_REPO/petclinic-chart/values.yaml"
cat "$GITOPS_REPO/petclinic-chart/templates/petclinic-externalsecret.yaml" "$GITOPS_REPO/petclinic-chart/values.yaml"
set +x

gitops_push "Passwort aus OpenBao"
echo "... warte auf das ExternalSecret"
for ((i = 0; i < 60; i++)); do
  kubectl get externalsecret petclinic-secret > /dev/null 2>&1 && break
  sleep 2
done
(set -x; kubectl wait externalsecret/petclinic-secret --for=condition=Ready --timeout=120s; kubectl get externalsecret,secret)

schritt "Der neue Eigentümer des Secrets"
(set -x; kubectl get secret petclinic-secret -o jsonpath='{.metadata.ownerReferences[0].kind}'; echo)
warte_auf_url "http://petclinic.localhost/owners?lastName="
zeige_url http://petclinic.localhost
