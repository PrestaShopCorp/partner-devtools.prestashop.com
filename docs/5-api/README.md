---
title: Routes
---
<Block>

# ![](/assets/images/common/logo-condensed-sm.png) About API routes

This page introduces the available routes in order to communicate directly with the Billing API

</Block>

<Block>

## Authorization

An authorization token will be required to interact with the Billing API

`Authorization: <token>`


</Block>



<Block>

## Update subscription quantity

**URL**:`v1/customers/<subscription_id>/subscriptions/<product_id>/quantity`

**Method**:`PATCH`

**Auth required**: yes

**Permissions required**: None

**Payload constraints**

```js
{
  "action": "[UPDATE or SET]"
  "quantity": "[quantity needs to be updated]"
}
```

**Payload example**

```js
{
  "action": "UPDATE"
  "quantity": 10
}
```

| Param        | Type  | Description |
| ------------ | ----- | ----------- |
| action | **enumerated string** | `UPDATE`: add into or remove from the current quantity, `SET`: replace the current quantity by the new quantity (**required**) |
| quantity | **number** | The quantity of the subscription (**required**) |


### Success response

**Code response**: `200 OK`

```json
{
   "amount":20000,
   "item_type":"plan",
   "quantity":11,
   "unit_price":1818,
   "item_price_id":"default-plan",
}
```

### Error response

**Code response**: `400 Bad Request`

```json
{
    "statusCode": 400,
    "internalError": {
        "statusCode": 400,
        "message": [
            "action should not be empty",
            "action must be a valid enum value",
            "quantity should not be empty",
            "quantity must be a number conforming to the specified constraints"
        ],
        "error": "Bad Request"
    },
    "message": [
        "action should not be empty",
        "action must be a valid enum value",
        "quantity should not be empty",
        "quantity must be a number conforming to the specified constraints"
    ]
}
```


</Block>