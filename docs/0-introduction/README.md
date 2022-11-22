---
title: introduction
---


# Who is this documentation for?

This documentation is intended for technology vendors: partners, developers, and agencies who create and sell modules and/or themes that will be added to the PrestaShop catalog, and possibly the PrestaShop Addons Marketplace.

# Why read this documentation?

PrestaShop is an extremely customizable e-commerce platform that was designed so that third-party modules could easily build upon its foundations.

The goal of this documentation is to help you create modules integrated with the PrestaShop ecosystem using PrestaShop Toolkit, so that merchants can enjoy a simpler and more unified experience.

# Why use PrestaShop Toolkit?

PrestaShop Toolkit is a set of software components provided by PrestaShop to improve  merchants' experience and streamline the development of commonly used features such as billing and data synchronization. They include:

- PrestaShop Account: Mandatory to be able to use any other tool, PrestaShop Account allows merchant data collection. It establishes a permanent link between the merchant's PrestaShop account and their shop.

- PrestaShop Billing: This tool allows the PrestaShop billing system to deal with the management and invoicing of merchants' subscriptions, allowing merchants to enjoy an optimized payment experience and technology vendors to receive automatic monthly payments.

- PrestaShop CloudSync: This tool allows PrestaShop to take charge of the duplication and synchronization of merchants' data on PrestaShop servers so they can be accessed through easy-to-use APIs, reducing complexity and bugs.

# What do I need to get started?

## Compatibility Chart

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

# Support

If you need any extra help, please get in touch with your solution engineer at PrestaShop.
