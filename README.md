![Ruby](https://github.com/jethroo/bricklink-api-wrapper/workflows/Ruby/badge.svg)

# Bricklink Api Wrapper

This gem is a wrapper around the [Bricklink API](https://www.bricklink.com/v2/api/welcome.page)
to make it easier to integrate it in ruby applications.

## Bricklink API documentation

The official API entry page for the store API can be found [here](https://www.bricklink.com/v2/api/welcome.page).

## Implemented Endpoints

* [Orders](./lib/bricklink_api_wrapper/order.rb)
  * GET /orders
  * GET /orders/{order_id}
  * GET /orders/{order_id}/items
* [Inventories](./lib/bricklink_api_wrapper/user_inventory.rb)
  * GET /inventories
  * GET /inventories/{inventory_id}
  * POST /inventories/

