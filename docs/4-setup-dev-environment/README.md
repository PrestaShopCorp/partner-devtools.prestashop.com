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

## PrestaShop SaaS App module

**Step 1**: create a classic PrestaShop module, please CF the [official doc](https://devdocs.prestashop.com/1.7/modules/creation/tutorial/)

**Step 2**: convert the module into [SaaS App module](../2-saas-app/README.md)

An example of SaaS App module is also available for [reference](https://github.com/PrestaShopCorp/partner-devtools.prestashop.com/tree/main/modules/rbm_example)

**Step 3**: contact the developpers to create a customer and a subscription for the shop (this will be changed in the future)
