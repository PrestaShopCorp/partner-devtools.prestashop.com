FROM mhart/alpine-node

COPY scripts/run.sh /tmp/run.sh

RUN apk add --no-cache --upgrade bash
RUN npm install -g localtunnel

CMD ["/tmp/run.sh"]
