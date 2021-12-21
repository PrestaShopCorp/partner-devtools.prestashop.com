---
title: Webhook & Events
---

<Block>

# ![](/assets/images/common/logo-condensed-sm.png) Webhook & Events

</Block>

<Block>


When a change happens on Prestashop Billing API, you will be notify by a [webhook system](https://en.wikipedia.org/wiki/Webhook).

To start using these webhook you should:
1. Create a POST endpoint which be called every time an event is triggered
2. Configure the webhook in Prestashop Billing. **For the moment, we will handle this manually.**

During call API, your endpoint should return a 2xx HTTP status to indicates that you handle the call without trouble. **In case the HTTP status is not 2xx we retry the API call at exponential time intervals until we receive a 2xx HTTP response.**

</Block>

<Block>

## Events

::: tip Timestamps
Timestamp are UTC in seconds
::: 

Every events body follow this structure:

```js
{
  "eventType": string,
  "data": object
}
```

Here is an exhaustive list of event triggered.


### Subscription

* `subscription.created` - Triggered when a subscription is created.
* `subscription.updated` - Triggered when a subscription is updated. A plan upgrade will trigger this event.
* `subscription.canceled` - Triggered when a subscription is cancelled. It's not triggered when a customer ask for a cancellation, but when the cancellation is effective.

All the subscription event data follow this structure

| Value        | Type | Description |
| ------------ | ---- | ----------- |
| customer     | [Customer](https://apidocs.chargebee.com/docs/api/customers?prod_cat_ver=1#customer_attributes) | Customer for which the subscription has changed |
| subscription | [Subscription](https://apidocs.chargebee.com/docs/api/subscriptions?prod_cat_ver=1#subscription_attributes) | The modified subscription |


<Example>
```json
{
  "eventType": "subscription.created",
  "data": {
    "customer": {
      "id": "93633bec-6bc8-474d-80df-3be115780ad1",
      "ps_shop_id": "93633bec-6bc8-474d-80df-3be115780ad1",
      "email": "john.doe@mail.com",
      "billing_address": {
        "city": "Paris",
        "country": "FR" (ISO 3166-1 - alpha-2),
        "first_name": "John",
        "last_name": "Doe",
        "line1": "1 rue de Rivoli",
        "line2": "Bâtiment A",
        "state": "France",
        "zip": 75001
      },
      "meta_data": {
        "shop_url": "https://www.domain.ltd"
      },
      "deleted": false,
      "created_at": 1517505731,
      "updated_at": 1517505731
    },
    "subscription": {
      "activated_at": 1517505643,
      "billing_period": 1,
      "billing_period_unit": "month",
      "created_at": 1517505643,
      "currency_code": "USD",
      "customer_id": "93633bec-6bc8-474d-80df-3be115780ad1",
      "deleted": false,
      "id": "__test__KyVnHhSBWkkwI2Tn",
      "next_billing_at": 1519924843,
      "object": "subscription",
      "plan_amount": 895,
      "plan_free_quantity": 0,
      "plan_id": "no_trial",
      "plan_quantity": 1,
      "plan_unit_price": 895,
      "started_at": 1517505643,
      "status": "active",
      "updated_at": 1517505643
    }
  }
}
```
</Example>

</Block>

<Block>
### Payment

* `payment.failed`: Triggered when a payment fail
* `payment.succeeded`: Triggered when a payment succeed


All the payment event data follow this structure

| Value        | Type | Description |
| ------------ | ---- | ----------- |
| customer     | [Customer](https://apidocs.chargebee.com/docs/api/customers?prod_cat_ver=1#customer_attributes) | Customer for which the subscription has changed |
| subscription | [Subscription](https://apidocs.chargebee.com/docs/api/subscriptions?prod_cat_ver=1#subscription_attributes) | The modified subscription |
| subscription | [Transaction](https://apidocs.chargebee.com/docs/api/transactions?prod_cat_ver=1#transaction_attributes) | The payment transaction |



<Example>
```json
{
  "eventType": "payment.failed",
  "data": {
    "customer": {
      "id": "93633bec-6bc8-474d-80df-3be115780ad1",
      "ps_shop_id": "93633bec-6bc8-474d-80df-3be115780ad1",
      "email": "john.doe@mail.com",
      "billing_address": {
        "city": "Paris",
        "country": "FR" (ISO 3166-1 - alpha-2),
        "first_name": "John",
        "last_name": "Doe",
        "line1": "1 rue de Rivoli",
        "line2": "Bâtiment A",
        "state": "France",
        "zip": 75001
      },
      "deleted": false,
      "created_at": 1517505731,
      "updated_at": 1517505731
    },
    "subscription": {
      "activated_at": 1517505643,
      "billing_period": 1,
      "billing_period_unit": "month",
      "created_at": 1517505643,
      "currency_code": "USD",
      "customer_id": "93633bec-6bc8-474d-80df-3be115780ad1",
      "deleted": false,
      "id": "__test__KyVnHhSBWkkwI2Tn",
      "next_billing_at": 1519924843,
      "object": "subscription",
      "plan_amount": 895,
      "plan_free_quantity": 0,
      "plan_id": "no_trial",
      "plan_quantity": 1,
      "plan_unit_price": 895,
      "started_at": 1517505643,
      "status": "active",
      "updated_at": 1517505643
    },
    "transaction": {
      "id": "txn_AzZvc2SdMoKel8tAP",
      "customer_id": "93633bec-6bc8-474d-80df-3be115780ad1",
      "subscription_id": "AzZlpDSZGCgwPNZ5",
      "gateway_account_id": "gw_Azqe1TSLVjdNhdI",
      "payment_source_id": "pm_AzyuESSZGSXrKSlz",
      "payment_method": "card",
      "gateway": "stripe",
      "type": "payment",
      "date": 1626472852,
      "exchange_rate": 1.0,
      "amount": 2280,
      "id_at_gateway": "ch_1JDz5UGp5Dc2lo8uQjiYPLkr",
      "status": "failure",
      "error_code": "expired_card",
      "error_text": "Your card has expired.",
      "updated_at": 1626472853,
      "fraud_reason": "The bank returned the decline code `expired_card`.",
      "resource_version": 1626472853702,
      "deleted": false,
      "object": "transaction",
      "masked_card_number": "************1111",
      "currency_code": "EUR",
      "base_currency_code": "EUR",
      "amount_unused": 0,
      "linked_invoices": [{
          "invoice_id": "767",
          "applied_amount": 2280,
          "applied_at": 1626472853,
          "invoice_date": 1625263200,
          "invoice_total": 2280,
          "invoice_status": "paid"
      }],
      "linked_refunds": []
    }
  }
}
```
</Example>

</Block>


<Block>
### Customer

* `customer.created`: Triggered when a customer is created, which happens only one time for a shop. You can't expect to receive this event for your RBM.
* `customer.updated`: Triggered when a customer is updated

All the customer event data follow this structure

| Value        | Type | Description |
| ------------ | ---- | ----------- |
| customer     | [Customer](https://apidocs.chargebee.com/docs/api/customers?prod_cat_ver=1#customer_attributes) | Customer whose the billing address has been changed |

<Example>
```json
{
  "eventType": "customer-billing-address.created",
  "data": {
    "customer": {
      "ps_shop_id": "93633bec-6bc8-474d-80df-3be115780ad1",
      "email": "john.doe@mail.com",
      "billing_address": {
        "city": "Paris",
        "country": "FR" (ISO 3166-1 - alpha-2),
        "first_name": "John",
        "last_name": "Doe",
        "line1": "1 rue de Rivoli",
        "line2": "Bâtiment A",
        "state": "France",
        "zip": 75001
      },
      "deleted": false,
      "created_at": 1517505731,
      "updated_at": 1517505731
    }
  }
}
```
</Example>

</Block>

<Block>
### Customer billing address

* `customer-billing-address.updated`: Triggered when a customer billing address is updated

All the customer event data follow this structure

| Value        | Type | Description |
| ------------ | ---- | ----------- |
| customer     | [Customer](https://apidocs.chargebee.com/docs/api/customers?prod_cat_ver=1#customer_attributes) | Customer for which the subscription has changed |

<Example>
```json
{
  "eventType": "customer-billing-address.created",
  "data": {
    "customer": {
      "ps_shop_id": "93633bec-6bc8-474d-80df-3be115780ad1",
      "email": "john.doe@mail.com",
      "billing_address": {
        "city": "Paris",
        "country": "FR" (ISO 3166-1 - alpha-2),
        "first_name": "John",
        "last_name": "Doe",
        "line1": "1 rue de Rivoli",
        "line2": "Bâtiment A",
        "state": "France",
        "zip": 75001
      },
      "deleted": false,
      "created_at": 1517505731,
      "updated_at": 1517505731
    }
  }
}
```
</Example>

</Block>

## Authentication

*In progress*

