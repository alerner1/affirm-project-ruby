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

    merchant_conf.update_conf(params[:minimum_loan_amount], params[:maximum_loan_amount], params[:prequal_enabled])
    
    if merchant_conf.minimum_loan_amount == params[:minimum_loan_amount] && merchant_conf.maximum_loan_amount == params[:maximum_loan_amount] && merchant_conf.prequal_enabled == params[:prequal_enabled]
      response = {
        message: "Merchant configuration saved."
      }
      render json: response, content_type: content_type, mimetype: mimetype, status: :ok
    else
      response = {
        message: "Error: Failed to update merchant configuration."
      }
      render(json: response, content_type: content_type, mimetype: mimetype, status: :bad_request) && return
    end
  end
end
