#!/usr/bin/env bash
# Walkthrough: Dozenten-Demo: Argo CD (Installation und Beispiel-Anwendung)
# Das Manifest liegt in argocd-application.yaml. Aufräumen: 06-argocd-aufraeumen.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")"

set -x
kubectl get namespace argocd > /dev/null 2>&1 || kubectl create namespace argocd
kubectl apply -n argocd --server-side -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml > /dev/null
kubectl -n argocd rollout status deployment/argocd-server --timeout=300s
kubectl -n argocd wait --for=condition=Ready pod --all --timeout=300s
kubectl -n argocd get pods

cat argocd-application.yaml
kubectl apply -f argocd-application.yaml
set +x

echo "... warte, bis Argo CD die Anwendung eingespielt hat"
kubectl -n argocd wait application/guestbook --for=jsonpath='{.status.sync.status}'=Synced --timeout=180s > /dev/null
(set -x; kubectl -n argocd get applications; kubectl -n argocd-demo get pods)

echo
echo "Weboberfläche: in einer zweiten Shell"
echo "  kubectl -n argocd port-forward svc/argocd-server 8443:443"
echo "dann https://localhost:8443, Benutzer admin, Passwort:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
echo
