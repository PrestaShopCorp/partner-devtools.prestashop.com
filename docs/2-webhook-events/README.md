---
title: Webhook & Events
---

<Block>

# ![](/assets/images/common/logo-condensed-sm.png) Webhook & Events

</Block>

<Block>

::: danger Disclaimer
This is a draft version, the format of the data sent, the events triggered are likely to change
:::

When a change happens on Prestashop Billing API, you will be notify by [webhook](https://en.wikipedia.org/wiki/Webhook).

To start using these webhook you should:
1. Create a POST endpoint which be called every time an event is triggered
2. Configure the webhook in Prestashop Billing. **For the moment, we will handle this manually.**

During call API, your endpoint should return a 2xx HTTP status to indicates that you handle the call without trouble. In case the HTTP status is not 2xx we retry the API call at exponential time intervals.

</Block>

<Block>

## Events

Here is the exhaustive list of event triggered.

> Timestamp are UTC in seconds

### Subscription

* `subscription_created` - Triggered when a subscription is created.
* `subscription_updated` - Triggered when a subscription is updated. A plan upgrade will trigger this event.
* `subscription_cancelled` - Triggered when a subscription is cancelled. It's not triggered when a customer ask for a cancellation, but when the cancellation is effective

<Example>
```json
{
  "customer": {
    "ps_shop_id": "93633bec-6bc8-474d-80df-3be115780ad1",
    "email": "john.doe@mail.com",
    "billing_address": {
      "city": "Paris",
      "country": "FR" (ISO 3166-1 - alpah-2),
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
    "items": [{
	    "type": "plan",
	    "item_id": "foobar-advanced",
	    "trial_end": 1517505731,
	    "start_date": 1517505731,
        "created_at": 1517505731,
        "updated_at": 1517505731
     }],
     "status": "active",
     "created_at": 1517505731,
     "updated_at": 1517505731
  }
}
```
</Example>

</Block>

<Block>
### Customer

* `customer_created`: Triggered when a customer is created
* `customer_updated`: Triggered when a customer is updated

<Example>
```json
{
  "customer": {
    "ps_shop_id": "93633bec-6bc8-474d-80df-3be115780ad1",
    "email": "john.doe@mail.com",
    "billing_address": {
      "city": "Paris",
      "country": "FR" (ISO 3166-1 - alpah-2),
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
```
</Example>

</Block>

## Authentication

*In progress*

