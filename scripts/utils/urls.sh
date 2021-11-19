#!/bin/bash

source ./scripts/utils/read_env.sh

ENV_FILE=.env
TUNNEL_DOMAIN=$(read_var TUNNEL_DOMAIN $ENV_FILE)
SUBDOMAIN_NAME=$(read_var RBM_NAME $ENV_FILE)

get_fo_url() {
  local  retval="http://${SUBDOMAIN_NAME}.${TUNNEL_DOMAIN}"
  echo "$retval"
}

get_bo_url() {
  local  retval=$(get_fo_url)
  echo "$retval/admin-dev"
}

get_urls() {
  local FO_URL=$(get_fo_url)
  local BO_URL=$(get_bo_url)

  echo ""
  echo -e "BO Url: ${BO_URL}"
  echo -e "FO Url: ${FO_URL}"
}