#!/usr/bin/env bash
# Walkthrough: Ein PersistentVolumeClaim zum Anfassen
# Die Manifeste liegen in k8s-uebungen/.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/k8s-uebungen"

set -x
cat speicher-pvc.yaml
kubectl apply -f speicher-pvc.yaml

# Status Pending: local-path legt den Speicher erst an, wenn ein Pod ihn braucht
kubectl get pvc

cat speicher-pod.yaml
kubectl apply -f speicher-pod.yaml
kubectl wait --for=condition=Ready pod/speicher-test --timeout=120s

# PVC ist Bound, das PV wurde automatisch erzeugt
kubectl get pvc,pv

# Eine Datei in den Speicher schreiben
kubectl exec speicher-test -- sh -c 'echo hallo > /daten/test.txt'

# Pod löschen und neu anlegen
kubectl delete pod speicher-test
kubectl apply -f speicher-pod.yaml
kubectl wait --for=condition=Ready pod/speicher-test --timeout=120s

# Die Datei hat den Pod überlebt
kubectl exec speicher-test -- cat /daten/test.txt

# Aufräumen: mit dem PVC verschwinden auch PV und Daten
kubectl delete pod speicher-test
kubectl delete pvc speicher-test
