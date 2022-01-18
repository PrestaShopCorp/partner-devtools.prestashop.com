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
   "amount":20000,
   "item_type":"plan",
   "quantity":11,
   "unit_price":1818,
   "item_price_id":"default-plan",
}
```
</Example>

</Block>