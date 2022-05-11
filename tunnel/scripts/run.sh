#!/bin/bash

set -e
# Handle a kill signal before the final "exec" command runs
trap "{ exit 0; }" TERM INT

LT_CMD="-h http://${TUNNEL_DOMAIN} -p ${PORT}"

if [[ "${PS_NAME}" != "CHANGEME123" ]]; then
  SUBDOMAIN_OPTION=`echo ${PS_NAME} | tr -d "[:space:]"`
  echo "Use config file: ${SUBDOMAIN_OPTION}"
  lt $LT_CMD -s $SUBDOMAIN_OPTION
else
  echo "Create new connection"
  lt $LT_CMD
fi