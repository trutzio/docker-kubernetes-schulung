#!/usr/bin/env bash
# Walkthrough: Ein eigener Namespace
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
kubectl get namespaces

# Eigener Namespace für die Kurs-App (falls noch nicht vorhanden)
kubectl get namespace petclinic > /dev/null 2>&1 || kubectl create namespace petclinic

# Zum Standard machen: alle folgenden Befehle beziehen sich auf petclinic
kubectl config set-context --current --namespace petclinic

# Spalte NAMESPACE
kubectl config get-contexts

# Der Arbeitsbereich ist leer
kubectl get pods
