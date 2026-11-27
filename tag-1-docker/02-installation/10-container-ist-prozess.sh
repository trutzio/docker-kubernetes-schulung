#!/usr/bin/env bash
# Walkthrough: Beweis, dass ein Container ein Prozess ist
set -euxo pipefail

# nginx-Container starten
docker container run -d --name archtest nginx:latest
sleep 2

# Prozesse des Containers aus Sicht des Hosts: nginx mit ganz normalen Host-PIDs
docker container top archtest

# Im Container hat nginx die PID 1: das ist der PID-Namespace in Aktion
docker container exec archtest cat /proc/1/comm

# Auf einem Linux-Host stehen dieselben Prozesse direkt in der Prozessliste
# (auf Docker Desktop laufen sie in der kleinen Linux-VM, die Ausgabe bleibt dann leer)
ps aux | grep '[n]ginx' || true

# Aufräumen
docker container rm -f archtest
