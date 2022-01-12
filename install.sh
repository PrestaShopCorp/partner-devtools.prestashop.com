#!/bin/bash

# Load utilities
source ./scripts/utils/index.sh

# Manage sed options on f*** on MacOS Darwin (M1)
SED_OPTIONS=""
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_OPTIONS=".bak"
fi

# Create a network for containers to communicate
NETWORK_NAME=prestashop_net
if [ -z $(docker network ls --filter name=^${NETWORK_NAME}$ --format="{{ .Name }}") ] ; then
  echo -e "Create ${NETWORK_NAME} network for containers to communicate\n"
  docker network create ${NETWORK_NAME} ;
else
  echo -e "Network ${NETWORK_NAME} already exists, skipping\n"
fi


# Create http tunnel container
echo -e "Create HTTP tunnel service\n"
if [[ `uname -m` == 'arm64' ]]; then
  docker-compose -f docker-compose.yml -f docker-compose.arm64.yml up -d --no-deps --force-recreate --build prestashop_tunnel
else
  docker-compose up -d --no-deps --force-recreate --build prestashop_tunnel
fi

echo -e "Checking if HTTP tunnel is available...\n"
LOCAL_TUNNEL_READY=`docker inspect -f {{.State.Running}} ps-tunnel.local`
until (("$LOCAL_TUNNEL_READY"=="true"))
do
  echo -e "Waiting for confirmation of HTTP tunnel service startup\n"
  sleep 5
done;
echo -e "HTTP tunnel is available, let's continue !\n"


# Setting up env file
echo -e "Setting up env file\n"

ENV_FILE=.env
SUBDOMAIN_NAME=`docker logs ps-tunnel.local 2>/dev/null | awk -F '/' '{print $3}' | awk -F"." '{print $1}' | awk 'END{print}' | tr -d "[:space:]"`
if [ ! -s "$ENV_FILE" ]; then
  echo -e "Create env file\n"
  cp .env.example $ENV_FILE
fi

sed -i $SED_OPTIONS -E "s|(RBM_NAME=).*|RBM_NAME=${SUBDOMAIN_NAME}|g" $ENV_FILE
if [[ "$OSTYPE" == "darwin"* ]]; then
  rm -f "${ENV_FILE}${SED_OPTIONS}"
fi
RBM_NAME=$(read_var RBM_NAME $ENV_FILE)

# Handle restart to avoid new subdomain
TUNNEL_FILE=tunnel/.config
if [ ! -s "$TUNNEL_FILE" ]; then
  echo -e "Handle restart to avoid new subdomain\n"
  echo $SUBDOMAIN_NAME > $TUNNEL_FILE
fi
cat $TUNNEL_FILE
docker logs ps-tunnel.local

docker cp $TUNNEL_FILE ps-tunnel.local:/tmp/.config


# Create MySQL and PrestaShop service
echo -e "Create MySQL & PrestaShop service\n"
echo "${RBM_NAME} - ${SUBDOMAIN_NAME} ---- \n"
if [[ `uname -m` == 'arm64' ]]; then
  docker-compose -f docker-compose.yml -f docker-compose.arm64.yml up -d --no-deps --build prestashop_rbm_db prestashop_rbm_shop
else
  docker-compose up -d --no-deps --build prestashop_rbm_db prestashop_rbm_shop
fi

echo -e "\nChecking if PrestaShop is available...\n"
LOCAL_PORT=$(read_var PORT $ENV_FILE)
if [ -z $LOCAL_PORT ] ; then
  LOCAL_PORT=`docker port ps-rbm.local 80 | awk -F ':' '{print $2}' | tr -d "[:space:]"`
fi

PRESTASHOP_READY=`curl -s -o /dev/null -w "%{http_code}" localhost:$LOCAL_PORT`
until (("$PRESTASHOP_READY"=="302"))
do
  # avoid infinite loop...
  PRESTASHOP_READY=`curl -s -o /dev/null -w "%{http_code}" localhost:$LOCAL_PORT`
  echo "Waiting for confirmation of PrestaShop is available (${PRESTASHOP_READY})"
  sleep 5
done;

get_urls
