class MerchantConfigController < ApplicationController
  def submit_merchant_config
    content_type = mimetype = "application/json"
    merchant_id = params[:id]
    merchant_conf = Merchants.instance.get_merchant_configuration(merchant_id)
    if merchant_conf.nil?
      response = {
        field: "merchant_id",
        message: "Could not find that merchant.#{merchant_conf}"
      }
      render(json: response, content_type: content_type, mimetype: mimetype, status: :bad_request) && return
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

  private

  def merchant_conf_params
    params.require(:maximum_loan_amount, )
  end
end
