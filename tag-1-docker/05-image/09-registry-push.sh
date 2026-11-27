#!/usr/bin/env bash
# Walkthrough: Eigene Registry und Push
# Voraussetzung: 06-petclinic-image-bauen.sh
set -euxo pipefail

# Eigene Registry als Container auf Port 5000
docker container run -d -p 5000:5000 --name docker-registry registry:2
sleep 2

# Zweiter Name für dasselbe Image, der auf die lokale Registry zeigt
docker tag petclinic:local localhost:5000/petclinic:local

# Beide Namen haben dieselbe Image-Id
docker image ls | grep petclinic

# In die lokale Registry hochladen
docker push localhost:5000/petclinic:local

# Die Registry kennt das Image jetzt
if command -v curl > /dev/null; then
  curl -s http://localhost:5000/v2/_catalog
fi

# Aufräumen: Registry-Container samt seinem Volume und den zweiten Namen entfernen
docker container rm -f -v docker-registry
docker image rm localhost:5000/petclinic:local
