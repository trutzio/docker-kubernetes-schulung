#!/usr/bin/env bash
# Lösung 14.1: einen neuen Schlüssel in die ConfigMap aufnehmen
# Das Skript ändert die ConfigMap direkt im Cluster; im Kapitel ergänzt du die Zeile KURS_TAG: "2" in der Datei.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

(set -x; kubectl patch configmap petclinic-config --type merge -p '{"data":{"KURS_TAG":"2"}}')

schritt "Laufende Pods bekommen die Änderung nicht mit"
(set -x; kubectl exec deployment/petclinic -- env | grep KURS_TAG) || echo "(nichts gefunden)"

schritt "Erst ein Neustart der Pods setzt die neue Variable"
(set -x; kubectl rollout restart deployment/petclinic; kubectl rollout status deployment/petclinic)
(set -x; kubectl exec deployment/petclinic -- env | grep KURS_TAG)
