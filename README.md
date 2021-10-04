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

The `install.sh` script do 2 things: 
- Creating a `prestashop-net` docker network: `docker network create prestashop-net`
- Launching mysql and prestashop: `docker-compose up -d`



### Settings

Update your `etc/hosts` file to have a proper domain: 

```
## Prestashop RBM
127.0.0.1 	prestashop-rbm.local
```



