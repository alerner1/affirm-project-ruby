# Merchant Configuration Endpoint 

## Design Decisions

This implementation involved changes to several different parts of the API. Overall, my main philosophy here was to follow the trends/style of the existing code as much as possible to keep things clean and hopefully more readable for others who'd be working on the project and already familiar with how things are set up.

### Controller

  The submit_merchant_config method makes several checks in the process while attempting to submit the merchant's desired configuration.

  1. Get existing merchant configuration from the provided `merchant_id` in the URL. Merchants are initialized with a merchant configuration, so if the `merchant_id` is valid, `Merchants.instance.get_merchant_configuration(merchant_id)`.
      1. If no merchant configuration exists, respond with a status of `400, "Bad Request"`, and return. 
  2. Create (but don't save) a new instance of the MerchantConfiguration class using the provided parameters. This is necessary for validation purposes, and essentially a substitute for ActiveRecord's built-in `update` method, since we can't use that here.
      1. Check if the new instance would be invalid. If invalid, respond with `400, "Bad Request"` along with the error details. Return.
  3. Update the merchant configuration record in the database. This uses a custom method (see Model section below). 
      1. Check that the merchant configuration's parameters in the database match the parameters provided (i.e. that the new params actually saved). If so, respond `200, "OK"`. Otherwise, respond `400, "Bad Request"` and return.

### Model

  All model-related changes were confined to the `MerchantConfiguration` model. 
  
  * Added `prequal_enabled` attribute to initializer.
  * Added attribute accessors for `minimum_loan_amount`, `maximum_loan_amount`, and `prequal_enabled`. We need the setter methods to be able to update the configuration after it's initialized, and we need the getter methods in order to use the `.invalid?` method.
  * Added attribute readers for `merchant_id` and `merchant_name`. These should not be writable, but we need the getter methods in order to use the `.invalid?` method.
  * Added several validators:
      * Edge case: Validate that the minimum loan amount is less than or equal to the maximum loan amount.
      * Edge case: Validate that both the minimum and maximum loan amounts are greater than zero.
      * Validate that the `prequal_enabled` variable is a boolean.
      * Validate that the loan amounts are both integers (as specified in the Swagger docs).
  * Added the `update_conf` method to update an instance of the class. This updates the `minimum_loan_amount`, `maximum_loan_amount`, and `prequal_enabled` parameters all at the same time, rather than having to call each setter method individually.

### Storage

  * Added a value for the prequal_enabled param to zelda_default. The value on initialization is false, since presumably this would be an opt-in setting for the merchant.

### Swagger
  
  * Main change here was to the variable names -- the instructions and existing model specified `maximum_loan_amount` and `minimum_loan_amount` as variable names, while Swagger said `maximum_amount` and `minimum_amount`. Updated the Swagger docs to say `maximum_loan_amount` and `minimum_loan_amount instead`.
  * Also added `prequal_enabled` variable to examples where relevant.

### Tests

  Added tests to cover various scenarios and validators:
  
  * Invalid merchant_id (responds 400)
  * Minimum loan amount greater than maximum loan amount (responds 400)
  * Minimum loan amount less than 0 (responds 400)
  * Missing `prequal_enabled` parameter (responds 400)
  * Non-boolean value for `prequal_enabled` (responds 400)
  * All correct params (reponds 200)

## Future Improvements

  * Structuring the API to have access to ActiveRecord methods would make a lot of this much simpler (although it would involve significant changes to parts of the app other than the submit_merchant_config endpoint). 
  * Allowing anyone with access to any merchant_id to make changes to the merchant configuration seems like a pretty big security flaw. I'd assume some sort of authentication would be involved in the production version of the API, though.

---
# Assignment Instructions

# Loan Application Translation Support

## Installation Guide

Requires Ruby 3.0.0.
1. `$ gem install bundler`
2. `$ bundle install`

## Development

### Running the Server
Run `rails s`. This sets up a server at http://127.0.0.1:3000.

## Manual Tests
While running the server, you can navigate to `http://127.0.0.1:3000/api-docs` to use the OpenAPI UI to test.

Some helpful tips:
- The schemas at the bottom will show you expected types.
- Clicking on the method type (e.g. `POST`) to the left of the API route will open more details. From there, clicking `Try it out` on the right-hand side will open a panel to make an API request.

If you prefer, you can also use cURL to run tests. A sample cURL is below:
1. `$ curl -X POST http://127.0.0.1:3000/api/v1/loanapplication -H "Content-Type: application/json" -d '{"currency": "usd"}'`


### Local Integration Tests
1. `$ bundle exec rspec loan_application/spec/`

### Style
This repository uses rswag for documentation and the UI. To refresh these items, run the following:
1. `$ rake rswag:specs:swaggerize`
This repository uses standard for style. To run the linter on the codebase, run the following:
1. `$ bundle exec standardrb --fix`

## Code Layout

Location (under `loan_application`) | Usage
------ | ------
`app/controllers/loanapp_controller`   | Implementation of API endpoints at `/api/v1/loanapplication`
`app/controllers/merchant_config_controller` | Implementation of API endpoints at `/api/v1/merchantconfig`
`app/models` | In-memory data models and validators
`app/storage` | In-memory loan application data
`config/routes.rb` | Router
`spec/requests` | Local integration tests
`spec/swagger` | API contract

## Implementation Notes

- The `storage` classes use a `Singleton` type, which only allows for one instance of the class, since they are meant to store data for the life of the server.
