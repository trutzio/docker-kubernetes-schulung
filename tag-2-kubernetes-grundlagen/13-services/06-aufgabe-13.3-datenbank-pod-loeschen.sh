#!/usr/bin/env bash
# Lösung 13.3: den Pod der Datenbank löschen. Überleben die Daten?
set -euo pipefail
source "$(dirname "$0")/../lib.sh"

schritt "Vorher: Anzahl der Owner"
(set -x; kubectl exec deployment/petclinic-db -- psql -U petclinic -d petclinic -c 'select count(*) from owners;')

schritt "Datenbank-Pod löschen: das Deployment startet sofort einen neuen"
(set -x; kubectl delete pod -l app=petclinic-db; kubectl rollout status deployment/petclinic-db)
sleep 8

schritt "Die Datenbank ist leer: die Daten lagen im Dateisystem des alten Pods"
(set -x; kubectl exec deployment/petclinic-db -- psql -U petclinic -d petclinic -c '\dt')
zeige_url "http://localhost:8080/owners?lastName="

schritt "App-Pods neu starten: sie legen Tabellen und Beispieldaten wieder an, eigene Owner bleiben verloren"
(set -x; kubectl rollout restart deployment/petclinic; kubectl rollout status deployment/petclinic)
warte_auf_url "http://localhost:8080/owners?lastName="
(set -x; kubectl exec deployment/petclinic-db -- psql -U petclinic -d petclinic -c 'select count(*) from owners;')
zeige_url "http://localhost:8080/owners?lastName="
