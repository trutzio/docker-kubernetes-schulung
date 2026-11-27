#!/usr/bin/env bash
# Walkthrough: Flux installieren und mit GitHub verbinden (Schritte 5 bis 7: bootstrap)
# Voraussetzung: eigener GitHub-Account und ein Token mit dem Recht "repo".
# Vor dem Aufruf in derselben Shell setzen:
#   export GITHUB_USER=[dein-github-user]
#   export GITHUB_TOKEN=[dein-token]
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

if [[ -z "${GITHUB_USER:-}" || -z "${GITHUB_TOKEN:-}" ]]; then
  echo "Bitte zuerst GITHUB_USER und GITHUB_TOKEN setzen (siehe Kommentar im Skript)." >&2
  exit 1
fi

set -x
# Legt das Repository petclinic-gitops an, installiert die Flux-Controller und verbindet beides
flux bootstrap github --owner="$GITHUB_USER" --repository=petclinic-gitops \
  --branch=main --path=clusters/k3s --personal

kubectl get pods -n flux-system
flux get sources git
flux get kustomizations
set +x

echo
echo "Jetzt das Repository klonen (als Passwort den Token angeben):"
echo "  git clone https://github.com/$GITHUB_USER/petclinic-gitops.git ~/petclinic-gitops"
