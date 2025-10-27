ARG NODE_VERSION=lts

FROM node:$NODE_VERSION-alpine

ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl bash && \
    adduser --disabled-password --home /home/container container

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /home/container

RUN corepack enable && \
    yarn policies set-version && \
    yarn config set nodeLinker node-modules

ENV USER=container HOME=/home/container

USER container

CMD ["entrypoint.sh"]