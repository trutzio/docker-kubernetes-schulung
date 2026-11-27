# Gemeinsame Hilfsfunktionen für die Kurs-Skripte von Tag 2.
# Wird von den Skripten eingebunden, nicht direkt ausgeführt.

# kubectl von k3s liest ohne KUBECONFIG die Systemdatei, die nur root lesen darf.
# Falls die Variable in dieser Shell noch nicht gesetzt ist, die eigene Kopie verwenden.
if [[ -z "${KUBECONFIG:-}" && -f "$HOME/.kube/config" ]]; then
  export KUBECONFIG="$HOME/.kube/config"
fi

# Überschrift für einen Schritt
schritt() {
  echo
  echo "### $*"
}

# Ersetzt den Browser: ruft eine URL ab und zeigt den HTTP-Status.
# Aufruf: zeige_url <url>
zeige_url() {
  local url="$1"
  if command -v curl > /dev/null; then
    echo "+ curl $url  ->  HTTP $(curl -s -o /dev/null -m 10 -w '%{http_code}' "$url")"
  fi
  echo "Im Browser: $url"
}

# Wartet, bis eine URL mit HTTP 200 antwortet (Standard: maximal 120 Sekunden).
# Aufruf: warte_auf_url <url> [sekunden]
warte_auf_url() {
  local url="$1" sekunden="${2:-120}" i
  echo "... warte auf $url"
  for ((i = 0; i < sekunden; i++)); do
    if [[ "$(curl -s -o /dev/null -m 3 -w '%{http_code}' "$url")" == 200 ]]; then
      return 0
    fi
    sleep 1
  done
  echo "Zeitüberschreitung: $url antwortet nicht mit HTTP 200." >&2
  return 1
}

# Wartet, bis im Log eines Pods oder Deployments ein Text auftaucht.
# Aufruf: warte_auf_log <pod|deployment/name> <text> [sekunden]
warte_auf_log() {
  local ziel="$1" text="$2" sekunden="${3:-180}" i
  echo "... warte auf '$text' im Log von $ziel"
  for ((i = 0; i < sekunden; i++)); do
    if kubectl logs "$ziel" 2> /dev/null | grep -q "$text"; then
      return 0
    fi
    sleep 1
  done
  echo "Zeitüberschreitung: '$text' kam nicht im Log von $ziel. Prüfe: kubectl logs $ziel" >&2
  return 1
}

# Startet kubectl port-forward im Hintergrund, ruft die URL ab und beendet die Weiterleitung wieder.
# Im Kapitel läuft port-forward im Vordergrund, bis man es mit Ctrl-C beendet.
# kubectl port-forward bricht ab, wenn die App im Pod noch nicht lauscht, deshalb mehrere Versuche.
# Aufruf: mit_port_forward <ziel> <lokal:ziel-port> [pfad]
mit_port_forward() {
  local ziel="$1" ports="$2" pfad="${3:-/}" pid i url
  url="http://localhost:${ports%%:*}$pfad"
  echo "+ kubectl port-forward $ziel $ports   (im Hintergrund, nur für diesen Test)"
  for ((i = 0; i < 30; i++)); do
    kubectl port-forward "$ziel" "$ports" > /dev/null 2>&1 &
    pid=$!
    sleep 2
    if [[ "$(curl -s -o /dev/null -m 5 -w '%{http_code}' "$url")" == 200 ]]; then
      zeige_url "$url"
      kill "$pid" 2> /dev/null || true
      wait "$pid" 2> /dev/null || true
      return 0
    fi
    kill "$pid" 2> /dev/null || true
    wait "$pid" 2> /dev/null || true
    sleep 3
  done
  echo "Die App antwortet nicht unter $url. Prüfe: kubectl get pods und kubectl logs" >&2
  return 1
}

# Wartet, bis ein Pod wirklich gelöscht ist.
# Aufruf: warte_bis_weg <pod>
warte_bis_weg() {
  kubectl wait --for=delete "pod/$1" --timeout=90s > /dev/null 2>&1 || true
}

# Liefert den Namen eines Pods mit dem angegebenen Label, der nicht gerade beendet wird.
# Aufruf: ein_pod <label>     (zum Beispiel: ein_pod app=petclinic)
ein_pod() {
  kubectl get pods -l "$1" \
    -o go-template='{{range .items}}{{if not .metadata.deletionTimestamp}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}' |
    head -n 1
}

# Wartet, bis Spring Boot in allen Petclinic-Pods fertig gestartet ist.
# (Kubernetes hält einen Pod schon für bereit, sobald der Prozess läuft; das beheben Probes an Tag 3.)
warte_auf_petclinic() {
  local pod
  kubectl rollout status deployment/petclinic > /dev/null
  for pod in $(kubectl get pods -l app=petclinic \
    -o go-template='{{range .items}}{{if not .metadata.deletionTimestamp}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}'); do
    warte_auf_log "$pod" 'Started PetClinicApplication'
  done
}
