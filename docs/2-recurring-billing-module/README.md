---
title: Recurring Billing Module
---

<Block>

# ![](/assets/images/common/logo-condensed-sm.png) Recurring Billing Module


A recurring Billing Module is [todo : add RBM description].

::: tip
In the future Vue 2 may not be required as the Prestashop Billing Component doesn't require it.
:::

Here is the step to convert your Partner Module in a RBM :

1. todo
2. todo

::: warning Compatibility
RBM is compatible from PrestaShop 1.6.1.x and PHP 5.6
:::

</Block>

<Block>

## Backend


### <your_module_name>.php

> Note: For simplification, all PHP methods listed below are created in the `<your_module_name>.php`.
> Feel free to re-organize the code structure in another way due to the module evolution.

::: warning Requirement
Recurring Billing Modules require PsAccount to be installed on the shop in order to work.
:::

#### Inject PsBilling context

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


<Example>
```php{61-69,84-105,119-132}
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

        $this->displayName = $this->l('your_module_name');
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

        return $this->context->smarty->fetch($this->template_dir . 'your_module_name.tpl');
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

## Frontend

### Add required dependencies

```bash
yarn add @prestashopcorp/billing-cdc
```

</Block>
<Block>

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
```html{5-16}
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
```js{5,10,11,13-58}
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
