# Tag 1: Docker

Die Skripte zu den Walkthroughs und Lösungen von Tag 1, pro Kapitel ein Ordner, in der Reihenfolge des Kurses. Kapitel 1 (Docker Architektur) kommt ohne Befehle aus und hat deshalb keinen Ordner.

Referenzumgebung ist Debian 13 („Trixie"); dort sind die Skripte getestet (mit `docker.io` 26.1 und mit `docker-ce` 29).

Aufruf jeweils direkt, zum Beispiel `./03-container/01-lebenszyklus-nginx.sh`. Die Skripte zeigen jeden Befehl an, bevor sie ihn ausführen (Zeilen mit `+`).

So unterscheiden sich die Skripte vom Kapiteltext:

1. Container bekommen feste Namen statt `[container id]`, damit nichts abgetippt werden muss.
2. Interaktive Schritte (`psql`, Shell im Container) laufen mit festen Befehlen durch; den interaktiven Aufruf nennt das Skript als Hinweis.
3. Statt des Browsers prüft `curl` die URL und nennt sie zum Selbst-Anklicken.
4. Schritte, die laut Kapitel fehlschlagen sollen, laufen trotzdem durch; der Kommentar davor sagt, welcher Fehler erwartet wird.
5. Dockerfiles und Compose-Dateien liegen fertig im jeweiligen Ordner.

## Quelltext-Dateien zum Kopieren

Alle Dockerfiles und Compose-Dateien aus dem Kursskript, zeichengleich mit den Codeblöcken dort (die Compose-Dateien tragen zusätzlich eine Kommentarzeile).

| Datei | Kapitel und Abschnitt |
| --- | --- |
| `05-image/eigenes-image/Dockerfile` | Docker Image: Eigenes Image mit Dockerfile |
| `05-image/multi-stage/Dockerfile` | Docker Image: Multi-Stage Build |
| `05-image/petclinic/Dockerfile` | Docker Image: das Petclinic-Image selbst bauen |
| `05-image/petclinic/Dockerfile.cache-freundlich` | Docker Image: Die Änderungs-Schleife, Schritt 7 |
| `07-compose/compose-demo/compose.yaml` | Docker Compose: der erste Service |
| `07-compose/compose-demo/compose.pgadmin.yaml` | Docker Compose: Mehrere Container (vollständige Datei) |
| `07-compose/compose-demo/compose.profil.yaml` | Docker Compose: Compose-Profile (vollständige Datei) |
| `07-compose/petclinic-stack/compose.yaml` | Docker Compose: der komplette Petclinic-Stack |
| `07-compose/petclinic-stack/compose.build.yaml` | Docker Compose: Lösung 7.3 (vollständige Datei) |

Die mehrzeiligen Shell-Befehle des Kurses stecken in den Skripten: die Einrichtung von `docker-ce` in `02-installation/02-linux-docker-ce.sh`, der `dockerd`-Aufruf aus Lösung 2.3 in `02-installation/06-aufgabe-2.3-dockerd-tcp.sh`.

## 02 Docker Installation

Siehe [02-installation/README.md](02-installation/README.md).

## 03 Docker Container

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-lebenszyklus-nginx.sh` | Lebenszyklus am nginx-Container |
| `02-aufgabe-3.1-rm-laufend.sh` | Lösung 3.1 |
| `03-container-run.sh` | docker container run (wartet auf Ctrl-C) |
| `04-aufgabe-3.2-beide-entfernen.sh` | Lösung 3.2 |
| `05-ports.sh` | Ports veröffentlichen |
| `06-aufgabe-3.3-zwei-ports.sh` | Lösung 3.3 |
| `07-exec.sh` | In den Container hinein mit exec |
| `08-aufgabe-3.4-exec-ohne-it.sh` | Lösung 3.4 |
| `09-aufgabe-3.5-neustart.sh` | Lösung 3.5 |
| `10-aufgabe-3.6-postgres-ohne-passwort.sh` | Lösung 3.6 |
| `11-environment-postgres.sh` | Container konfigurieren mit Environment-Variablen |
| `12-aufgabe-3.7-aufraeumen.sh` | Lösung 3.7 |

## 04 Docker Netzwerke

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-weg-ueber-ip.sh` | Der mühsame Weg über die IP-Adresse |
| `02-netzwerk-mit-dns.sh` | Benutzerdefiniertes Netzwerk mit DNS |
| `03-petclinic-trifft-postgres.sh` | Petclinic trifft Postgres |
| `04-dns-netshoot.sh` | Dem eingebauten DNS-Server zuschauen |
| `05-aufgabe-4.1-owner-finden.sh` | Lösung 4.1 |
| `06-aufgabe-4.2-netzwerk-untersuchen.sh` | Lösung 4.2 |
| `07-aufgabe-4.4-aufraeumen.sh` | Lösung 4.4 |

## 05 Docker Image

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-images-verwalten.sh` | Images verwalten |
| `02-image-layer.sh` | Blick unter die Haube: Image Layer |
| `03-eigenes-image.sh` | Eigenes Image mit Dockerfile (`eigenes-image/Dockerfile`) |
| `04-aufgabe-5.2-tabelle-anlegen.sh` | Lösung 5.2 |
| `05-multi-stage.sh` | Multi-Stage Build (`multi-stage/Dockerfile`) |
| `06-petclinic-image-bauen.sh` | Journey-Moment: das Petclinic-Image selbst bauen (`petclinic/Dockerfile`) |
| `07-aufgabe-5.4-build-cache.sh` | Lösung 5.4 |
| `08-aenderungs-schleife.sh` | Die Änderungs-Schleife (`petclinic/Dockerfile.cache-freundlich`) |
| `09-registry-push.sh` | Eigene Registry und Push |
| `10-aufgabe-5.5-docker-hub-push.sh <user>` | Lösung 5.5, braucht `docker login` |
| `11-beweis-cloud-server.sh <user>` | Der Beweis: dein Image läuft überall (SSH-Kontext `do`) |
| `12-beweis-aufraeumen.sh` | Aufräumen nach dem Beweis |

Der Petclinic-Quellcode wird nach `tag-1-docker/spring-petclinic` geklont (nicht im Repository eingecheckt).

## 06 Docker Volumes

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-daten-sterben.sh` | Das Problem: Daten sterben mit dem Container |
| `02-volume-einbinden.sh` | Volumes erzeugen und einbinden |
| `03-aufgabe-6.1-petclinic-mit-volume.sh` | Lösung 6.1, Teil 1 |
| `04-aufgabe-6.1-datenbank-neu-starten.sh` | Lösung 6.1, Teil 2 |
| `05-bind-mount.sh` | Ordner einbinden mit Bind Mounts |
| `06-aufgabe-6.2-datei-einbinden.sh` | Lösung 6.2 |
| `07-aufgabe-6.3-nginx-bind-mount.sh` | Lösung 6.3 |
| `08-volume-driver-sshfs.sh <ip>` | Volume Driver (Vertiefung) |
| `09-aufraeumen.sh` | alle Container des Kapitels stoppen, Port 8080 freigeben |

## 07 Docker Compose

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-erster-service.sh` | Der erste Service (`compose-demo/compose.yaml`) |
| `02-mehrere-container.sh` | Mehrere Container (`compose-demo/compose.pgadmin.yaml`) |
| `03-profile.sh` | Compose-Profile (`compose-demo/compose.profil.yaml`) |
| `04-compose-demo-herunterfahren.sh` | Ports 8080 und 5432 für den Petclinic-Stack freigeben |
| `05-petclinic-stack.sh` | Journey-Moment: der komplette Petclinic-Stack (`petclinic-stack/compose.yaml`) |
| `06-aufgabe-7.2-down-und-volumes.sh` | Lösung 7.2 |
| `07-aufgabe-7.3-build.sh` | Lösung 7.3 (`petclinic-stack/compose.build.yaml`) |
| `08-entwickler-workflow.sh` | Entwickler-Workflow, braucht Java 17 (wartet auf Ctrl-C) |
| `09-aufraeumen.sh` | Zurück zum Compose-Stack |

## 08 Docker Scout

Alle Skripte brauchen das CLI-Plugin `docker scout` und `docker login`.

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-quickview.sh` | Quickview und Lösung 8.1 |
| `02-aufgabe-8.2-sbom.sh` | Lösung 8.2 |
| `03-scout-demo.sh <user>` | Scout-Demo, Schritte 1 bis 7 |
| `04-scout-demo-fix.sh <user>` | Scout-Demo, der Fix |
| `05-aufgabe-8.3-vergleich.sh <user>` | Lösung 8.3 |
| `06-policies-attestations.sh <user>` | Policies, SBOM und Provenance (Vertiefung) |
