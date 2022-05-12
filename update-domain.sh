#!/bin/bash
source ./scripts/utils/index.sh

set -e

# Manage sed options on f*** on MacOS Darwin (M1)
SED_OPTIONS=""
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_OPTIONS=".bak"
fi

# setting up env file
ENV_FILE=.env
PS_NAME=$(readEnv PS_NAME $ENV_FILE)
TUNNEL_DOMAIN=$(readEnv TUNNEL_DOMAIN $ENV_FILE)
SUBDOMAIN_NAME=`docker logs ps-tunnel 2>/dev/null | awk -F '/' '{print $3}' | awk -F"." '{print $1}' | awk 'END{print}' | tr -d "[:space:]"`

if [[ "$PS_NAME" != "$SUBDOMAIN_NAME" ]]; then
  echo -e "Update env file\n"
  sed -i $SED_OPTIONS -E "s|(PS_NAME=).*|PS_NAME=${SUBDOMAIN_NAME}|g" $ENV_FILE
  if [[ "$OSTYPE" == "darwin"* ]]; then
    rm -f "${ENV_FILE}${SED_OPTIONS}"
  fi

  # Read update file
  PS_NAME=$(readEnv PS_NAME $ENV_FILE)
fi

if ! command -v winpty &> /dev/null
then
  docker exec -w /tmp ps-rbm ./update-domain.sh "${SUBDOMAIN_NAME}.${TUNNEL_DOMAIN}"
else
  # Windows: we need to use winpty
  winpty docker exec -w //tmp ps-rbm ./update-domain.sh "${SUBDOMAIN_NAME}.${TUNNEL_DOMAIN}"
fi

getUrls
