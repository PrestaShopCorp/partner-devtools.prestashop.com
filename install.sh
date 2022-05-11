#!/bin/bash

# Load utilities
source ./scripts/utils/index.sh

ENV_FILE=.env

# Avoid docker scan warning
export DOCKER_SCAN_SUGGEST=false

# Get current user UID and GID
if [[ `whoami` != "root" ]]; then
  export APP_UID="$(id -u)"
  export APP_GID="$(id -g)"
fi

# Manage sed options on f*** on MacOS Darwin (M1)
SED_OPTIONS=""
if [[ "${OSTYPE}" == "darwin"* ]]; then
  SED_OPTIONS=".bak"
fi

# Manage rebuild image
BUILD_OPTIONS=""
if [[ "${TUNNEL_DEBUG}" == "true" ]]; then
  BUILD_OPTIONS="--build"
fi

# Manage MacOS
DC_OPTIONS=""
if [[ `uname -m` == 'arm64' ]]; then
  DC_OPTIONS="-f docker-compose.yml -f docker-compose.arm64.yml"
fi

version() {
  echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }';
}

# Manage Port Linux / MacOs Or Windows
checkPort() {
  TCP_CHECK="netstat -tunlp TCP"
  if [ "$OSTYPE" == "msys" ] || [ "$OSTYPE" == "cygwin" ]; then
    TCP_CHECK="netstat -anop TCP"
  fi

  local checkTCP=`${TCP_CHECK} | grep -w LISTENING | grep -w $1`
  if [[ ${checkTCP} ]] ; then
    echo "Your port $1 is already allocated, edit .env at $2"
    return 1
  fi
  return 0
}

checkDockerVesion() {
  DC_VERSION_REF="1.27.0"
  DC_VERSION=`docker-compose --version | awk -F ' ' '{print $3}'  | awk '{sub(/.$/,"")}1' | tr -d "[:space:]"`

  if [ ! $(version $DC_VERSION) -ge $(version $DC_VERSION_REF) ]; then
    echo "You need to upgrade docker-compose to ${DC_VERSION_REF} at least"
    return 1
  fi
  return 0
}


checkAvailability() {
  local exitNeed=0

  PORT=$(readEnv PORT $ENV_FILE)
  checkPort ${PORT} PORT
  exitNeed=$((exitNeed + $?))

  PMA_PORT=$(readEnv PMA_PORT $ENV_FILE)
  checkPort ${PMA_PORT} PMA_PORT
  exitNeed=$((exitNeed + $?))

  DB_PORT=$(readEnv DB_PORT $ENV_FILE)
  checkPort ${DB_PORT} DB_PORT
  exitNeed=$((exitNeed + $?))

  checkDockerVesion
  exitNeed=$((exitNeed + $?))

  if [[ $exitNeed -gt 0 ]]; then
    exit $exitNeed
  fi
}

createEnv() {
  # Setting up env file
  if [ ! -s "$ENV_FILE" ]; then
    echo -e "Create env file\n"
    cp .env.example $ENV_FILE
  fi
}

createNetwork() {
  local NETWORK_NAME=prestashop_net

  # Create a network for containers to communicate
  if [ -z $(docker network ls --filter name=^${NETWORK_NAME}$ --format="{{ .Name }}") ] ; then
    echo -e "Create ${NETWORK_NAME} network for containers to communicate\n"
    docker network create ${NETWORK_NAME} ;
  fi
}

createTunnel() {
  # Create http tunnel container
  echo -e "Create HTTP tunnel service\n"

  if [ "$OSTYPE" == "msys" ] || [ "$OSTYPE" == "cygwin" ]; then
    if [[ ! `command -v dos2unix` ]]; then
        echo "dos2unix could not be found, you can install it https://waterlan.home.xs4all.nl/dos2unix.html"
        exit 42
    fi
    dos2unix -q ./tunnel/scripts/run.sh
  fi

  # Force to rebuild image
  if [[ "${TUNNEL_DEBUG}" == "true" ]]; then
     docker-compose build --no-cache prestashop_tunnel
  fi

  docker-compose ${DC_OPTIONS} up -d --no-deps ${BUILD_OPTIONS} prestashop_tunnel

  echo -e "Checking if HTTP tunnel is available...\n"
  LOCAL_TUNNEL_READY=`docker inspect -f {{.State.Running}} ps-tunnel | tr -d "[:space:]"`
  until (( "$LOCAL_TUNNEL_READY"=="true" ))
  do
    LOCAL_TUNNEL_READY=`docker inspect -f {{.State.Running}} ps-tunnel | tr -d "[:space:]"`
    echo -e "Waiting for confirmation of HTTP tunnel service startup\n"
    sleep 5
  done;

  # Wait for localtunnel availability to retrieve the domain
  SUBDOMAIN_NAME=`docker logs ps-tunnel 2>/dev/null | awk -F '/' '{print $3}' | awk -F"." '{print $1}' | awk 'END{print}' | tr -d "[:space:]"`
  until [[ ! -z "${SUBDOMAIN_NAME}" ]]
  do
    # avoid infinite loop...
    SUBDOMAIN_NAME=`docker logs ps-tunnel 2>/dev/null | awk -F '/' '{print $3}' | awk -F"." '{print $1}' | awk 'END{print}' | tr -d "[:space:]"`
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
  if [ "$OSTYPE" == "msys" ] || [ "$OSTYPE" == "cygwin" ]; then
    if [[ ! `command -v dos2unix` ]]; then
        echo "dos2unix could not be found, you can install it https://waterlan.home.xs4all.nl/dos2unix.html"
        exit 42
    fi
    dos2unix -q ./scripts/update-domain.sh
  fi

  sed -i $SED_OPTIONS -E "s|(PS_NAME=).*|PS_NAME=${SUBDOMAIN_NAME}|g" $ENV_FILE
  if [[ "$OSTYPE" == "darwin"* ]]; then
    rm -f "${ENV_FILE}${SED_OPTIONS}"
  fi
  PS_NAME=$(readEnv PS_NAME $ENV_FILE)

  # Create PrestaShop service
  echo -e "Create PrestaShop service\n"

  # Force to rebuild image
  if [[ "${TUNNEL_DEBUG}" == "true" ]]; then
     docker-compose build --no-cache prestashop_rbm_shop
  fi
  docker-compose ${DC_OPTIONS} up -d --no-deps ${BUILD_OPTIONS} prestashop_rbm_shop

  isReady

  extraStep
}

extraStep() {
  echo -e "Extra step\n"

  echo -e "Disable module welcome"
  docker exec ps-rbm php bin/console prestashop:module disable welcome
  echo -e "Disable module gamification"
  docker exec ps-rbm php bin/console prestashop:module disable gamification
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
  echo -e "\nChecking if PrestaShop is available... (approximately 2 min)\n"
  LOCAL_PORT=$(readEnv PORT $ENV_FILE)
  if [[ -z ${LOCAL_PORT} ]] ; then
    LOCAL_PORT=`docker port ps-rbm 80 | awk -F ':' '{print $2}' | tr -d "[:space:]"`
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

createNetwork

createEnv

checkAvailability

timeElapsed createTunnel

timeElapsed createDatabase

timeElapsed createPrestaShop

getUrls

# Clean UP
unset TUNNEL_DEBUG