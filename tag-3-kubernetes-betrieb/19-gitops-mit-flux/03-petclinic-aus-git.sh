#!/usr/bin/env bash
# Walkthrough: Journey-Moment: Petclinic kommt aus Git
# Voraussetzung: 02-bootstrap-github.sh und die Arbeitskopie des Repositorys unter ~/petclinic-gitops
# (anderer Ort: GITOPS_REPO setzen). Das Skript kopiert den Chart aus 18-helm und die Datei petclinic.yaml hinein.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
hier="$(cd "$(dirname "$0")" && pwd)"
pruefe_gitops_repo

set -x
cp -r "$hier/../18-helm/petclinic-chart" "$GITOPS_REPO/"
mkdir -p "$GITOPS_REPO/clusters/k3s"
cp "$hier/petclinic.yaml" "$GITOPS_REPO/clusters/k3s/petclinic.yaml"
cat "$GITOPS_REPO/clusters/k3s/petclinic.yaml"
set +x

schritt "Das von Hand installierte Release entfernen: ab jetzt ist Flux zuständig"
if helm status petclinic > /dev/null 2>&1 && ! kubectl get helmrelease petclinic > /dev/null 2>&1; then
  (set -x; helm uninstall petclinic; kubectl wait --for=delete pod -l 'app in (petclinic, petclinic-db)' --timeout=120s)
fi

gitops_push "Petclinic-Chart und HelmRelease"
warte_auf_helmrelease

(set -x; flux get helmreleases -A; kubectl rollout status deployment/petclinic; kubectl get pods)
warte_auf_url http://petclinic.localhost
zeige_url http://petclinic.localhost
