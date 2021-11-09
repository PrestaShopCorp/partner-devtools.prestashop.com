#!/bin/bash

FILE=/tmp/.config

LT_CMD="--port ${PORT} --host http://${TUNNEL_DOMAIN}"

if [ -s "$FILE" ]; then
  SUBDOMAIN_OPTION=`cat $FILE | tr -d "[:space:]"`
  lt $LT_CMD --subdomain $SUBDOMAIN_OPTION
else
  lt $LT_CMD
fi