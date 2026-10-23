#!/bin/bash

MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")

echo "$ cd /home/container"
cd /home/container

# Si le projet réclame Yarn, on laisse pnpm router via dlx ou son shim
if [ -f "yarn.lock" ]; then
    echo "$ pnpm dlx yarn install"
    pnpm dlx yarn install
elif [ -f "pnpm-lock.yaml" ]; then
    echo "$ pnpm install --frozen-lockfile"
    pnpm install --frozen-lockfile
else
    echo "$ pnpm install --manage-package-manager-versions=false"
    pnpm install --manage-package-manager-versions=false
fi

echo "-- Server started, waiting for ${STARTUP_FILE}..."

${MODIFIED_STARTUP}