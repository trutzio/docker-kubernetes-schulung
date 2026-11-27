# Tag 3: Kubernetes Betrieb

Skripte und Quelltext-Dateien zu Tag 3, pro Kapitel ein Ordner, nummeriert nach der laufenden Kapitelnummer des Kurses. Kapitel 23 (Fazit) hat keinen Ordner.

Referenzumgebung ist Debian 13 („Trixie") mit k3s und dem Stand von Ende Tag 2. Die Skripte sind dort in dieser Reihenfolge getestet, mit einer Ausnahme: `19-gitops-mit-flux/02-bootstrap-github.sh` braucht einen eigenen GitHub-Account und Token und wurde nicht ausgeführt.

Ab dem Kapitel GitOps mit Flux arbeiten mehrere Skripte in der Arbeitskopie des eigenen GitOps-Repositorys. Sie erwarten sie unter `~/petclinic-gitops`; ein anderer Ort lässt sich vor dem Aufruf mit `export GITOPS_REPO=[pfad]` angeben.

Dozenten-Demos (Argo CD, Azure Key Vault, Cluster in der Cloud) brauchen keine fremden Zugangsdaten in diesem Repository: die Datei zum Azure Key Vault enthält nur Platzhalter.

## Quelltext-Dateien zum Kopieren

Alle Dateien sind aus den Codeblöcken im Kursskript erzeugt.

| Datei | Kapitel und Abschnitt |
| --- | --- |
| `18-helm/petclinic-chart/` | Helm: Petclinic wird zum Chart (`Chart.yaml`, `values.yaml`, sieben Templates) |
| `19-gitops-mit-flux/petclinic.yaml` | GitOps mit Flux: das `HelmRelease`, gehört im Repository nach `clusters/k3s/` |
| `19-gitops-mit-flux/argocd-application.yaml` | GitOps mit Flux: Dozenten-Demo Argo CD |
| `20-cert-manager/kurs-ca.yaml` | cert-manager: Eine eigene Zertifizierungsstelle |
| `20-cert-manager/petclinic-chart/` | cert-manager: der Chart mit TLS im Ingress-Template |
| `21-external-secrets/secretstore.yaml` | External Secrets: SecretStore für OpenBao |
| `21-external-secrets/demo-externalsecret.yaml` | External Secrets: Ein Secret, das dem Speicher folgt |
| `21-external-secrets/petclinic-chart/` | External Secrets: der fertige Chart (ExternalSecret statt Secret, kein Passwort mehr) |
| `21-external-secrets/azure-keyvault-secretstore.yaml` | External Secrets: Dozenten-Demo Azure Key Vault (nur Platzhalter) |
| `22-opentofu/tofu-demo/main.tf` | OpenTofu: Eine Umgebung aus Code |

## 18 Helm

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-helm-installieren.sh` | Helm installieren |
| `02-fremder-chart.sh` | Ein fremder Chart (podinfo) |
| `03-petclinic-chart.sh` | Journey-Moment: Petclinic wird zum Chart |
| `04-aendern-und-zurueckrollen.sh` | Ändern und zurückrollen |
| `05-aufgabe-18.1-zweites-release.sh` | Lösung 18.1 |
| `06-aufgabe-18.2-chart-version.sh` | Lösung 18.2 |

## 19 GitOps mit Flux

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-flux-installieren.sh` | Kommandozeile `flux` installieren |
| `02-bootstrap-github.sh` | Flux mit GitHub verbinden (braucht `GITHUB_USER` und `GITHUB_TOKEN`) |
| `03-petclinic-aus-git.sh` | Journey-Moment: Petclinic kommt aus Git |
| `04-aendern-per-git-push.sh` | Ändern per git push |
| `05-dozenten-demo-argocd.sh` | Dozenten-Demo: Argo CD |
| `06-argocd-aufraeumen.sh` | Argo CD wieder entfernen |
| `07-aufgabe-19.2-service-loeschen.sh` | Lösung 19.2 |

## 20 cert-manager

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-cert-manager-installieren.sh` | cert-manager installieren |
| `02-eigene-ca.sh` | Eine eigene Zertifizierungsstelle |
| `03-https-fuer-petclinic.sh` | Journey-Moment: HTTPS für die Petclinic |
| `04-aufgabe-20.1-zertifikat-ansehen.sh` | Lösung 20.1 |
| `05-aufgabe-20.2-secret-loeschen.sh` | Lösung 20.2 |

## 21 External Secrets

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-openbao-installieren.sh` | OpenBao installieren |
| `02-eso-und-secretstore.sh` | External Secrets Operator und SecretStore |
| `03-secret-folgt-dem-speicher.sh` | Ein Secret, das dem Speicher folgt |
| `04-passwort-aus-git-entfernen.sh` | Journey-Moment: das Passwort verschwindet aus Git |
| `05-aufgabe-21.1-secret-loeschen.sh` | Lösung 21.1 |
| `06-aufgabe-21.2-historie.sh` | Lösung 21.2 |
| `07-aufgabe-21.3-aufraeumen.sh` | Lösung 21.3 |

## 22 OpenTofu

| Skript | Abschnitt im Kapitel |
| --- | --- |
| `01-opentofu-installieren.sh` | OpenTofu installieren |
| `02-umgebung-aus-code.sh` | Eine Umgebung aus Code |
| `03-aendern-abweichung-abbau.sh` | Ändern, Abweichungen und Abbau |
| `04-aufgabe-22.2-ingress-loeschen.sh` | Lösung 22.2 |
