FROM node:lts-alpine

COPY scripts/run.sh /tmp/run.sh
COPY .config /tmp/.config

RUN apk add --no-cache --upgrade bash util-linux nano
RUN npm install -g localtunnel

CMD ["bash", "/tmp/run.sh"]
