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
        <li><a href="#installation">Installation</a></li>
        <li><a href="#environment-variables">Environment variables</a></li>
      </ul>
    </li>
    <li>
      <a href="#usage">Usage</a>
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

🚨 We strongly recommend to set your own ``RBM_NAME``

<p align="right">(<a href="#top">back to top</a>)</p>

### Environment variables

* ``RBM_NAME`` - Define name of you shop url for http proxy client / minimum: 4 characters (default value: rbm-prestashop)
* ``PS_LANGUAGE`` - Change the default language installed with PrestaShop (default value: en)
* ``PS_COUNTRY`` - Change the default country installed with PrestaShop (default value: GB)
* ``PS_ALL_LANGUAGES`` - Install all the existing languages for the current version. (default value: 0)
* ``ADMIN_MAIL`` - Override default admin password (default value: admin@prestashop.com)
* ``ADMIN_PASSWD`` - Override default admin password (default value: prestashop)
* ``PORT`` - Define port of the PrestaShop and the http proxy client (default value: 8080)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

Wait a few minutes, PrestaShop installation may take a while and launch you PrestaShop instance:
http://rbm-prestashop.tunnel.prestashop.net/admin-dev

## 🚀 What next ?

### RBM documentation

Documentation about developping a RBM is available [here](https://billing-docs.netlify.app/).

### RBM module example

See module [README.md](/modules/foobar/README.md)

<p align="right">(<a href="#top">back to top</a>)</p>