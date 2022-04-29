#!/bin/bash

FILE=/tmp/.config

LT_CMD="-h http://${TUNNEL_DOMAIN} -p ${PORT}"

if [ -s "$FILE" ]; then
  echo "Use config file"
  SUBDOMAIN_OPTION=`cat $FILE | tr -d "[:space:]"`
  lt $LT_CMD -s $SUBDOMAIN_OPTION
else
  echo "Create new connection"
  lt $LT_CMD
fi