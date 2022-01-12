---
title: How to setup dev environment
---

# ![](/assets/images/common/logo-condensed-sm.png) Setup dev environment

## localhost.run

[localhost.run](http://localhost.run/) is a required dev dependency to link the ps account

Execute the command `ssh -R 80:localhost:8080 <domain name>` so that the localhost:8080 will be exposed to the internet via the new `<domain name>`

For more information about localhost.run, CF the [official doc](http://localhost.run/docs/)

## PrestaShop

**Step 1**: setup the [prestashop core](https://github.com/PrestaShop/docker)

**Step 2**: on the left menu, go to the `Configure section` -> `Shop parameters` -> `Traffic & SEO`, then in the `Set shop url` section on the right section, fill in the new domain name in the 2 textboxes `Shop domain`, `SSL domain`, then, save the settings.

![Change domain name](/assets/images/4-setup-dev-environment/change_domain_name.png)

## Install the ps_account_integration module

Install the ps_account_integration.zip (contact the developers for more information about this zip) and link your account in the ps_account configurtion page

## PrestaShop RBM module

**Step 1**: create a classic prestashop module, please CF the [official doc](https://devdocs.prestashop.com/1.7/modules/creation/tutorial/)

**Step 2**: convert the module into [RBM module](../1-recurring-billing-module/README.md)

An example of RBM module is also available for [reference](https://github.com/PrestaShopCorp/prestashop_rbm_example)

**Step 3**: contact the developpers to create a customer and a subscription for the shop (this will be changed in the future)
