# Tag 1 Docker: Kapitel 2 Docker Installation

Übersicht über alle Kapitel: [../README.md](../README.md).

Die Skripte zu den Walkthroughs und Lösungen des Kapitels, in der Reihenfolge des Kapitels. Aufruf jeweils aus diesem Ordner, zum Beispiel `./01-linux-docker-io.sh`.

| Skript | Abschnitt im Kapitel | Wo ausführen |
| --- | --- | --- |
| `01-linux-docker-io.sh` | Lokale Installation (Linux), Paket `docker.io` | Debian 13 |
| `02-linux-docker-ce.sh` | Vergleich docker.io oder docker-ce, Paket `docker-ce` | Debian 13 |
| `03-aufgabe-2.1-apt-policy.sh` | Lösung 2.1 | Debian 13 |
| `04-cloud-containerd.sh` | Installation in der Cloud (CoreOS) | Cloud-Server |
| `05-aufgabe-2.2-dockerd-starten.sh` | Lösung 2.2 | Cloud-Server |
| `06-aufgabe-2.3-dockerd-tcp.sh` | Lösung 2.3, dockerd über TCP | **nur** Wegwerf-Cloud-Server |
| `07-docker-context.sh <ip> [user]` | docker context (über SSH) | eigener Rechner |
| `08-docker-api-server.sh [unix\|tcp]` | Docker API, Server-Seite | Debian 13, Terminal 1 |
| `09-docker-api-client.sh [unix\|tcp]` | Docker API, Client-Seite | Debian 13, Terminal 2 |
| `10-container-ist-prozess.sh` | Beweis, dass ein Container ein Prozess ist | überall |
| `11-aufgabe-2.4-docker-info.sh` | Lösung 2.4 | überall |
| `12-petclinic-start.sh` | Journey-Kickoff: Petclinic läuft | überall |
| `13-petclinic-stop.sh` | Journey-Kickoff: Petclinic stoppen | überall |
| `99-aufraeumen.sh [--alle]` | zurück zu `default`, Kontext `local` entfernen (`do` bleibt für das Image-Kapitel, außer mit `--alle`) | eigener Rechner |

Hinweise:

1. Referenzumgebung ist Debian 13 („Trixie"). Von `01` und `02` nur **einen** Weg ausführen; `02` entfernt die Pakete aus den Debian-Quellen vorher. Beide nehmen dich in die Gruppe `docker` auf, danach einmal ab- und wieder anmelden.
2. `06` öffnet auf dem Cloud-Server den Port 2375 unverschlüsselt und unauthentifiziert für das ganze Netzwerk; das Skript fragt vorher nach. `08 tcp` lauscht nur auf `127.0.0.1`. Beide stellen nach Ctrl-C den Normalzustand wieder her.
