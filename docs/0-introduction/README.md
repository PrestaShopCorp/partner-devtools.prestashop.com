---
title: introduction
---

# Who is this documentation for?

This documentation is intended for **technology vendors**: partners, sellers, developers, and agencies who **create and distribute modules and/or themes** that will be added to the PrestaShop Addons Marketplace.

# Why read this?

PrestaShop is an extremely customizable e-commerce platform that was designed so that third-party modules could easily build upon its foundations.

The goal of this documentation is to help you **create modules integrated with the PrestaShop ecosystem** using PrestaShop Toolkit to optimize development and usability.

# What is PrestaShop Toolkit?

Previously known as "SaaS App", PrestaShop Toolkit is an integration framework provided by PrestaShop. Including several different services that you can select according to your needs, it improves merchant experience and streamlines the development of commonly used features such as billing and data synchronization.

## PrestaShop Toolkit services

### PrestaShop Account

Required to use any other PrestaShop Toolkit service, PrestaShop Account establishes a link between the module and the PrestaShop accounts. It allows you and PrestaShop to identify the merchant in the PrestaShop system.

Once the module has been configured to establish a connection, merchants are automatically logged in, which helps them save time. PrestaShop Account also improves technology vendors visibility on merchant data, allowing them to gain insights on merchant conversions.

### PrestaShop Billing

PrestaShop Billing allows the PrestaShop billing system to deal with the management and invoicing of merchant subscriptions, allowing merchants to enjoy an optimized payment experience and technology vendors to receive monthly payments automatically. It also improves GDPR compliance, as merchants are requested to consent to the processing of their data when proceeding to payment.

### PrestaShop CloudSync

PrestaShop CloudSync takes charge of the duplication and synchronization of merchant data on PrestaShop servers, thus reducing complexity and bugs. Its easy-to-use APIs allow technology vendors to access merchant data more easily so they can better analyze their behavior.

### PrestaShop Design system (currently in development)

PrestaShop Design system consists in module configuration page templates. It simplifies greatly the configuration process and allows existing merchants to adopt new modules easily.

# Prerequisites

## Compatibility chart

The following configuration is required to integrate your module with PrestaShop Toolkit:

| PrestaShop platform | PHP          | PrestaShop Account    | PrestaShop Billing (components)    | PrestaShop Billing (PHP helper)    | PrestaShop CloudSync (EventBus)    |
| ------------------- | ------------ | --------------------- | ---------------------------------- | ---------------------------------- | ---------------------------------- |
| 8.0                 | 7.2 – 8.1    | 6.x                   | Yes                                | 2.x                                | 1.8.0                              |
| 1.7.8               | 7.1 – 7.4    | 5.x                   | Yes                                | 1.x                                | 1.6.10 – 1.7.x                     |
| 1.7.7               | 7.1 – 7.3    | 5.x                   | Yes                                | 1.x                                | 1.6.10 – 1.7.x                     |
| 1.7.5 – 1.7.6       | 5.6 – 7.2    | 5.x                   | Yes                                | 1.x                                | 1.6.10 – 1.7.x                     |
| 1.7.4               | 5.6 – 7.1    | 5.x                   | Yes                                | 1.x                                | 1.6.10 – 1.7.x                     |
| 1.7.0 – 1.7.3       | 5.6 – 7.1    | 5.x                   | Yes                                | 1.x                                | 1.6.10 – 1.7.x                     |
| 1.6.1.x             | 5.6 – 7.1    | 5.x                   | Yes                                | 1.x                                | 1.6.4 – 1.6.9                      |

## Supported languages
To integrate your module with PrestaShop Toolkit, you need to use the following languages:

- [PHP](https://www.php.net/) for the backend
- [Vue.js 3](https://vuejs.org/), Vanilla JavaScript, or React for the frontend

# Getting help

If you need any extra help, please get in touch with your solution engineer at PrestaShop.
