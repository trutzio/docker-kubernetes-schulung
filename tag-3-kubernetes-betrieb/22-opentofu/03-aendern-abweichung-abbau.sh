#!/usr/bin/env bash
# Walkthrough: Ändern, Abweichungen und Abbau
# Voraussetzung: 02-umgebung-aus-code.sh
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(dirname "$0")/tofu-demo"

schritt "Die Variable neu setzen: zwei Änderungen, alles andere bleibt unberührt"
(set -x; tofu apply -auto-approve -var 'gruss=Willkommen im Kurs')
(set -x; kubectl -n tofu-demo rollout status deployment/podinfo)
sleep 5
command -v curl > /dev/null && curl -s http://podinfo.localhost | grep message

schritt "Eine Änderung an OpenTofu vorbei"
(set -x; kubectl -n tofu-demo patch configmap gruss --type merge -p '{"data":{"GRUSS":"von Hand geändert"}}')

schritt "tofu plan bemerkt die Abweichung"
(set -x; tofu plan -var 'gruss=Willkommen im Kurs')

schritt "tofu apply stellt den Stand aus dem Code wieder her"
(set -x; tofu apply -auto-approve -var 'gruss=Willkommen im Kurs'; kubectl -n tofu-demo get configmap gruss -o jsonpath='{.data.GRUSS}'; echo)

schritt "Alles wieder abbauen"
(set -x; tofu destroy -auto-approve)
(set -x; kubectl get namespace tofu-demo) || true
