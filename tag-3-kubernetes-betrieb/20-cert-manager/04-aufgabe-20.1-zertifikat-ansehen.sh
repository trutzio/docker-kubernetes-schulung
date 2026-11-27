#!/usr/bin/env bash
# Lösung 20.1: Ablauf und geplante Erneuerung des Zertifikats
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

set -x
kubectl describe certificate petclinic-tls | grep -E 'Not After|Not Before|Renewal Time'
