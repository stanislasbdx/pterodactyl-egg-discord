#!/usr/bin/env bash
# Idempotent repository bootstrap for Cloud Agents.
# Installs the system tools this repo's Docker/egg workflow needs and
# prepares the projectdefaults npm dependencies used by the CI audit step.
set -euo pipefail

echo "== install: system packages =="
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq
# docker.io: build & run the egg image locally (mirrors docker-build.yml).
# dos2unix + jq: parse/normalize the egg install script (mirrors egg-test.yml).
sudo apt-get install -y -qq docker.io dos2unix jq curl

echo "== install: configure docker for nested VM (vfs storage driver) =="
# Nested overlayfs is unavailable in the Cloud Agent VM, so use the vfs
# storage driver and disable the containerd (overlay) snapshotter.
sudo mkdir -p /etc/docker
echo '{ "storage-driver": "vfs", "features": { "containerd-snapshotter": false } }' \
  | sudo tee /etc/docker/daemon.json >/dev/null

# Let the default user talk to the daemon without sudo once it is running.
sudo groupadd -f docker
sudo usermod -aG docker "$(id -un)" || true

echo "== install: projectdefaults dependencies =="
# Uses the repo's pinned Yarn (Corepack) + lockfile-free default project.
( cd "$(dirname "$0")/../projectdefaults" && yarn install )

echo "== install: done =="
