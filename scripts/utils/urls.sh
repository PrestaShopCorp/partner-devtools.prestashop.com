#!/bin/bash

source ./scripts/utils/read_env.sh

ENV_FILE=.env
SUBDOMAIN_NAME=`docker logs ps-tunnel.local 2>/dev/null | awk -F '/' '{print $3}' | awk -F"." '{print $1}' | awk 'END{print}' | tr -d "[:space:]"`

getFoUrl() {
  local TUNNEL_DOMAIN=$(readEnv TUNNEL_DOMAIN $ENV_FILE)
  local retval="http://${SUBDOMAIN_NAME}.${TUNNEL_DOMAIN}"
  echo "$retval"
}

getBoUrl() {
  local ADMIN_MAIL=$(readEnv ADMIN_MAIL $ENV_FILE)
  local retval=$(getFoUrl)
  echo "$retval/admin-dev/index.php?controller=AdminLogin&email=${ADMIN_MAIL:-admin@prestashop.com}"
}

getPMAUrl() {
  local PMA_PORT=$(readEnv PMA_PORT $ENV_FILE)
  echo -e "PMA Url: http://localhost:${PMA_PORT}"
}

getUrls() {
  PS_NAME=$(readEnv PS_NAME $ENV_FILE)

  if [[ "$PS_NAME" != "$SUBDOMAIN_NAME" ]]; then
    echo -e "You need to run ./update-domain.sh\n"
  else
    local FO_URL=$(getFoUrl)
    local BO_URL=$(getBoUrl)

    getPMAUrl
    echo ""
    echo -e "BO Url: ${BO_URL}"
    echo -e "FO Url: ${FO_URL}"

  fi
}