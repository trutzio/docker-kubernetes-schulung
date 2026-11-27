# Gemeinsame Hilfsfunktionen für die Kurs-Skripte von Tag 1.
# Wird von den Skripten eingebunden, nicht direkt ausgeführt.

# Wartet, bis im Log eines Containers ein Text auftaucht (Standard: maximal 180 Sekunden).
# Aufruf: warte_auf_log <container> <text> [sekunden]
warte_auf_log() {
  local container="$1" text="$2" sekunden="${3:-180}" i
  echo "... warte auf '$text' im Log von $container"
  for ((i = 0; i < sekunden; i++)); do
    if docker container logs "$container" 2>&1 | grep -q "$text"; then
      return 0
    fi
    sleep 1
  done
  echo "Zeitüberschreitung: '$text' kam nicht im Log von $container. Prüfe: docker container logs $container" >&2
  return 1
}

# Wartet, bis ein Postgres-Container Verbindungen annimmt.
# Geprüft wird über TCP: beim allerersten Start läuft kurz ein Initialisierungs-Server,
# der nur über den Unix Socket erreichbar ist und gleich wieder herunterfährt.
# Aufruf: warte_auf_postgres <container> [user]
warte_auf_postgres() {
  local container="$1" user="${2:-postgres}" i
  echo "... warte, bis Postgres in $container bereit ist"
  for ((i = 0; i < 60; i++)); do
    if docker container exec "$container" pg_isready -q -h 127.0.0.1 -U "$user" 2> /dev/null; then
      return 0
    fi
    sleep 1
  done
  echo "Zeitüberschreitung: Postgres in $container wurde nicht bereit." >&2
  return 1
}

# Stoppt Container und wartet, bis sie wirklich weg sind
# (mit --rm gestartete Container werden kurz nach dem Stoppen entfernt, nicht sofort).
# Aufruf: stoppe <container> [container ...]
stoppe() {
  local container i
  for container in "$@"; do
    docker container inspect "$container" > /dev/null 2>&1 || continue
    local autoremove
    autoremove="$(docker container inspect --format '{{.HostConfig.AutoRemove}}' "$container")"
    echo "+ docker container stop $container"
    docker container stop "$container" > /dev/null
    if [[ "$autoremove" == true ]]; then
      for ((i = 0; i < 30; i++)); do
        docker container inspect "$container" > /dev/null 2>&1 || break
        sleep 1
      done
    fi
  done
}

# Ersetzt den Browser: ruft eine URL ab und zeigt den HTTP-Status.
# Aufruf: zeige_url <url>
zeige_url() {
  local url="$1"
  if command -v curl > /dev/null; then
    echo "+ curl $url  ->  HTTP $(curl -s -o /dev/null -w '%{http_code}' "$url")"
  fi
  echo "Im Browser: $url"
}

# Überschrift für einen Schritt
schritt() {
  echo
  echo "### $*"
}
