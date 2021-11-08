<div id="top"></div>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://prestashop.com">
    <img src="https://www.prestashop.com/sites/all/themes/prestashop/images/logos/logo-fo-prestashop-colors.svg" alt="Logo" width="420" height="80">
  </a>

  <h1 align="center">Dev tools for RBM</h1>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li>
          <a href="#installation">Installation</a>
          <li>
            <ul>
              <li><a href="#quick-install">Quick Install</a></li>
              <li><a href="#custom-install">Custom install</a></li>
            </ul>
          </li>
        </li>
        <li><a href="#environment-variables">Environment variables</a></li>
      </ul>
    </li>
    <li>
      <a href="#usage">Utils</a>
    </li>
    <li>
      <a href="#troubleshooting">Troubleshooting</a>
      <ul>
        <li><a href="#mac-os">MacOS</a></li>
        <li><a href="#common-problems">Common Problems</a></li>
      </ul>
    </li>
    <li>
      <a href="#what-next">What next ?</a>
      <ul>
        <li><a href="#rbm-documentation">RBM documentation</a></li>
        <li><a href="#rbm-module-example">RBM module example</a></li>
      </ul>
    </li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## 🧐 About The Project

This tools help you to set up your development environement when you start to develop a PrestaShop RBM.

You will find an exemple of a simple RBM Module within the folder `foobar`.

Once you launch the wholes services through docker-compose you will get an access to a PrestaShop instance configured with all needed module.


<!-- GETTING STARTED -->
## 💡 Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

