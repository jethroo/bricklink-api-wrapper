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

## Configuration

Consuming the Bricklink API requires you to setup your API credenials. This can be done by renaming `./config/application_example.yml` to `./config/application_example.yml` and replace the dummy value in this file with yours: 

```yml
consumer_key: your-key
consumer_secret: your-secret
token: your-token
token_secret: your-token-secret
```

Testing the API credentials:

```bash
$ bin/console 
irb(main):001:0> BricklinkApiWrapper::Order.index(filed: false, status: '-PURGED').count
=> 123
```
Should list your current unfiled and unpurged orders count as listed in https://www.bricklink.com/orderReceived.asp

When your credentials are wrong you will see something like:

```bash
$ bin/console 
irb(main):001:0> BricklinkApiWrapper::Order.index(filed: false, status: '-PURGED').count
Traceback (most recent call last):
        2: from bin/console:16:in `<main>'
        1: from (irb):1
NoMethodError (undefined method `count' for nil:NilClass)

# TODO probably raise a meaningful error based on the response from Bricklink
# {"meta":{"description":"SIGNATURE_INVALID: Invalid Signature","message":"BAD_OAUTH_REQUEST","code":401}}
```

