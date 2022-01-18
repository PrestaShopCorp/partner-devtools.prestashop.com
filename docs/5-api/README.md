---
title: Routes
---
<Block>

# ![](/assets/images/common/logo-condensed-sm.png) About API routes

This page introduces the available routes in order to communicate directly with the Billing API

</Block>

<Block>

## Update subscription quantity

Request Method: **PATCH**

`v1/customers/<subscription_id>/subscriptions/<product_id>/quantity`

**Headers**

`Authorization: <token>`

**Payload example**

```js
{
  "action": "UPDATE"
  "quantity": "10"
}
```

| Param        | Type  | Description |
| ------------ | ----- | ----------- |
| subscription_id | **string** | The identifier of the subscription (**required**) |
| product_id | **string** | The identifier of the product, module (**required**) |
| action | **enumerated string** | `UPDATE`: add into or remove from the current quantity, `SET`: replace the current quantity by the new quantity (**required**) |
| quantity | **string** | The quantity of the subscription (**required**) |

<Example>
```json
{
   "id":"AABBCCDDEE",
   "plan_id":"default-plan",
   "customer_id":"EEDDCCBBAA",
   "status":"active",
   "currency_code":"EUR",
   "has_scheduled_changes":false,
   "billing_period":1,
   "billing_period_unit":"month",
   "due_invoices_count":0,
   "meta_data":{
      "module":"module_id"
   },
   "plan_amount":20000,
   "plan_quantity":11,
   "plan_unit_price":1818,
   "subscription_items":[
      {
         "amount":20000,
         "item_type":"plan",
         "quantity":11,
         "unit_price":1818
      }
   ],
   "created_at":1641982812,
   "next_billing_at":1644620400,
   "started_at":1641942000,
   "activated_at":1641942000,
   "updated_at":1642409568,
   "is_free_trial_used":false
}
```
</Example>

</Block>