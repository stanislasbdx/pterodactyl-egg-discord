ARG NODE_VERSION=lts

FROM node:$NODE_VERSION-alpine

ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0Na

RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl bash && \
    adduser --disabled-password --home /home/container container

WORKDIR /home/container

RUN corepack enable && \
    yarn policies set-version && \
    yarn config set nodeLinker node-modules

ENV USER=container HOME=/home/container

RUN chown -R container:container /home/container && \
    chmod -R 755 /home/container

USER container

COPY ./entrypoint.sh /home/container/entrypoint.sh

CMD ["/bin/bash", "/home/container/entrypoint.sh"]