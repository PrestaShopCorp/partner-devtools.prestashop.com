---
title: PrestaShop Account Integration
---

<Block>

# ![](/assets/images/common/logo-condensed-sm.png) Partner Module with PrestaShop Accounts


A partner Module is a composition of [PHP](https://www.php.net/) as backend and [Vue 2](https://vuejs.org/) as frontend.


Here is the step to create a RBM :

1. Create a Prestashop Module
2. Make the PHP part injecting the proper `context` in the `window` object, which is required for PsAccount.
3. Create a JS app including PsAccount
4. Inject the `context` in PsAccount

**First of all, create a basic module following the Prestashop documentation: [https://devdocs.prestashop.com/1.7/modules/creation/](https://devdocs.prestashop.com/1.7/modules/creation/)**

::: warning Compatibility
Prestashop Accounts is compatible from PrestaShop 1.6.1.x and PHP 5.6
:::

</Block>

<Block>

## Backend


The PsAccount module is a pre-requisite for every Partner Module, it provides an SSO allowing to link the addons market's accounts to the ones in the prestashop core


### Composer

You must add some dependencies in the [composer.json](https://getcomposer.org/) of your newly created module. The composer `prestashop/prestashop-accounts-installer` will help you to construct the `context` required to make your module work.

The 2 dependencies `php` and `symfony/http-foundation` are used for resolving compatibility issues

```json
"require": {
    "php": ">=5.6",
    "symfony/http-foundation": "^3.4",
    "prestashop/prestashop-accounts-installer": "^1.0.0",
    "prestashop/module-lib-service-container": "^1.2"
},
```

<Example>
```json{13,14}
{
    "name": "prestashop/rbm_example",
    "type": "library",
    "authors": [
        {
            "name": "Prestashop",
            "email": "support@prestashop.com"
        }
    ],
    "require": {
        "php": ">=5.6",
        "symfony/http-foundation": "^3.4",
        "prestashop/prestashop-accounts-installer": "^1.0.0",
        "prestashop/module-lib-service-container": "^1.2"
    },
    "config": {
        "preferred-install": "dist",
        "optimize-autoloader": true,
        "prepend-autoloader": false,
        "platform": {
            "php": "5.6"
        }
    }
}
```

</Example>

</Block>

<Block>

### <your_module_name>.php

> Note: For simplification, all PHP methods listed below are created in the `<your_module_name>.php`.
> Feel free to re-organize the code structure in another way due to the module evolution.


##### Load PsAccount utility

First you need to register PsAccount within your module. You should add a `getService` method. Then update the `install()` hook.

```php
class YourModuleName extends Module {
  // ...
  public function install()
  {
      // Load PS Account utility
      return parent::install() &&
          $this->getService('ps_accounts.installer')->install();
  }

  // ...

  public function getService($serviceName)
  {
      if ($this->container === null) {
          $this->container = new \PrestaShop\ModuleLibServiceContainer\DependencyInjection\ServiceContainer(
              $this->name,
              $this->getLocalPath()
          );
      }

      return $this->container->getService($serviceName);
  }
}
```

> You should follow the documentation from [prestashop-accounts-installer](https://github.com/PrestaShopCorp/prestashop-accounts-installer) to properly install the PS Account utility.

##### Inject PsAccount library and context

PsAccount needs to get some information to work. This information is provided by injecting a `context`.

In order to inject the `context` you should update `getContent` hook. This will inject  `contextPsAccounts` within the browser `window` object (`window.contextPsAccounts`).


```php
// Load context for PsAccount
$facade = $this->getService('ps_accounts.facade');
Media::addJsDef([
    'contextPsAccounts' => $facade->getPsAccountsPresenter()
        ->present($this->name),
]);
```

#### Load the front JS app

You should load the bundle of the front JS app in the `getContent` hook of your module PHP file. See [Compile your app](#compile-your-app) to get the correct path.

```php
// Update the path to have the proper path
$this->context->smarty->assign('pathVendor', $this->getPathUri() . 'views/js/chunk-vendors-rbm_example.' . $this->version . '.js');
$this->context->smarty->assign('pathApp', $this->getPathUri() . 'views/js/app-rbm_example.' . $this->version . '.js');
```

<Example>
```php
<?php
if (!defined('_PS_VERSION_'))
    exit;

require 'vendor/autoload.php';

use PrestaShop\PsAccountsInstaller\Installer\Exception\ModuleVersionException;
use PrestaShop\PsAccountsInstaller\Installer\Exception\ModuleNotInstalledException;
use ContextCore as Context;

class YourModuleName extends Module
{

    private $container;
    private $psVersionIs17;
    private $emailSupport;

    public function __construct()
    {
        $this->name = 'your_module_name';
        $this->tab = 'advertising_marketing';
        $this->version = '1.0.0';
        $this->author = 'Prestashop';
        $this->emailSupport = 'support@prestashop.com';
        $this->need_instance = 0;
        $this->ps_versions_compliancy = [
            'min' => '1.6',
            'max' => _PS_VERSION_
        ];
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('rbm_example');
        $this->description = $this->l('This is a RBM example module.');

        $this->confirmUninstall = $this->l('Are you sure to uninstall this module?');

        $this->template_dir = _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/';

        if ($this->container === null) {
            $this->container = new \PrestaShop\ModuleLibServiceContainer\DependencyInjection\ServiceContainer($this->name, $this->getLocalPath());
        }
    }

    public function install()
    {
        return parent::install() &&
            $this->getService('ps_accounts.installer')->install();
    }

    public function uninstall()
    {
        if (!parent::uninstall()) {
            return false;
        }

        return true;
    }

    public function getContent()
    {
        $facade = $this->getService('ps_accounts.facade');
        Media::addJsDef([
            'contextPsAccounts' => $facade->getPsAccountsPresenter()
                ->present($this->name),
        ]);

        try {

            $psAccountsService = $facade->getPsAccountsService();

        } catch (ModuleNotInstalledException $e) {

            // You handle exception here

        } catch (ModuleVersionException $e) {

            // You handle exception here
        }

        return $this->context->smarty->fetch($this->template_dir . 'your_module_name.tpl');
    }

    public function getService($serviceName)
    {
        if ($this->container === null) {
            $this->container = new \PrestaShop\ModuleLibServiceContainer\DependencyInjection\ServiceContainer(
                $this->name,
                $this->getLocalPath()
            );
        }

        return $this->container->getService($serviceName);
    }
}

```
</Example>

</Block>

<Block>

#### Module template

Create the global vue app template in `views/templates/admin/<your_module_name>.tpl`. The name should match the name defined in `<your_module_name>.php` by this line:

```php
return $this->context->smarty->fetch($this->template_dir . '<your_module_name>.tpl');
```

This file will load the Vue app frontend and the chunk vendor js

> The 2 variables `$pathVendor` and `$pathApp` are prepared in the `getContent` hook.

<Example>
```html
<link href="{$pathVendor|escape:'htmlall':'UTF-8'}" rel=preload as=script>
<link href="{$pathApp|escape:'htmlall':'UTF-8'}" rel=preload as=script>

<div id="app"></div>

<script src="{$pathVendor|escape:'htmlall':'UTF-8'}"></script>
<script src="{$pathApp|escape:'htmlall':'UTF-8'}"></script>

```
</Example>

</Block>

<Block>

## Frontend

::: tip About VueJS
Javascript and Vue knowledge are prerequisite (cf [https://vuejs.org/v2/guide/](https://vuejs.org/v2/guide/)). This section only introduces the essentials, for more information, please take a look at the [example RBM module](https://github.com/PrestaShopCorp/prestashop_rbm_example) or to the [Using VueJS Prestashop documentation](https://devdocs.prestashop.com/1.7/modules/concepts/templating/vuejs/).
:::


### Getting started

Create a `_dev` folder in your module. This folder will contain the different VueJS app contained in your module. You can have only one app.

Go to this folder then create a [VueJS project](https://cli.vuejs.org/guide/creating-a-project.html#vue-create).

::: tip
Feel free to organize your application in your own way
:::

<Example>
```bash
# Create the Vue app
cd _dev
vue create <app's name>
```

</Example>

</Block>

<Block>

### Compile your app

You need to update or create the `vue.config.js` to compile properly your VueJS app. The `outputDir` should change, depending on your module structure. Don't forget to change the `<module_name>` in the output filename path.

This is only an example of `vue.config.js`, you may modify this configuration.

::: warning Chunk path
These file's names must match with the ones (`$pathVendor`, `$pathApp`
) used in the `getContent` hook and the version of this module php (cf composer.json) and the vue app (cf package.json) must be the same
:::

<Example>
```js
const webpack = require("webpack");
const path = require("path");
const fs = require('fs');
const packageJson = fs.readFileSync('./package.json')
const version = JSON.parse(packageJson).version || 0
module.exports = {
    parallel: false,
    configureWebpack: {
        plugins: [
            new webpack.ProvidePlugin({
                cash: "cash-dom",
            }),
        ],
        output: {
            filename: `js/app-rbm_example.${version}.js`,
            chunkFilename: `js/chunk-vendors-rbm_example.${version}.js`
        }
    },
    chainWebpack: (config) => {
        config.plugins.delete("html");
        config.plugins.delete("preload");
        config.plugins.delete("prefetch");
        config.resolve.alias.set("@", path.resolve(__dirname, "src"));
    },
    css: {
        extract: false,
    },
    runtimeCompiler: true,
    productionSourceMap: false,
    filenameHashing: false,
    outputDir: "../../views/", // Outputs in module views folder
    assetsDir: "",
    publicPath: "../modules/<module_name>/views/",
};
```
</Example>

#### Add required dependencies

```bash
yarn add prestashop_accounts_vue_components
```

</Block>

<Block>

### Use PsAccount

Create a component or use the App.vue component and add `PsAccount` inside the template.

```html
# Minimalistic Vue template
<template>
  <div>
    <PsAccounts>
    </PsAccounts>
  </div>
</template>
```

```js
<script>
import { PsAccounts } from "prestashop_accounts_vue_components";

export default {
    components: {
        PsAccounts,
    },
}
</script>
```

<Example>
```html
<template>
  <div>
    <PsAccounts>
    </PsAccounts>
    <div v-if="sub && sub.id">Partner module example content</div>
  </div>
</template>
```
```js
<script>
import Vue from 'vue';
import { PsAccounts } from "prestashop_accounts_vue_components";
import moduleLogo from "@/assets/prestashop-logo.png";

export default {
  components: {
    PsAccounts,
  }
}
</script>

```
</Example>

</Block>

<Block>
#### Context in detail

TODO : psaccounts context - Below is the details of the attributes

| Attribute | Type | Description |
| ---------- |------| -------------|
| moduleName | **string** | Module's name (**required**) |
| moduleTosUrl | **string** | Url to your term of service (**required**) |
| accountApi | **string** | API to retrieve Prestashop Account (**required**) |
| emailSupport | **string** | Email to contact support (**required**) |
| i18n.isoCode | **string** | ISO code (**required**) |
| shop.uuid | **string** | Merchant shop's uuid (**required**) |
| shop.domain | **string** | Merchant site's domain name (**required**) |
| user.createdFromIp | **string** | Merchant site's ip address (**required**) |
| user.email | **string** | Merchant's email (**required**) |
| versionModule | **string** | Module's version |
| versionPs | **string** | Prestashop's version |

</Block>

