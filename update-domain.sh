#!/bin/bash

source ./scripts/utils/index.sh

# setting up env file
ENV_FILE=.env
RBM_NAME=$(read_var RBM_NAME $ENV_FILE)
TUNNEL_DOMAIN=$(read_var TUNNEL_DOMAIN $ENV_FILE)
SUBDOMAIN_NAME=`docker logs ps-tunnel.local 2>/dev/null | awk -F '/' '{print $3}' | awk -F"." '{print $1}' | awk 'END{print}' | tr -d "[:space:]"`

if [[ "$RBM_NAME" != "$SUBDOMAIN_NAME" ]]; then
  echo -e "Update env file\n"
  sed -r -i "s|(RBM_NAME=).*|RBM_NAME=${SUBDOMAIN_NAME}|" $ENV_FILE
fi

if ! command -v winpty &> /dev/null
then
  docker exec -w /tmp ps-rbm.local ./update-domain.sh "${SUBDOMAIN_NAME}.${TUNNEL_DOMAIN}"
else
  # Windows: we need to use winpty
  winpty docker exec -w //tmp ps-rbm.local ./update-domain.sh "${SUBDOMAIN_NAME}.${TUNNEL_DOMAIN}"
fi

get_urls
