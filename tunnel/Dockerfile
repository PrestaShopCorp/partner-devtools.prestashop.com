FROM node:lts-alpine

COPY scripts/run.sh /tmp/run.sh

RUN apk add --no-cache --upgrade bash util-linux nano
RUN npm install -g localtunnel

CMD ["/tmp/run.sh"]
