---
title: Recurring Billing Module
---

<Block>

# ![](/assets/images/common/logo-condensed-sm.png) Recurring Billing Module


A recurring Billing Module is a composition of [PHP](https://www.php.net/) as backend and [Vue 2](https://vuejs.org/) as frontend.

::: tip
In the future Vue 2 may not be required as the Prestashop Billing Component doesn't require it.
:::

Here is the step to create a RBM :

1. Create a Prestashop Module
2. Make the PHP part injecting the proper `context` in the `window` object, which is required for PsAccount and PsBilling.
3. Create a JS app including PsAccount and PsBilling
4. Inject the `context` in PsAccount and PsBilling

**First of all, create a basic module following the Prestashop documentation: [https://devdocs.prestashop.com/1.7/modules/creation/](https://devdocs.prestashop.com/1.7/modules/creation/)**

::: warning Compatibility
RBM is compatible from PS1.6 and PHP 5.6
::: 


</Block>

<Block>

## Backend

### PsAccount

The PsAccount module is a pre-requisite for every RBM module, it provides an SSO allowing to link the addons market's accounts to the ones in the prestashop core

</Block>


<Block>

### Composer

You must add some dependencies in the [composer.json](https://getcomposer.org/) of your newly created module. The composer `prestashop/prestashop-accounts-installer` will help you to construct the `context` required to make RBM works.

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

### <module_name>.php

> Note: For simplification, all PHP methods listed below are created in the `<module_name>.php`.
> Feel free to re-organize the code structure in another way due to the module evolution.

#### PsAccount

::: warning Requirement
Recurring Billing Modules require PsAccount to be installed on the shop in order to work.
:::

##### Load PsAccount utility

First you need to register PsAccount within your module. You should add a `getService` method. Then update the `install()` hook.

```php
class Rbm_example extends Module {
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

PsAccount needs to get some information to work. Theses information are provided by injecting a `context`.

In order to inject the `context` you should update `getContent` hook. This will inject  `contextPsAccounts` within the browser `window` object (`window.contextPsAccounts`).

::: warning PsAccount official doc
We will add a link to the official PsAccount documentation in the near future.
:::

```php
// Load context for PsAccount
$facade = $this->getService('ps_accounts.facade');
Media::addJsDef([
    'contextPsAccounts' => $facade->getPsAccountsPresenter()
        ->present($this->name),
]);
```

#### PsBilling

##### Inject PsBilling context

It is necessary to inject the `psBillingContext` into the global variable `window.psBillingContext` in order to initialize `PsBilling` related components

```php
// Load context for PsBilling
Media::addJsDef([
    'psBillingContext' => [
        'context' => [
            'versionPs' => _PS_VERSION_,
            'versionModule' => $this->version,
            'moduleName' => $this->name,
            'refreshToken' => $psAccountsService->getRefreshToken(),
            'emailSupport' => $this->emailSupport,
            'shop' => [
                'uuid' => $psAccountsService->getShopUuidV4()
            ],
            'i18n' => [
                'isoCode' => $this->getLanguageIsoCode()
            ],
            'user' => [
                'createdFromIp' => (isset($_SERVER['REMOTE_ADDR'])) ? $_SERVER['REMOTE_ADDR'] : '',
                'email' => $psAccountsService->getEmail()
            ],
            'moduleTosUrl' => $this->getTosLink()
        ]
    ]
]);
```

> In the future we will provide you a facade to automatically create the data required for the `psBillingContext`.

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

class Rbm_example extends Module
{

    private $container;
    private $psVersionIs17;
    private $emailSupport;

    public function __construct()
    {
        $this->name = 'rbm_example';
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

    /**
     * Get the isoCode from the context language, if null, send 'en' as default value
     *
     * @return string
     */
    public function getLanguageIsoCode()
    {
        return $this->context->language !== null ? $this->context->language->iso_code : 'en';
    }

    public function getContent()
    {
        $facade = $this->getService('ps_accounts.facade');
        Media::addJsDef([
            'contextPsAccounts' => $facade->getPsAccountsPresenter()
                ->present($this->name),
        ]);

        $this->context->smarty->assign('pathVendor', $this->getPathUri() . 'views/js/chunk-vendors-rbm_example.' . $this->version . '.js');
        $this->context->smarty->assign('pathApp', $this->getPathUri() . 'views/js/app-rbm_example.' . $this->version . '.js');
        try {
            $psAccountsService = $facade->getPsAccountsService();

            Media::addJsDef([
                'psBillingContext' => [
                    'context' => [
                        'versionPs' => _PS_VERSION_,
                        'versionModule' => $this->version,
                        'moduleName' => $this->name,
                        'refreshToken' => $psAccountsService->getRefreshToken(),
                        'emailSupport' => $this->emailSupport,
                        'shop' => [
                            'uuid' => $psAccountsService->getShopUuidV4()
                        ],
                        'i18n' => [
                            'isoCode' => $this->getLanguageIsoCode()
                        ],
                        'user' => [
                            'createdFromIp' => (isset($_SERVER['REMOTE_ADDR'])) ? $_SERVER['REMOTE_ADDR'] : '',
                            'email' => $psAccountsService->getEmail()
                        ],
                        'moduleTosUrl' => $this->getTosLink()
                    ]
                ]
            ]);

        } catch (ModuleNotInstalledException $e) {

            // You handle exception here

        } catch (ModuleVersionException $e) {

            // You handle exception here
        }

        return $this->context->smarty->fetch($this->template_dir . 'rbm_example.tpl');
    }

    public function getTosLink()
    {
        $iso_lang = $this->getLanguageIsoCode();
        switch ($iso_lang) {
            case 'fr':
                $url = 'https://yoururl.ltd/mentions-legales';
                break;
            default:
                $url = 'https://yoururl.ltd/legal-notice';
                break;
        }

        return $url;
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

Create the global vue app template in `views/templates/admin/<module_name>.tpl`. The name should match the name defined in `<module_name>.php` by this line:

```php
return $this->context->smarty->fetch($this->template_dir . '<module_name>.tpl');
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
yarn add @prestashopcorp/billing-cdc prestashop_accounts_vue_components
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

### Use PsBilling

Import 2 components `CustomerComponent`, `ModalContainerComponent` into the vue component

```js
import Vue from 'vue';
import { CustomerComponent, ModalContainerComponent } from "@prestashopcorp/billing-cdc/dist/bundle.umd";

//...

export default {
  components: {
    // ...
    PsBillingCustomer: CustomerComponent.driver('vue', Vue),
    PsBillingModal: ModalContainerComponent.driver('vue', Vue),
    // ...
  },
  // ...
```

Use `PsBillingCustomer`, `PsBillingModal` in the template

```html
<template>
  <div>
    <PsAccounts>
        ...
    </PsAccounts>
    <ps-billing-customer
        v-if="billingContext.user.email"
        ref="psBillingCustomerRef"
        :context="billingContext"
        :onOpenModal="openBillingModal"
    />
    <ps-billing-modal
      v-if="modalType !== ''"
      :context="billingContext"
      :type="modalType"
      :onCloseModal="closeBillingModal"
    />
    <div v-if="sub && sub.id">Rbm example content</div>
  </div>
</template>
```

The `context` should be retrieved from `window.psBillingContext.context` and injected inside the template.

```js
data() {
    return {
        billingContext: {...window.psBillingContext.context, moduleLogo},
        modalType: '',
        sub: null
    }
},
```

To display the payment funnel, and other modals, the billing components required modal to be displayed. Create 2 methods `openBillingModal` and `closeBillingModal` to handle the modal's interaction

```js
methods: {
    openBillingModal(type, data) {
        this.modalType = type;
        this.billingContext = { ...this.billingContext, ...data };
    },
    closeBillingModal(data) {
        this.modalType = '';
        this.$refs.psBillingCustomerRef.parent.updateProps({
            context: {
                ...this.billingContext,
                ...data
            }
        });
    },
    eventHookHandler(type, data) {
        switch(type) {
            case EVENT_HOOK_TYPE.BILLING_INITIALIZED:
                // data structure is: { customer, subscription }
                console.log('Billing initialized', data);
                this.sub = data.subscription;
                break;
            case EVENT_HOOK_TYPE.SUBSCRIPTION_UPDATED:
                // data structure is: { customer, subscription, card }
                console.log('Sub updated', data);
                this.sub = data.subscription;
                break;
            case EVENT_HOOK_TYPE.SUBSCRIPTION_CANCELLED:
                // data structure is: { customer, subscription }
                console.log('Sub cancelled', data);
                this.sub = data.subscription;
                break;
        }
    }
}
```

<Example>
```html
<template>
  <div>
    <PsAccounts>
    </PsAccounts>
    <ps-billing-customer
        v-if="billingContext.user.email"
        ref="psBillingCustomerRef"
        :context="billingContext"
        :onOpenModal="openBillingModal"
    />
    <ps-billing-modal
      v-if="modalType !== ''"
      :context="billingContext"
      :type="modalType"
      :onCloseModal="closeBillingModal"
    />
    <div v-if="sub && sub.id">Rbm example content</div>
  </div>
</template>
```
```js
<script>
import Vue from 'vue';
import { PsAccounts } from "prestashop_accounts_vue_components";
import moduleLogo from "@/assets/prestashop-logo.png";
import { CustomerComponent, ModalContainerComponent } from "@prestashopcorp/billing-cdc/dist/bundle.umd";

export default {
  components: {
    PsAccounts,
    PsBillingCustomer: CustomerComponent.driver('vue', Vue),
    PsBillingModal: ModalContainerComponent.driver('vue', Vue),
  },
  data() {
    return {
      billingContext: {...window.psBillingContext.context, moduleLogo},
      modalType: '',
      sub: null,
    }
  },
  provide() {
    return {
      emailSupport: window.psBillingContext.context.user.emailSupport
    }
  },
  methods: {
    openBillingModal(type, data) {
        this.modalType = type;
        this.billingContext = { ...this.billingContext, ...data };
    },
    closeBillingModal(data) {
        this.modalType = '';
        this.$refs.psBillingCustomerRef.parent.updateProps({
            context: {
                ...this.billingContext,
                ...data
            }
        });
    },
    eventHookHandler(type, data) {
        switch(type) {
            case EVENT_HOOK_TYPE.BILLING_INITIALIZED:
                // data structure is: { customer, subscription }
                console.log('Billing initialized', data);
                this.sub = data.subscription;
                break;
            case EVENT_HOOK_TYPE.SUBSCRIPTION_UPDATED:
                // data structure is: { customer, subscription, card }
                console.log('Sub updated', data);
                this.sub = data.subscription;
                break;
            case EVENT_HOOK_TYPE.SUBSCRIPTION_CANCELLED:
                // data structure is: { customer, subscription }
                console.log('Sub cancelled', data);
                this.sub = data.subscription;
                break;
        }
    },
  }
}
</script>

```
</Example>

</Block>

<Block>
#### Context in detail

Below is the details of the attributes

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

<Block>

#### Modal detail
There are 5 types of modal:

**1. AddressModal**

_openBillingModal(data)_

Data format: `{first_name, last_name, city, ...}`

_closeBillingModal(data)_

Data format: `{address: {first_name, last_name, city, ...}}` if the billing address info are saved successfully

**2. PaymentMethodModal**

_openBillingModal(data)_

Data format: `undefined`

_closeBillingModal(data)_

Data format: `{payment_method_update: true}` if the payment info are saved successfully

**3. CancelPlanModal**

_openBillingModal(data)_

Data format: `{currentSubscription: {id, module, name, ...}}`

_closeBillingModal(data)_

Data format: `{card, credit_notes, subscription, customer}` if the subscription is cancelled successfully

**4. DowngradePlanModal**

_openBillingModal(data)_

Data format: `{planToDowngrade, currentSubscription}`

_closeBillingModal(data)_

Data format: `{state, card, credit_notes, subscription, customer}` if the subscription is downgraded successfully

**5. FunnelModal**

_openBillingModal(data)_

Data format: `{selectedPlan: {id, name, price, ...}}`

_closeBillingModal(data)_

Data format: `{state, card, credit_notes, subscription, customer, invoice}` if the subscription flow has proceeded successfully

</Block>

<Block>
#### Event hook 

The event hook system allows you to be notified in the front app when a subscription changes. There are 3 types of event:

- `billing:billing_initialized`: Triggered after the PsBillingCustomer component has been rendered
- `billing:subscription_updated`: Triggered when a subscription is updated or created
- `billing:subscription_cancelled`: Triggered when a subscription is cancelled

::: warning Warning
These event hook are triggered on the Billing API HTTP call return. It may have some delay for your system to be notified of the subscription update by the webhook system. We advice you to do some [long polling](https://javascript.info/long-polling) until you the subscription update is propagated to your system.
:::


Here is the recipe to listen to this event hook:

```html{6}
    <ps-billing-customer
        v-if="billingContext.user.email"
        ref="psBillingCustomerRef"
        :context="billingContext"
        :onOpenModal="openBillingModal"
        :onEventHook="eventHookHandler"
    />
    <ps-billing-modal
      v-if="modalType !== ''"
      :context="billingContext"
      :type="modalType"
      :onCloseModal="closeBillingModal"
      :onEventHook="eventHookHandler"
    />
```

```js
// Import
import { EVENT_HOOK_TYPE } from '@prestashopcorp/billing-cdc/dist/bundle.umd';

// Add a eventHookHandler method
    methods: {
        // ...
        eventHookHandler(type, data) {
            switch(type) {
                case EVENT_HOOK_TYPE.BILLING_INITIALIZED:
                    // data structure is: { customer, subscription } 
                    console.log('Billing initialized', data);
                    break;
                case EVENT_HOOK_TYPE.SUBSCRIPTION_UPDATED:
                    // data structure is: { customer, subscription, card } 
                    console.log('Sub updated', data);
                    break;
                case EVENT_HOOK_TYPE.SUBSCRIPTION_CANCELLED:
                    // data structure is: { customer, subscription } 
                    console.log('Sub cancelled', data);
                    break;
                }
            }
        }
    }
```

<Example>
```html
<template>
  <div>
    <PsAccounts>
    </PsAccounts>
    <ps-billing-customer
        v-if="billingContext.user.email"
        ref="psBillingCustomerRef"
        :context="billingContext"
        :onOpenModal="openBillingModal"
        :onEventHook="eventHookHandler"
    />
    <ps-billing-modal
      v-if="modalType !== ''"
      :context="billingContext"
      :type="modalType"
      :onCloseModal="closeBillingModal"
      :onEventHook="eventHookHandler"
    />
  </div>
</template>
```
```js
<script>
import Vue from 'vue';
import { PsAccounts } from "prestashop_accounts_vue_components";
import moduleLogo from "@/assets/prestashop-logo.png";
import { CustomerComponent, ModalContainerComponent, EVENT_HOOK_TYPE } from "@prestashopcorp/billing-cdc/dist/bundle.umd";

export default {
  components: {
    PsAccounts,
    PsBillingCustomer: CustomerComponent.driver('vue', Vue),
    PsBillingModal: ModalContainerComponent.driver('vue', Vue),
  },
  data() {
    return {
      billingContext: {...window.psBillingContext.context, moduleLogo},
      modalType: '',
    }
  },
  methods: {
    openBillingModal(type, data) {
        this.modalType = type;
        this.billingContext = { ...this.billingContext, ...data };
    },
    closeBillingModal(data) {
        this.modalType = '';
        this.$refs.psBillingCustomerRef.parent.updateProps({
            context: {
                ...this.context,
                ...data
            }
        });
    },
    eventHookHandler(type, data) {
        switch(type) {
            case EVENT_HOOK_TYPE.BILLING_INITIALIZED:
                // Do what you want to do when ps-billing-customer is initialized
                break;
            case EVENT_HOOK_TYPE.SUBSCRIPTION_UPDATED:
                // Do what you want to do on sub update
                break;
            case EVENT_HOOK_TYPE.SUBSCRIPTION_CANCELLED:
                // Do what you want to do on sub cancel
                break;
            }
        }
    }
  }
}
</script>

```
</Example>

</Block>

<Block>
#### Pass data through PsBilling

The `PsBillingCustomer` component allows you to `emit` an event to initialize the billing customer in a specific state. **The most common use case for this emitter is when you have a free plan and want your customer to subscribe immediately to this free plan.**

To achieve this, first of all, you need to create a ref to the `PsBillingCustomer` component, which allow you to use some method from this component.

```html{2}
<ps-billing-customer
    ref="psBillingCustomerRef"
    :context="billingContext"
    :onOpenModal="openBillingModal"
/>
```

Then in the `created` hook, you call the `emit` function from `CustomerComponent`.

```js{4}
export default {
    // ...
    created() {
        this.$refs.psBillingCustomerRef.emit('init:billing', {
            'CREATE_SUBSCRIPTION': {
                // This is the id of your free plan
                planId: 'default-free'
            }
        });
    }
    // ...
}
```

</Block>
