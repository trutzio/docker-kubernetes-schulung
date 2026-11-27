#!/usr/bin/env bash
# Lösung 10.2: der DNS-Server des Clusters im Namespace kube-system
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
# -n gilt nur für diesen einen Befehl
kubectl get pods -n kube-system

# Der DNS-Server ist der Pod coredns-...
kubectl get pods -n kube-system | grep coredns
