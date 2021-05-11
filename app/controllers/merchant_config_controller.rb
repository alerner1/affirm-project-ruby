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

    merchant_conf.update(merchant_conf_params)
    
    if merchant_conf.save
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

  private

  def merchant_conf_params
    params.require(:maximum_loan_amount, :minimum_loan_amount, :prequal_enabled)
  end
end
