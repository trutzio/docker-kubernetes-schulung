# Gemeinsame Hilfsfunktionen für die Kurs-Skripte von Tag 3.
# Wird von den Skripten eingebunden, nicht direkt ausgeführt.

# Die Hilfsfunktionen von Tag 2 gelten weiter (kubeconfig, zeige_url, warte_auf_url, schritt, ...)
source "$(dirname "${BASH_SOURCE[0]}")/../tag-2-kubernetes-grundlagen/lib.sh"

# Arbeitskopie des eigenen GitOps-Repositorys (Kapitel GitOps mit Flux).
# Anderer Ort: vor dem Aufruf GITOPS_REPO setzen.
GITOPS_REPO="${GITOPS_REPO:-$HOME/petclinic-gitops}"

# Prüft, ob die Arbeitskopie des GitOps-Repositorys vorhanden ist.
pruefe_gitops_repo() {
  if [[ ! -d "$GITOPS_REPO/.git" ]]; then
    echo "Die Arbeitskopie des GitOps-Repositorys fehlt: $GITOPS_REPO" >&2
    echo "Zuerst das Repository klonen (Kapitel GitOps mit Flux) oder GITOPS_REPO setzen." >&2
    return 1
  fi
}

# Committet alle Änderungen in der Arbeitskopie, pusht sie und stößt den Abgleich von Flux an.
# Aufruf: gitops_push "<commit-nachricht>"
gitops_push() {
  (
    cd "$GITOPS_REPO"
    set -x
    git add -A
    git commit -m "$1"
    git push origin HEAD
    flux reconcile kustomization flux-system --with-source
  )
}

# Wartet, bis das HelmRelease petclinic von Flux fertig eingespielt ist.
warte_auf_helmrelease() {
  echo "... warte auf das HelmRelease petclinic"
  kubectl wait helmrelease/petclinic -n petclinic --for=condition=Ready --timeout=300s > /dev/null
}
