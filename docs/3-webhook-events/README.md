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

Every events body follow this structure and contains `customer` :

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
    "shopId": "d673f3d0-86b1-4193-a714-dc9c487ec767",
    "chargebeeCustomerId": "d673f3d0-86b1-4193-a714-dc9c487ec767",
    "customer": {
      "id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
      "email": "john.doe@prestashop.com",
      "auto_collection": "on",
      "net_term_days": 0,
      "allow_direct_debit": false,
      "is_location_valid": true,
      "created_at": 1639489665,
      "created_from_ip": "37.59.216.43",
      "taxability": "taxable",
      "updated_at": 1641367315,
      "pii_cleared": "active",
      "channel": "web",
      "resource_version": 1641367315861,
      "deleted": false,
      "object": "customer",
      "billing_address": {
        "first_name": "John",
        "last_name": "Doe",
        "company": "company",
        "line1": "1 rue de Rivoli",
        "city": "Paris",
        "country": "FR",
        "zip": "85000",
        "validation_status": "not_validated",
        "object": "billing_address"
      },
      "card_status": "valid",
      "relationship": {
        "parent_id": "Cpnr7otANbbqcliaHCbco",
        "payment_owner_id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
        "invoice_owner_id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
        "root_id": "Cpnr7otANbbqcliaHCbco"
      },
      "use_default_hierarchy_settings": true,
      "parent_account_access": {
        "portal_edit_child_subscriptions": "yes",
        "portal_download_child_invoices": "yes",
        "send_subscription_emails": true,
        "send_payment_emails": true,
        "send_invoice_emails": true
      },
      "child_account_access": {
        "portal_edit_subscriptions": "yes",
        "portal_download_invoices": "yes",
        "send_subscription_emails": true,
        "send_payment_emails": true,
        "send_invoice_emails": true
      },
      "promotional_credits": 0,
      "refundable_credits": 0,
      "excess_payments": 0,
      "unbilled_charges": 0,
      "preferred_currency_code": "EUR",
      "primary_payment_source_id": "pm_6oZmhSsKtNhO4puJ",
      "payment_method": {
        "object": "payment_method",
        "type": "card",
        "reference_id": "cus_Km9gpGiTwLYPzA/card_1K9WdDGp5Dc2lo8uY9G6Or4r",
        "gateway": "stripe",
        "gateway_account_id": "gw_Azqe1TSLVjdNhdI",
        "status": "valid"
      },
      "business_customer_without_vat_number": false,
      "cf_shop_id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
      "cf_consent": "False",
      "meta_data": {
        "shop_url": "https://my-shop.prestashop.com"
      }
    },
    "subscription": {
      "id": "AzZltzSnnXURXasn",
      "plan_id": "default-free",
      "plan_quantity": 1,
      "plan_unit_price": 100,
      "billing_period": 1,
      "billing_period_unit": "month",
      "trial_end": 1635980400,
      "customer_id": "AzZluuSkIEXas24Mv",
      "plan_amount": 100,
      "plan_free_quantity": 0,
      "status": "active",
      "trial_start": 1635980400,
      "current_term_start": 1636412400,
      "current_term_end": 1639004399,
      "next_billing_at": 1639004400,
      "created_at": 1636029127,
      "started_at": 1635980400,
      "activated_at": 1636066800,
      "updated_at": 1636467088,
      "has_scheduled_changes": false,
      "channel": "web",
      "resource_version": 1636467088785,
      "deleted": false,
      "object": "subscription",
      "currency_code": "EUR",
      "due_invoices_count": 1,
      "due_since": 1636412400,
      "total_dues": 120,
      "mrr": 100,
      "exchange_rate": 1,
      "base_currency_code": "EUR",
      "override_relationship": false,
      "trial_end_action": "site_default",
      "meta_data": {
        "module": "rbm-example"
      }
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
  "data": {
    "module_id": "foobar",
    "customer": {
      "id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
      "email": "john.doe@prestashop.com",
      "auto_collection": "on",
      "net_term_days": 0,
      "allow_direct_debit": false,
      "is_location_valid": true,
      "created_at": 1639489665,
      "created_from_ip": "37.59.216.43",
      "taxability": "taxable",
      "updated_at": 1641367315,
      "pii_cleared": "active",
      "channel": "web",
      "resource_version": 1641367315861,
      "deleted": false,
      "object": "customer",
      "billing_address": {
        "first_name": "John",
        "last_name": "Doe",
        "company": "company",
        "line1": "1 rue de Rivoli",
        "city": "Paris",
        "country": "FR",
        "zip": "85000",
        "validation_status": "not_validated",
        "object": "billing_address"
      },
      "card_status": "valid",
      "relationship": {
        "parent_id": "Cpnr7otANbbqcliaHCbco",
        "payment_owner_id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
        "invoice_owner_id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
        "root_id": "Cpnr7otANbbqcliaHCbco"
      },
      "use_default_hierarchy_settings": true,
      "parent_account_access": {
        "portal_edit_child_subscriptions": "yes",
        "portal_download_child_invoices": "yes",
        "send_subscription_emails": true,
        "send_payment_emails": true,
        "send_invoice_emails": true
      },
      "child_account_access": {
        "portal_edit_subscriptions": "yes",
        "portal_download_invoices": "yes",
        "send_subscription_emails": true,
        "send_payment_emails": true,
        "send_invoice_emails": true
      },
      "promotional_credits": 0,
      "refundable_credits": 0,
      "excess_payments": 0,
      "unbilled_charges": 0,
      "preferred_currency_code": "EUR",
      "primary_payment_source_id": "pm_6oZmhSsKtNhO4puJ",
      "payment_method": {
        "object": "payment_method",
        "type": "card",
        "reference_id": "cus_Km9gpGiTwLYPzA/card_1K9WdDGp5Dc2lo8uY9G6Or4r",
        "gateway": "stripe",
        "gateway_account_id": "gw_Azqe1TSLVjdNhdI",
        "status": "valid"
      },
      "business_customer_without_vat_number": false,
      "cf_shop_id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
      "cf_consent": "False",
      "meta_data": {
        "shop_url": "https://my-shop.prestashop.com"
      }
    },
    "subscription": {
      "id": "AzZltzSnnXURXasn",
      "plan_id": "default-free",
      "plan_quantity": 1,
      "plan_unit_price": 100,
      "billing_period": 1,
      "billing_period_unit": "month",
      "trial_end": 1635980400,
      "customer_id": "AzZluuSkIEXas24Mv",
      "plan_amount": 100,
      "plan_free_quantity": 0,
      "status": "active",
      "trial_start": 1635980400,
      "current_term_start": 1636412400,
      "current_term_end": 1639004399,
      "next_billing_at": 1639004400,
      "created_at": 1636029127,
      "started_at": 1635980400,
      "activated_at": 1636066800,
      "updated_at": 1636467088,
      "has_scheduled_changes": false,
      "channel": "web",
      "resource_version": 1636467088785,
      "deleted": false,
      "object": "subscription",
      "currency_code": "EUR",
      "due_invoices_count": 1,
      "due_since": 1636412400,
      "total_dues": 120,
      "mrr": 100,
      "exchange_rate": 1,
      "base_currency_code": "EUR",
      "override_relationship": false,
      "trial_end_action": "site_default",
      "meta_data": {
        "module": "rbm-example"
      }
    },
    "transaction": {
      "id": "txn_Azz5uVSoHB7gi16HQ",
      "customer_id": "AzZluuSkIEXas24Mv",
      "subscription_id": "AzZltzSnnXURXasn",
      "gateway_account_id": "gw_Azqe1TSLVjdNhdI",
      "payment_source_id": "pm_AzZlyjSoHAvW5Jdw",
      "payment_method": "card",
      "gateway": "stripe",
      "type": "payment",
      "date": 1636467087,
      "exchange_rate": 1,
      "amount": 120,
      "id_at_gateway": "ch_3Jtv2pGp5Dc2lo8u16q8AjHP",
      "status": "failure",
      "error_code": "authentication_required",
      "error_text": "Your card was declined. This transaction requires authentication.",
      "updated_at": 1636467088,
      "fraud_reason": "The bank returned the decline code `authentication_required`.",
      "resource_version": 1636467088743,
      "deleted": false,
      "object": "transaction",
      "masked_card_number": "************3184",
      "currency_code": "EUR",
      "base_currency_code": "EUR",
      "amount_unused": 0,
      "linked_invoices": [
        {
          "invoice_id": "1531",
          "applied_amount": 120,
          "applied_at": 1636467088,
          "invoice_date": 1636412400,
          "invoice_total": 120,
          "invoice_status": "payment_due"
        }
      ],
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
  "eventType": "customer.updated",
  "data": {
    "customer": {
      "id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
      "email": "john.doe@prestashop.com",
      "auto_collection": "on",
      "net_term_days": 0,
      "allow_direct_debit": false,
      "is_location_valid": true,
      "created_at": 1639489665,
      "created_from_ip": "37.59.216.43",
      "taxability": "taxable",
      "updated_at": 1641367315,
      "pii_cleared": "active",
      "channel": "web",
      "resource_version": 1641367315861,
      "deleted": false,
      "object": "customer",
      "billing_address": {
        "first_name": "John",
        "last_name": "Doe",
        "company": "company",
        "line1": "1 rue de Rivoli",
        "city": "Paris",
        "country": "FR",
        "zip": "85000",
        "validation_status": "not_validated",
        "object": "billing_address"
      },
      "card_status": "valid",
      "relationship": {
        "parent_id": "Cpnr7otANbbqcliaHCbco",
        "payment_owner_id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
        "invoice_owner_id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
        "root_id": "Cpnr7otANbbqcliaHCbco"
      },
      "use_default_hierarchy_settings": true,
      "parent_account_access": {
        "portal_edit_child_subscriptions": "yes",
        "portal_download_child_invoices": "yes",
        "send_subscription_emails": true,
        "send_payment_emails": true,
        "send_invoice_emails": true
      },
      "child_account_access": {
        "portal_edit_subscriptions": "yes",
        "portal_download_invoices": "yes",
        "send_subscription_emails": true,
        "send_payment_emails": true,
        "send_invoice_emails": true
      },
      "promotional_credits": 0,
      "refundable_credits": 0,
      "excess_payments": 0,
      "unbilled_charges": 0,
      "preferred_currency_code": "EUR",
      "primary_payment_source_id": "pm_6oZmhSsKtNhO4puJ",
      "payment_method": {
        "object": "payment_method",
        "type": "card",
        "reference_id": "cus_Km9gpGiTwLYPzA/card_1K9WdDGp5Dc2lo8uY9G6Or4r",
        "gateway": "stripe",
        "gateway_account_id": "gw_Azqe1TSLVjdNhdI",
        "status": "valid"
      },
      "business_customer_without_vat_number": false,
      "cf_shop_id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
      "cf_consent": "False",
      "meta_data": {
        "shop_url": "https://my-shop.prestashop.com"
      }
    },
    "chargebeeCustomerId": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
    "shopId": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
    "createdFromIp": "10.0.1.13"
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
| customer | [Customer](https://apidocs.chargebee.com/docs/api/customers?prod_cat_ver=1#customer_attributes) | The customer concerned by this event
| billingAddress | [BillingAddress](https://apidocs.chargebee.com/docs/api/customers?prod_cat_ver=1#customer_billing_address) | The billing address of the customer
| vatNumber     | string | The VAT number |

<Example>
```json
{
  "eventType": "customer-billing-address.updated",
  "data": {
    "customer": {
      "id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
      "email": "john.doe@prestashop.com",
      "auto_collection": "on",
      "net_term_days": 0,
      "allow_direct_debit": false,
      "is_location_valid": true,
      "created_at": 1639489665,
      "created_from_ip": "37.59.216.43",
      "taxability": "taxable",
      "updated_at": 1641367315,
      "pii_cleared": "active",
      "channel": "web",
      "resource_version": 1641367315861,
      "deleted": false,
      "object": "customer",
      "billing_address": {
        "first_name": "John",
        "last_name": "Doe",
        "company": "company",
        "line1": "1 rue de Rivoli",
        "city": "Paris",
        "country": "FR",
        "zip": "85000",
        "validation_status": "not_validated",
        "object": "billing_address"
      },
      "card_status": "valid",
      "relationship": {
        "parent_id": "Cpnr7otANbbqcliaHCbco",
        "payment_owner_id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
        "invoice_owner_id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
        "root_id": "Cpnr7otANbbqcliaHCbco"
      },
      "use_default_hierarchy_settings": true,
      "parent_account_access": {
        "portal_edit_child_subscriptions": "yes",
        "portal_download_child_invoices": "yes",
        "send_subscription_emails": true,
        "send_payment_emails": true,
        "send_invoice_emails": true
      },
      "child_account_access": {
        "portal_edit_subscriptions": "yes",
        "portal_download_invoices": "yes",
        "send_subscription_emails": true,
        "send_payment_emails": true,
        "send_invoice_emails": true
      },
      "promotional_credits": 0,
      "refundable_credits": 0,
      "excess_payments": 0,
      "unbilled_charges": 0,
      "preferred_currency_code": "EUR",
      "primary_payment_source_id": "pm_6oZmhSsKtNhO4puJ",
      "payment_method": {
        "object": "payment_method",
        "type": "card",
        "reference_id": "cus_Km9gpGiTwLYPzA/card_1K9WdDGp5Dc2lo8uY9G6Or4r",
        "gateway": "stripe",
        "gateway_account_id": "gw_Azqe1TSLVjdNhdI",
        "status": "valid"
      },
      "business_customer_without_vat_number": false,
      "cf_shop_id": "b2581e4b-0030-4fc8-9bf2-7f01c550a946",
      "cf_consent": "False",
      "meta_data": {
        "shop_url": "https://my-shop.prestashop.com"
      }
    },
    "billingAddress": {
      "first_name": "John",
      "last_name": "Doe",
      "company": "company",
      "line1": "1 rue de Rivoli",
      "city": "Paris",
      "country": "FR",
      "zip": "85000",
      "validation_status": "not_validated",
      "object": "billing_address"
    },
    "vatNumber": ""
  }
}
```
</Example>

</Block>

## Security

An Authorization header will be sent to the merchant's API to ensure security.

```json
{
  headers: {
    Authorization: Basic <token>
  }
}
```
A common use case is that the merchant will verify this token for each incoming webhook request to make sure that they are from the Prestashop Webhook API.