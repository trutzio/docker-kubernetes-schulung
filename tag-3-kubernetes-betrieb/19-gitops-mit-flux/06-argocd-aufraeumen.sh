#!/usr/bin/env bash
# Walkthrough: Dozenten-Demo: Argo CD (Aufräumen)
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")"

set -x
kubectl delete -f argocd-application.yaml --ignore-not-found
kubectl delete namespace argocd argocd-demo --ignore-not-found
