#!/usr/bin/env bash
# Walkthrough: kubectl ohne sudo
# Voraussetzung: 01-k3s-installieren.sh
set -euo pipefail

echo "### Ohne sudo und ohne eigene kubeconfig schlägt kubectl fehl: permission denied"
(set -x; env -u KUBECONFIG kubectl get nodes) || true
echo

set -x
# Eigene Kopie der kubeconfig anlegen
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown "$(id -un)": ~/.kube/config
chmod 600 ~/.kube/config
set +x

# KUBECONFIG dauerhaft setzen: das kubectl von k3s liest sonst weiter die Systemdatei
if ! grep -q 'KUBECONFIG=~/.kube/config' ~/.bashrc 2> /dev/null; then
  echo "+ echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc"
  echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc
fi
export KUBECONFIG=~/.kube/config

set -x
# Jetzt funktioniert kubectl ohne sudo
kubectl get nodes
kubectl version
kubectl cluster-info
set +x

echo
echo "Fertig. In dieser Shell noch einmal ausführen (oder eine neue Shell öffnen): source ~/.bashrc"
