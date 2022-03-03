---
title: Overview
---


# ![](/assets/images/common/logo-condensed-sm.png) Overview

Recurring Billing Modules allow Tech Partners and Sellers to create SaaS modules integrated within the PrestaShop ecosystem with a simple and unified onboarding for Merchants.

Subscriptions are managed and billed by the PrestaShop Billing system which pays back the module creator through an automatic monthly payment.

![SaaS App Schema](/assets/images/0-overview/schema.png)

## Building a SaaS App

The creation of a Recurring Billing Module requires to interract with PsAccount and PsBilling.

![SaaS App fully initialized](/assets/images/0-overview/rbm_fully_initialized.png)

### PsAccount

PsAccount designate a tool suite to link a PrestaShop Module with the PrestaShop's Accounts. It allow you and PrestaShop to identify the merchant in the PrestaShop system. PsAccount is composed by:

- A module, which need to be installed on the shop. This installation is automatic.
- The PrestaShop's Accounts API for shop authentication and verification
- A frontend component required into your module's configuration page.

#### PsAccount component when your shop is not linked

![PsAccount not linkd](/assets/images/0-overview/ps_account_not_linked.png)

#### PsAccount component when your shop is linked

![PsAccount linked](/assets/images/0-overview/ps_account_linked.png)

### PsBilling

PsBilling designate a tool suite to manage merchant subscription to your recurring billing module. PsBilling is composed by:

- The Billing API wich store the subscription
- A frontend component required into your module's configuration page. this component is splitted in 2 main part: the merchant subscription panel, and the funnel modal

#### PsBilling without subscription

![PsBilling without subscription](/assets/images/0-overview/ps_billing_no_plan.png)

#### PsBilling with a subscription

![PsBilling with a subscription](/assets/images/0-overview/ps_billing_subscription.png)

#### PsBilling plan chooser in the funnel modal

![PsBilling with a subscription](/assets/images/0-overview/ps_billing_funnel_plans.png)

#### PsBilling subscription summary in the funnel modal

![PsBilling with a subscription](/assets/images/0-overview/ps_billing_funnel_summary.png)
