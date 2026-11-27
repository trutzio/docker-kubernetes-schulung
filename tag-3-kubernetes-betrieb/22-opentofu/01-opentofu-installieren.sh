#!/usr/bin/env bash
# Walkthrough: OpenTofu installieren (Debian 13)
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
cd "$(mktemp -d)"

set -x
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method deb
rm install-opentofu.sh

tofu version
