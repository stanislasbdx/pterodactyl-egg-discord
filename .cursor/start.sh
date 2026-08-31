#!/usr/bin/env bash
# Per-boot startup: bring up the Docker daemon so the agent can build and
# test the egg image. Idempotent and safe to re-run.
set -euo pipefail

DOCKERD_LOG=/tmp/dockerd.log

if sudo docker info >/dev/null 2>&1; then
  echo "start: docker daemon already running"
else
  echo "start: launching dockerd (log: ${DOCKERD_LOG})"
  # Clean any stale socket/log from a previous boot, then start detached.
  sudo rm -f /var/run/docker.sock /var/run/docker.pid "${DOCKERD_LOG}" 2>/dev/null || true
  sudo bash -c "setsid dockerd >'${DOCKERD_LOG}' 2>&1 &"

  echo "start: waiting for docker daemon to become ready"
  for i in $(seq 1 30); do
    if sudo docker info >/dev/null 2>&1; then
      break
    fi
    sleep 1
  done

  if ! sudo docker info >/dev/null 2>&1; then
    echo "start: ERROR - docker daemon did not become ready" >&2
    tail -n 20 "${DOCKERD_LOG}" >&2 || true
    exit 1
  fi
fi

# Allow the non-root agent user to use docker without sudo this session.
sudo chmod 666 /var/run/docker.sock 2>/dev/null || true

echo "start: docker ready -> $(sudo docker --version)"
