require 'swagger_helper'

RSpec.describe 'api/merchantconfig', type: :request do
  path "/api/v1/merchantconfig/{id}" do
    post "create merchant configuration" do 
      consumes "application/json"
      parameter name: :id, in: :path, type: :string
      parameter name: :merchantconfig, in: :body, schema: {"$ref" => "#/components/schemas/CreateMerchantConfigRequest"}

      response "200", "OK" do
        let(:merchantconfig) { { minimum_loan_amount: 2, maximum_loan_amount: 58, prequal_enabled: true } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to eq("hi")
        end
      end
    end

  end
end
