#!/bin/bash

# create a network for containers to communicate
docker network create prestashop_net

# launch mysql 5.7 container and prestashop
if [[ `uname -m` == 'arm64' ]]; then
  docker-compose -f docker-compose.yml -f docker-compose.arm64.yml up -d
else
	docker-compose up -d
fi
