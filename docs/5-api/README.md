---
title: Routes
---
<Block>

# ![](/assets/images/common/logo-condensed-sm.png) About API routes

This page introduces the available routes in order to communicate directly with the Billing API

</Block>

<Block>

## Authorization

An API key (in header or query params) will be required to interact with the Billing API

Header: `X-BILLING-API-KEY:apiKey`

Query param: `?api_key=apiKey`

If this is not specified or not a correct api key, `403 Forbidden` will be returned

## Rate limiting

This API is protected by a rate limiter. Ask us for more information about the limit.

</Block>

<Block>

## Get subscription quantity

**URL**:`v1/customers/<subscription_id>/subscriptions/<product_id>/quantity`

**Method**:`GET`

**Auth required**: yes

**Permissions required**: None

### Success response

**Code response**: `200 OK`

```json
{
   "currentQuantity": 11,
}
```


## Update subscription quantity

**URL**:`v1/customers/<subscription_id>/subscriptions/<product_id>/quantity`

**Method**:`PATCH`

**Auth required**: yes

**Permissions required**: None

**Payload constraints**: [UpdateQuantityDTO](#updatequantitydto)

```js
{
  "action": "UPDATE"
  "quantity": 10
}
```

### Success response

**Code response**: `200 OK`

```json
{
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

## Entities

### UpdateQuantityDTO

| Param        | Type  | Description |
| ------------ | ----- | ----------- |
| action | **enumerated string** | `UPDATE`: add into or remove from the current quantity, `SET`: replace the current quantity by the new quantity (**required**) |
| quantity | **number** | The quantity (minimum 1) of the subscription (**required**) |