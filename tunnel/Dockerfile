FROM node:lts-alpine

COPY scripts/run.sh /tmp/run.sh
# ADD .config* /tmp/.config

RUN apk add --no-cache --upgrade bash util-linux nano \
  && npm install -g localtunnel

CMD ["bash", "/tmp/run.sh"]
