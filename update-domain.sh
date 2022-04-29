#!/bin/bash
source ./scripts/utils/index.sh

# Manage sed options on f*** on MacOS Darwin (M1)
SED_OPTIONS=""
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_OPTIONS=".bak"
fi

# setting up env file
ENV_FILE=.env
RBM_NAME=$(read_var RBM_NAME $ENV_FILE)
TUNNEL_DOMAIN=$(read_var TUNNEL_DOMAIN $ENV_FILE)
SUBDOMAIN_NAME=`docker logs ps-tunnel.local 2>/dev/null | awk -F '/' '{print $3}' | awk -F"." '{print $1}' | awk 'END{print}' | tr -d "[:space:]"`

if [[ "$RBM_NAME" != "$SUBDOMAIN_NAME" ]]; then
  echo -e "Update env file\n"
  sed -i $SED_OPTIONS -E "s|(RBM_NAME=).*|RBM_NAME=${SUBDOMAIN_NAME}|g" $ENV_FILE
  if [[ "$OSTYPE" == "darwin"* ]]; then
    rm -f "${ENV_FILE}${SED_OPTIONS}"
  fi

  # echo -e "Handle restart to avoid new subdomain\n"
  echo $SUBDOMAIN_NAME > tunnel/.config
  docker cp tunnel/.config ps-tunnel.local:/tmp/.config

  # Read update file
  RBM_NAME=$(read_var RBM_NAME $ENV_FILE)
fi

if ! command -v winpty &> /dev/null
then
  docker exec -w /tmp ps-rbm.local ./update-domain.sh "${SUBDOMAIN_NAME}.${TUNNEL_DOMAIN}"
else
  # Windows: we need to use winpty
  winpty docker exec -w //tmp ps-rbm.local ./update-domain.sh "${SUBDOMAIN_NAME}.${TUNNEL_DOMAIN}"
fi

get_urls
