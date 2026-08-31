#!/usr/bin/env bash
# End-to-end verification of the dev environment. Mirrors the repo's CI.
set -uo pipefail
cd "$(dirname "$0")/.."
FAIL=0
line() { printf '\n############################################################\n# %s\n############################################################\n' "$1"; }

# Ensure the Docker daemon is up (normally started by .cursor/start.sh on boot).
if ! docker info >/dev/null 2>&1; then
  echo "verify: docker daemon not running, invoking .cursor/start.sh"
  bash "$(dirname "$0")/start.sh"
fi

line "0. Toolchain"
echo "docker : $(docker --version 2>&1)"
echo "node   : $(node --version 2>&1)"
echo "yarn   : $(yarn --version 2>&1)"
echo "jq     : $(jq --version 2>&1)"
echo "dos2unix: $(dos2unix --version 2>&1 | head -1)"

line "1. Build the egg Docker image (mirrors docker-build.yml)"
docker build -t 5140/discord-egg:latest --build-arg NODE_VERSION=lts . >/tmp/build.log 2>&1 \
  && echo "PASS: image built ($(docker images -q 5140/discord-egg:latest))" \
  || { echo "FAIL: build"; tail -20 /tmp/build.log; FAIL=1; }

line "2. Docker image runtime test (mirrors docker-build.yml)"
T=$(mktemp -d); echo 'console.log("OK")' > "$T/index.js"
out=$(docker run --rm -v "$T/index.js":/home/container/index.js -e STARTUP_FILE="index.js" -e STARTUP="node index.js" 5140/discord-egg:latest 2>&1)
echo "$out"
if [[ "$out" == *"-- Server started, waiting for index.js..."* && "$out" == *"OK"* ]]; then
  echo "PASS: startup message and bot output present"; else echo "FAIL: runtime"; FAIL=1; fi
rm -rf "$T"

line "3. Egg installation script test (mirrors egg-test.yml)"
W=$(mktemp -d); mkdir -p "$W/server"
jq -r '.scripts.installation.script' egg-discordjs.json | dos2unix > "$W/install_script.sh"
CIMG=$(jq -r '.scripts.installation.container' egg-discordjs.json)
RURL=$(jq -r '.variables[] | select(.env_variable=="REPO_URL") | .default_value' egg-discordjs.json)
docker run --rm -v "$W/install_script.sh":/mnt/install_script.sh -v "$W/server":/mnt/server \
  -e REPO_URL="$RURL" "$CIMG" bash /mnt/install_script.sh >/tmp/egg.log 2>&1
if [ -f "$W/server/index.js" ] && [ -f "$W/server/package.json" ] \
   && grep -q "Server installed, you can upload your files !" "$W/server/index.js"; then
  echo "PASS: index.js + package.json downloaded with expected content"; else echo "FAIL: egg install"; cat /tmp/egg.log; FAIL=1; fi
rm -rf "$W"

line "4. Egg JSON validation"
jq empty egg-discordjs.json && echo "PASS: valid JSON | name=$(jq -r .name egg-discordjs.json) | startup=$(jq -r .startup egg-discordjs.json)" || { echo "FAIL: egg json"; FAIL=1; }

line "RESULT"
[ "$FAIL" -eq 0 ] && echo "ALL CHECKS PASSED" || echo "SOME CHECKS FAILED"
exit $FAIL
