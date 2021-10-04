# Development environment for RBM

This repo help you to set up your development environement when you start to develop an PrestaShop RBM.

## Requirement

* [Docker and docker-compose installed](https://www.docker.com/products/docker-desktop)
* [Ngrok installed](https://ngrok.com/download)

## Getting started


```sh
# create prestashop-net docker network and launch mysql and prestashop
$ ./install.sh
```

**In detail**

The `install.sh` script do 3 things: 
- Create a `prestashop-net` docker network: `docker network create prestashop-net`
- Launch mysql and prestashop: `docker-compose up -d`


> Use admin@prestashop.com / prestashop to connect to the admin panel. You may create a new user with your own credentials for security reason.


## Settings

### Initialization

1. Go to http://localhost:8080/admin-dev/ and login with: demo@prestashop.com / prestashop_demo
2. Update the Shop URL 
Got to https://prestashop-rbm-dev.loca.lt/admin-dev/
