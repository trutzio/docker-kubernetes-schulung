#!/usr/bin/env bash
# Walkthrough: Das eigene Image in den Cluster bringen
# Voraussetzung: petclinic:local aus Tag 1 (tag-1-docker/05-image/06-petclinic-image-bauen.sh)
set -euxo pipefail

# Images, die der Cluster kennt: kein petclinic
sudo k3s crictl images

# docker image save schreibt das Image als tar-Archiv, k3s ctr images import liest es in den Image Store des Clusters
docker image save petclinic:local | sudo k3s ctr images import -

# Jetzt ist es da: docker.io/library/petclinic mit dem Tag local
sudo k3s crictl images | grep petclinic
