#!/usr/bin/env bash
# Lösung 22.2: den Ingress von Hand löschen, tofu plan bemerkt es, tofu apply stellt ihn wieder her
# Das Skript legt die Umgebung zuerst wieder an und baut sie am Ende ab.
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/tofu-demo"

(set -x; tofu apply -auto-approve)
warte_auf_url http://podinfo.localhost

(set -x; kubectl delete ingress podinfo -n tofu-demo)
sleep 3
zeige_url http://podinfo.localhost

schritt "tofu plan: 1 to add"
(set -x; tofu plan | grep -E 'will be created|Plan:')

(set -x; tofu apply -auto-approve)
warte_auf_url http://podinfo.localhost
zeige_url http://podinfo.localhost

(set -x; tofu destroy -auto-approve)
