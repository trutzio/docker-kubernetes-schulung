#!/usr/bin/env bash
# Lösung 2.4: Die frische Installation mit docker info erkunden
set -euxo pipefail

# Alle Angaben in einem Rutsch
docker info

# Gefiltert: Anzahl Container und Images, containerd-Version, cgroup-Version
docker info | grep -i -E 'containers|images|containerd version|cgroup'

# Image Store: overlay2 = klassischer Store von dockerd,
# overlayfs mit driver-type io.containerd.snapshotter.v1 = containerd image store
docker info | grep -i -A 1 'storage driver'
