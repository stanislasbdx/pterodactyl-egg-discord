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

COPY --chown=container:container ./entrypoint.sh /home/container/entrypoint.sh
RUN chmod +x /home/container/entrypoint.sh

USER container

CMD ["/home/container/entrypoint.sh"]