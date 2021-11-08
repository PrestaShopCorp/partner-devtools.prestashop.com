#!/bin/bash

FILE=/tmp/.config

LT_CMD="--port ${PORT} --host http://${TUNNEL_DOMAIN}"

if [ -s "$FILE" ]; then
  SUBDOMAIN_OPTION=`cat $FILE | tr -d "[:space:]"`
  node /usr/bin/lt $LT_CMD --subdomain $SUBDOMAIN_OPTION
else
  node /usr/bin/lt $LT_CMD
fi