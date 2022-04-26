#!/bin/bash

FILE=/tmp/.config

LT_CMD="--port ${PORT} --host http://${TUNNEL_DOMAIN}"

if [ -s "$FILE" ]; then
  echo "Use config file"
  SUBDOMAIN_OPTION=`cat $FILE | tr -d "[:space:]"`
  lt $LT_CMD --subdomain $SUBDOMAIN_OPTION
else
  echo "Create new connection"
  lt $LT_CMD
fi