class MerchantConfigController < ApplicationController
  def submit_merchant_config
    # requires:
    # maximum_loan_amount (int, in cents)
    # minimum_loan_amount (int, in cents)
    # prequal_enabled (boolean)

    # if valid, update MerchantConfiguration accordingly
    # return 200
    # if invalid, return 400 if merchant does not exist
  end
end
