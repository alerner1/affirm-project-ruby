class MerchantConfigController < ApplicationController
  def submit_merchant_config
    if params[:id] == "1"
      render json: {message: 'yup'}, status: :ok
    else 

      render json: {message: 'hi'}, status: :ok
    end
    # requires:
    # maximum_loan_amount (int, in cents)
    # minimum_loan_amount (int, in cents)
    # prequal_enabled (boolean)

    # if valid, update MerchantConfiguration accordingly
    # return 200
    # if invalid, return 400 if merchant does not exist

    # also needs a merchant_id, obviously
  end
end
