ARG NODE_VERSION=lts

FROM node:$NODE_VERSION-alpine

RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl bash git python3 make g++ && \
    npm install -g npm@latest pnpm@latest --allow-scripts=pnpm && \
    adduser --disabled-password --home /home/container container

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /home/container

ENV USER=container HOME=/home/container

USER container

CMD ["entrypoint.sh"]