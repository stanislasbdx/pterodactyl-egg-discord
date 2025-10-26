#!/bin/bash

MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`

export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
corepack enable

echo "$ cd /home/container"
cd /home/container

echo "$ yarn install"
yarn install

echo "-- Server started, waiting for ${STARTUP_FILE}..."

${MODIFIED_STARTUP}