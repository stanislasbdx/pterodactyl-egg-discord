ARG NODE_VERSION=lts

FROM node:$NODE_VERSION-alpine

RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl bash

WORKDIR /home/container

RUN export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN corepack enable

RUN yarn policies set-version
RUN yarn config set nodeLinker node-modules

RUN adduser --disabled-password --home /home/container container

ENV USER=container HOME=/home/container

RUN chown -R container:container /home/container && \
    chmod -R 755 /home/container

USER container

COPY ./entrypoint.sh /home/sbdx/entrypoint.sh

CMD ["/bin/bash", "/home/sbdx/entrypoint.sh"]