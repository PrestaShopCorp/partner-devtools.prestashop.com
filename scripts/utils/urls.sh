#!/bin/bash

source ./scripts/utils/read_env.sh

ENV_FILE=.env
TUNNEL_DOMAIN=$(read_var TUNNEL_DOMAIN $ENV_FILE)
RBM_NAME=$(read_var RBM_NAME $ENV_FILE)
SUBDOMAIN_NAME=`docker logs ps-tunnel.local 2>/dev/null | awk -F '/' '{print $3}' | awk -F"." '{print $1}' | awk 'END{print}' | tr -d "[:space:]"`


get_fo_url() {
  local  retval="http://${SUBDOMAIN_NAME}.${TUNNEL_DOMAIN}"
  echo "$retval"
}

get_bo_url() {
  local  retval=$(get_fo_url)
  echo "$retval/admin-dev"
}

get_urls() {
  echo "env ${RBM_NAME} != dc ${SUBDOMAIN_NAME}"

  if [[ "$RBM_NAME" != "$SUBDOMAIN_NAME" ]]; then
    echo -e "You need to run ./update-domain.sh\n"
  else
    local FO_URL=$(get_fo_url)
    local BO_URL=$(get_bo_url)

    echo ""
    echo -e "BO Url: ${BO_URL}"
    echo -e "FO Url: ${FO_URL}"
  fi
}