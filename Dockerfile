ARG NODE_VERSION=lts

FROM node:$NODE_VERSION-alpine

ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0Na

RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl bash && \
    adduser --disabled-password --home /home/sbdx container

WORKDIR /home/container

RUN corepack enable && \
    yarn policies set-version && \
    yarn config set nodeLinker node-modules

ENV USER=container HOME=/home/sbdx

RUN chown -R container:container /home/container && \
    chmod -R 755 /home/sbdx

USER container

COPY ./entrypoint.sh /home/sbdx/entrypoint.sh

CMD ["/bin/bash", "/home/sbdx/entrypoint.sh"]