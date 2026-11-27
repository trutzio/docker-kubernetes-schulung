#!/usr/bin/env bash
# Walkthrough: Ändern per git push
# Voraussetzung: 03-petclinic-aus-git.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
pruefe_gitops_repo
datei="$GITOPS_REPO/clusters/k3s/petclinic.yaml"

schritt "Zwei Replicas, per Commit"
sed 's/^    replicaCount: 3$/    replicaCount: 2/' "$datei" > "$datei.neu" && mv "$datei.neu" "$datei"
grep replicaCount "$datei"
gitops_push "zwei Replicas"
sleep 5
warte_auf_helmrelease
(set -x; kubectl rollout status deployment/petclinic; kubectl get deployment petclinic)

schritt "Gegenprobe von Hand: Flux dreht die Änderung zurück"
(set -x; kubectl scale deployment/petclinic --replicas=5; kubectl get deployment petclinic)
(set -x; flux reconcile helmrelease petclinic -n petclinic)
sleep 15
(set -x; kubectl get deployment petclinic)

schritt "Das Änderungsprotokoll des Clusters"
(cd "$GITOPS_REPO" && set -x && git log --oneline | sed -n '1,5p')
(set -x; flux events -n petclinic | tail -n 5)