🐳 [Docker and docker-compose installed](https://www.docker.com/products/docker-desktop)

### Installation
  
#### Quick install
1. Clone the repo
```sh
git clone https://github.com/PrestaShopCorp/rbm-devtools.prestashop.com.git
```
2. Create your dot env file
```sh
cp .env.example .env
```
3. Run project
```sh
./install.sh
```

<p align="right">(<a href="#top">back to top</a>)</p>


#### Custom install

Let's see what does install.sh step by step

First we create a network layer for our container, if network already exit we skip this part
```sh
NETWORK_NAME=prestashop_net
if [ -z $(docker network ls --filter name=^${NETWORK_NAME}$ --format="{{ .Name }}") ] ; then
  echo -e "Create ${NETWORK_NAME} network for containers to communicate\n"
  docker network create ${NETWORK_NAME} ;
else
  echo -e "Network ${NETWORK_NAME} already exists, skipping\n"
fi
```

> 💡 If you want to use another network you will need to edit docker-compose.yml

We create http tunnel container, it will generate your shop url
```sh
# Create http tunnel container
echo -e "Create HTTP tunnel service\n"
docker-compose up -d --no-deps --build prestashop_tunnel

echo -e "Checking if HTTP tunnel is available...\n"
LOCAL_TUNNEL_READY=`docker inspect -f {{.State.Running}} ps-tunnel.local`
until (("$LOCAL_TUNNEL_READY"=="true"))
do
  echo -e "Waiting for confirmation of HTTP tunnel service startup\n"
  sleep 5
done;
echo -e "HTTP tunnel is available, let's continue !\n"
```

We setup .env file with your subdomain, if .env already exist we skip this part and we replace ``RBM_NAME``
```sh
# Setting up env file
echo -e "Setting up env file\n"
ENV_FILE=.env
SUBDOMAIN_NAME=`docker logs ps-tunnel.local 2>/dev/null | awk -F '/' '{print $3}' | awk -F"." '{print $1}' | awk 'END{print}' | tr -d "[:space:]"`
if [ ! -s "$ENV_FILE" ]; then
  echo -e "Create env file\n"
  cp .env.example $ENV_FILE
fi
sed -r -i "s|(RBM_NAME=).*|RBM_NAME=${SUBDOMAIN_NAME}|" $ENV_FILE
```

> 💡 Note: you can customize .env file, see below in <a href="#environment-variables">Environment variables</a>


We do a small tricks to get always the same URL
```sh
# Handle restart to avoid new subdomain
TUNNEL_FILE=tunnel/.config
if [ ! -s "$TUNNEL_FILE" ]; then
  echo -e "Handle restart to avoid new subdomain\n"
  echo $SUBDOMAIN_NAME > tunnel/.config
fi
docker cp tunnel/.config ps-tunnel.local:/tmp/.config
```

We create MySQL and PrestaShop container
```sh
# Create MySQL and PrestaShop service
echo -e "Create MySQL & PrestaShop service\n"
if [[ `uname -m` == 'arm64' ]]; then
  docker-compose -f docker-compose.yml -f docker-compose.arm64.yml up -d --no-deps --build prestashop_rbm_db prestashop_rbm_shop
else
  docker-compose up -d --no-deps --build prestashop_rbm_db prestashop_rbm_shop
fi
```

We wait until PrestaShop is ready to use
```sh
PRESTASHOP_READY=`curl -s -o /dev/null -w "%{http_code}" localhost:$LOCAL_PORT`
until (("$PRESTASHOP_READY"=="302"))
do
  # avoid infinite loop...
  PRESTASHOP_READY=`curl -s -o /dev/null -w "%{http_code}" localhost:$LOCAL_PORT`
  echo "Waiting for confirmation of PrestaShop is available (${PRESTASHOP_READY})"
  sleep 5
done;
fi
```

Finaly, we display your URL
```sh
TUNNEL_DOMAIN=$(read_var TUNNEL_DOMAIN $ENV_FILE)
FO_URL="http://${SUBDOMAIN_NAME}.${TUNNEL_DOMAIN}/"
BO_URL="http://${SUBDOMAIN_NAME}.${TUNNEL_DOMAIN}/admin-dev"
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  echo -e "BO Url: ${BO_URL}"
  echo -e "FO Url: ${FO_URL}"
else
  echo -e "\e]8;;${BO_URL}\aBO Url\e]8;;\a"
  echo -e "\e]8;;${FO_URL}\aFO Url\e]8;;\a"
fi
```

<p align="right">(<a href="#top">back to top</a>)</p>


### Environment variables

* ``RBM_NAME`` - Define subdomain for tunnel http (default value: CHANGEME123)
* ``TUNNEL_DOMAIN`` - Define tunnel domain (default value: tunnel.prestashop.net)
* ``PS_LANGUAGE`` - Change the default language installed with PrestaShop (default value: en)
* ``PS_COUNTRY`` - Change the default country installed with PrestaShop (default value: GB)
* ``PS_ALL_LANGUAGES`` - Install all the existing languages for the current version. (default value: 0)
* ``ADMIN_MAIL`` - Override default admin password (default value: admin@prestashop.com)
* ``ADMIN_PASSWD`` - Override default admin password (default value: prestashop)
* ``PORT`` - Define port of the PrestaShop and the http proxy client (default value: 8080)

> 💡 ``RBM_NAME`` is automatically generated by localtunnel client

> 💡 ``TUNNEL_DOMAIN`` can be changed if you host your self [localtunnel server](https://github.com/localtunnel/server)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Utils

Get your shop URL
``` sh
./get-url.sh

BO Url: http://CHANGEME123.tunnel.prestashop.net/admin-dev
FO Url: http://CHANGEME123.tunnel.prestashop.net
```

Update shop URL
``` sh
./update-domain.sh
Updating PrestaShop domains ...

BO Url: http://CHANGEME123.tunnel.prestashop.net/admin-dev
FO Url: http://CHANGEME123.tunnel.prestashop.net
```


## 🐛 Troubleshooting

### Mac OS
[Mac network_mode: "host" not working as expected](https://docs.docker.com/desktop/mac/networking/#known-limitations-use-cases-and-workarounds)


## 🚀 What next ?

### RBM documentation

Documentation about developping a RBM is available [here](https://billing-docs.netlify.app/).

### RBM module example

See module [README.md](/modules/foobar/README.md)

<p align="right">(<a href="#top">back to top</a>)</p>