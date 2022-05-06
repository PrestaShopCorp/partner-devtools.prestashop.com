#!/bin/bash

set -e

# Load utilities
source ./scripts/utils/index.sh

ENV_FILE=.env

# Avoid docker scan warning
export DOCKER_SCAN_SUGGEST=false

# Get current user UID and GID
export APP_UID="$(id -u)"
export APP_GID="$(id -g)"

# Manage sed options on f*** on MacOS Darwin (M1)
SED_OPTIONS=""
if [[ "${OSTYPE}" == "darwin"* ]]; then
  SED_OPTIONS=".bak"
fi

# Manage rebuild image
BUILD_OPTIONS=""
if [[ "${TUNNEL_DEBUG}" == "true" ]]; then
  BUILD_OPTIONS="-- build"
fi

# Manage MacOS
DC_OPTIONS=""
if [[ `uname -m` == 'arm64' ]]; then
  DC_OPTIONS="-f docker-compose.yml -f docker-compose.arm64.yml"
fi

createNetwork() {
  local NETWORK_NAME=prestashop_net

  # Create a network for containers to communicate
  if [ -z $(docker network ls --filter name=^${NETWORK_NAME}$ --format="{{ .Name }}") ] ; then
    echo -e "Create ${NETWORK_NAME} network for containers to communicate\n"
    docker network create ${NETWORK_NAME} ;
  else
    echo -e "Network ${NETWORK_NAME} already exists, skipping\n"
  fi
}

createTunnel() {
  # Create http tunnel container
  echo -e "Create HTTP tunnel service\n"
  docker-compose ${DC_OPTIONS} up -d --no-deps ${BUILD_OPTIONS} prestashop_tunnel

  echo -e "Checking if HTTP tunnel is available...\n"
  LOCAL_TUNNEL_READY=`docker inspect -f {{.State.Running}} ps-tunnel.local | tr -d "[:space:]"`
  until (( "$LOCAL_TUNNEL_READY"=="true" ))
  do
    LOCAL_TUNNEL_READY=`docker inspect -f {{.State.Running}} ps-tunnel.local | tr -d "[:space:]"`
    echo -e "Waiting for confirmation of HTTP tunnel service startup\n"
    sleep 5
  done;

  # Wait for localtunnel availability to retrieve the domain
  SUBDOMAIN_NAME=`docker logs ps-tunnel.local 2>/dev/null | awk -F '/' '{print $3}' | awk -F"." '{print $1}' | awk 'END{print}' | tr -d "[:space:]"`
  until [[ ! -z "${SUBDOMAIN_NAME}" ]]
  do
    # avoid infinite loop...
    SUBDOMAIN_NAME=`docker logs ps-tunnel.local 2>/dev/null | awk -F '/' '{print $3}' | awk -F"." '{print $1}' | awk 'END{print}' | tr -d "[:space:]"`
    echo "Waiting for localtunnel subdomain retrieved (${SUBDOMAIN_NAME})"
    sleep 5
  done;

  echo -e "HTTP tunnel is available, let's continue !\n"
}

createDatabase() {
  # Create MySQL and PrestaShop service
  echo -e "Create MySQL & PMA service\n"
  docker-compose ${DC_OPTIONS} up -d --no-deps prestashop_rbm_db phpmyadmin
}

createPrestaShop() {
  sed -i $SED_OPTIONS -E "s|(PS_NAME=).*|PS_NAME=${SUBDOMAIN_NAME}|g" $ENV_FILE
  if [[ "$OSTYPE" == "darwin"* ]]; then
    rm -f "${ENV_FILE}${SED_OPTIONS}"
  fi
  PS_NAME=$(readEnv PS_NAME $ENV_FILE)

  # Create PrestaShop service
  echo -e "Create PrestaShop service\n"
  # docker-compose build --no-cache prestashop_rbm_shop
  docker-compose ${DC_OPTIONS} up -d --no-deps prestashop_rbm_shop

  isReady

  extraStep
}

createEnv() {
  # Setting up env file
  echo -e "Check env file\n"
  if [ ! -s "$ENV_FILE" ]; then
    echo -e "Create env file\n"
    cp .env.example $ENV_FILE
  fi
}

extraStep() {
  echo -e "Extra step\n"

  echo -e "Disable module welcome\n"
  echo off docker exec ps-rbm.local php bin/console prestashop:module disable welcome
  echo -e "Disable module gamification\n"
  echo off docker exec ps-rbm.local php bin/console prestashop:module disable gamification
}

timeElapsed() {
  local start_time="$(date -u +%s)"
  echo "Start $1"

  $1

  local end_time="$(date -u +%s)"
  local elapsed="$(($end_time-$start_time))"

  echo -e "Total of ${elapsed} seconds elapsed for $1\n"
}

isReady() {
  echo -e "\nChecking if PrestaShop is available... (≃ 2 min)\n"
  LOCAL_PORT=$(readEnv PORT $ENV_FILE)
  if [[ -z ${LOCAL_PORT} ]] ; then
    LOCAL_PORT=`docker port ps-rbm.local 80 | awk -F ':' '{print $2}' | tr -d "[:space:]"`
  fi

  PRESTASHOP_READY=`curl -s -o /dev/null -w "%{http_code}" localhost:$LOCAL_PORT | tr -d "[:space:]"`
  until (( "$PRESTASHOP_READY"=="302" ))
  do
    # avoid infinite loop...
    PRESTASHOP_READY=`curl -s -o /dev/null -w "%{http_code}" localhost:$LOCAL_PORT | tr -d "[:space:]"`
    echo "Waiting for confirmation of PrestaShop is available (${PRESTASHOP_READY})"
    sleep 5
  done;
}

##############################################
# RUN BUILDS                                 #
##############################################

timeElapsed createEnv

timeElapsed createNetwork

timeElapsed createTunnel

timeElapsed createDatabase

timeElapsed createPrestaShop

getUrls