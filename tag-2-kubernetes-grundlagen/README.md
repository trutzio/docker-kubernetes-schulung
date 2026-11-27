# Tag 2: Kubernetes Grundlagen

Skripte und Manifeste zu Tag 2, pro Kapitel ein Ordner, nummeriert nach der laufenden Kapitelnummer des Kurses. Kapitel 9 (Kubernetes Architektur) kommt ohne Befehle aus und hat deshalb keinen Ordner.

Referenzumgebung ist Debian 13 („Trixie") mit k3s. Die Skripte sind dort in dieser Reihenfolge getestet, von der Installation von k3s bis zum fertigen Stack.

Aufruf jeweils direkt, zum Beispiel `./11-pods/01-erster-pod.sh`. Die Skripte zeigen jeden Befehl an, bevor sie ihn ausführen (Zeilen mit `+`).

So unterscheiden sich die Skripte vom Kapiteltext:

1. `kubectl port-forward` läuft im Kapitel im Vordergrund; die Skripte starten es kurz im Hintergrund, prüfen die URL mit `curl` und beenden es wieder.
2. Wo das Kapitel einen Pod-Namen verlangt (`[pod name]`), sucht das Skript sich selbst einen aus.
3. Schritte, die laut Kapitel fehlschlagen sollen, laufen trotzdem durch; der Kommentar davor sagt, welcher Fehler erwartet wird.
4. Wo das Kapitel eine Datei schrittweise ändert, liegt pro Kapitel der Stand am Kapitelende im Ordner `petclinic-k8s`.

## Quelltext-Dateien zum Kopieren

Alle Manifeste sind zeichengleich mit den Codeblöcken im Kursskript.

| Datei | Kapitel und Abschnitt |
| --- | --- |
| `11-pods/k8s-uebungen/petclinic-pod.yaml` | Pods: Petclinic läuft im Cluster |
| `11-pods/k8s-uebungen/petclinic-absturz-pod.yaml` | Pods: Wenn ein Pod abstürzt |
| `11-pods/k8s-uebungen/petclinic-absturz-never-pod.yaml` | Pods: Lösung 11.3 (vollständige Datei) |
| `12-deployments-und-replicasets/petclinic-k8s/petclinic-deployment.yaml` | Deployments: Petclinic als Deployment |
| `13-services/petclinic-service-clusterip.yaml` | Services: Ein Service für Petclinic (erster Stand von `petclinic-service.yaml`) |
| `13-services/petclinic-k8s/petclinic-db-deployment.yaml` | Services: Petclinic trifft Postgres |
| `13-services/petclinic-k8s/petclinic-db-service.yaml` | Services: Petclinic trifft Postgres |
| `13-services/petclinic-k8s/petclinic-deployment.yaml` | Services: Petclinic trifft Postgres (mit `env`) |
| `13-services/petclinic-k8s/petclinic-service.yaml` | Services: Von außen erreichbar (`type: LoadBalancer`) |
| `14-configmaps-und-secrets/petclinic-k8s/` | ConfigMaps und Secrets: der Stack aus sechs Dateien |
| `15-persistent-volumes-und-statefulsets/k8s-uebungen/` | Persistent Volumes: PVC und Pod zum Anfassen |
| `15-persistent-volumes-und-statefulsets/petclinic-k8s/` | Persistent Volumes: Stand am Kapitelende (StatefulSet statt Deployment für die Datenbank) |
| `16-probes-und-ressourcen/petclinic-deployment-nur-probes.yaml` | Probes und Ressourcen: Probes für die Petclinic (Stand vor `resources`) |
| `16-probes-und-ressourcen/petclinic-k8s/` | Probes und Ressourcen: Stand am Kapitelende (mit Lösung 16.1) |
| `17-ingress/petclinic-k8s/` | Ingress: der fertige Stack aus sieben Dateien, das Ziel von Tag 2 |

Der fertige Stack startet mit `kubectl apply -f 17-ingress/petclinic-k8s/`.

## 10 Installation k3s und kubectl

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-k3s-installieren.sh` | k3s installieren |
| `02-kubectl-ohne-sudo.sh` | kubectl ohne sudo (danach `source ~/.bashrc` oder neue Shell) |
| `03-rundgang.sh` | Ein erster Rundgang durch den Cluster |
| `04-namespace.sh` | Ein eigener Namespace |
| `05-aufgabe-10.1-versionen.sh` | Lösung 10.1 |
| `06-aufgabe-10.2-dns-server.sh` | Lösung 10.2 |
| `07-aufgabe-10.3-cluster-stoppen.sh` | Lösung 10.3 |

## 11 Pods

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-erster-pod.sh` | Der erste Pod |
| `02-image-importieren.sh` | Das eigene Image in den Cluster bringen (braucht `petclinic:local` von Tag 1) |
| `03-petclinic-pod.sh` | Journey-Moment: Petclinic läuft im Cluster |
| `04-pod-absturz.sh` | Wenn ein Pod abstürzt |
| `05-aufgabe-11.1-pod-loeschen.sh` | Lösung 11.1 |
| `06-aufgabe-11.2-pod-ip.sh` | Lösung 11.2 |
| `07-aufgabe-11.3-restart-never.sh` | Lösung 11.3 |

## 12 Deployments und ReplicaSets

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-deployment.sh` | Petclinic als Deployment |
| `02-selbstheilung-und-skalierung.sh` | Selbstheilung und Skalierung |
| `03-rolling-update.sh` | Rolling Update (braucht `tag-1-docker/spring-petclinic` von Tag 1) |
| `04-aufgabe-12.1-pod-ips.sh` | Lösung 12.1 |
| `05-aufgabe-12.2-kaputtes-update.sh` | Lösung 12.2 |
| `06-aufgabe-12.3-loeschen-und-anlegen.sh` | Lösung 12.3 |

## 13 Services

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-service.sh` | Ein Service für Petclinic |
| `02-petclinic-trifft-postgres.sh` | Journey-Moment: Petclinic trifft Postgres |
| `03-von-aussen-erreichbar.sh` | Von außen erreichbar |
| `04-aufgabe-13.1-owner-finden.sh` | Lösung 13.1 |
| `05-aufgabe-13.2-service-bei-der-arbeit.sh` | Lösung 13.2 |
| `06-aufgabe-13.3-datenbank-pod-loeschen.sh` | Lösung 13.3 |

## 14 ConfigMaps und Secrets

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-configmap.sh` | Einstellungen in die ConfigMap |
| `02-secret.sh` | Das Passwort ins Secret |
| `03-deployments-umstellen.sh` | Die Deployments umstellen |
| `04-der-ganze-stack.sh` | Journey-Moment: der ganze Stack mit einem Befehl |
| `05-aufgabe-14.1-configmap-aendern.sh` | Lösung 14.1 |
| `06-aufgabe-14.2-secret-ohne-yaml.sh` | Lösung 14.2 |

## 15 Persistent Volumes und StatefulSets

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-pvc-zum-anfassen.sh` | Ein PersistentVolumeClaim zum Anfassen |
| `02-postgres-statefulset.sh` | Journey-Moment: Postgres zieht ins StatefulSet |
| `03-aufgabe-15.1-owner-ueberlebt.sh` | Lösung 15.1 |
| `04-aufgabe-15.2-wo-liegen-die-daten.sh` | Lösung 15.2 |
| `05-aufgabe-15.3-statefulset-loeschen.sh` | Lösung 15.3 |

## 16 Probes und Ressourcen

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-probes.sh` | Probes für die Petclinic |
| `02-ressourcen.sh` | Ressourcen festlegen |
| `03-aufgabe-16.1-datenbank-probe.sh` | Lösung 16.1 |
| `04-aufgabe-16.2-zu-kleines-limit.sh` | Lösung 16.2 |

## 17 Ingress

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-hostname.sh` | Petclinic bekommt einen Hostnamen |
| `02-zwei-anwendungen.sh` | Zwei Anwendungen, ein Eingang |
| `03-aufgabe-17.1-host-header.sh` | Lösung 17.1 |
| `04-aufgabe-17.2-stack-neu-anlegen.sh` | Lösung 17.2 |
