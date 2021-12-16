---
title: About relationships
---

# ![](/assets/images/common/logo-condensed-sm.png) About ps account

For every merchant who has linked the ps account, an `ownerUuid`, an `ownerEmail` a `shopUuid` will be created. These values can be retrieved from the ps account context.

`ownerEmail`: the email of the SSO user from the [addons market place](https://addons.prestashop.com/en/)

`ownerUuid`: the identifier of the SSO user

`shopUuid`: the identifier of the Prestashop's shop

**IMPORANT**: The `ownerUuid` is based on the `ownerEmail`, it means that if the `ownerEmail` has changed, the `ownerUuid` will also be changed.


# ![](/assets/images/common/logo-condensed-sm.png) About RBM

Relationship in RBM is a parent-child link between a "parent" customer and a "child" customer

The "parent" customer is created based on the `ownerUuid` of the SSO user from the addons market place whereas the "child" customer is created using the `shopUuid` of the Prestashop's shop.

![Relationship map](/assets/images/3-relationships/relationship_map.png)

For every shop using RBM module, a parent customer and a child customer will be created once, so does their relationship.

A merchant with the same `ownerUuid` (same SSO user, same parent customer) might have one or multiple shops with different `shopUuid` (different child customers).

![One customer to many shop](/assets/images/3-relationships/one_customer_multiple_shop.png)

And for each shop, the merchant can subscribe to one or more RBM modules.

**IMPORANT**: The subscription is attached to the shop (child customer).

![Shop subscription](/assets/images/3-relationships/shop_subscription.png)

The payment method and the invoice are also attached to the shop (child customer).

The relationship can be found in the customer object.

```json
"customer": {
    "relationship": {
        "parent_id": "parent_id",
        "payment_owner_id": "child_id",
        "invoice_owner_id": "child_id",
        "root_id": "parent_id",
    }
}
```