#!/usr/bin/env bash
# Walkthrough: Journey-Kickoff: Petclinic wieder stoppen
set -euxo pipefail

# Die Option --rm beim Start entfernt den Container beim Stoppen gleich mit
docker container stop petclinic
