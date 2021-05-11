require 'swagger_helper'

RSpec.describe 'api/merchantconfig', type: :request do
  path "/api/v1/merchantconfig/{id}" do
    post "create merchant configuration" do 
      consumes "application/json"
      parameter name: :id, in: :path, type: :string
      parameter name: :merchantconfig, in: :body, schema: {"$ref" => "#/components/schemas/CreateMerchantConfigResponse"}

      response "400", "Bad Request" do
        let(:id) { "abcd" }
        let(:merchantconfig) { { minimum_loan_amount: 2, maximum_loan_amount: 58, prequal_enabled: true } }
        schema "$ref" => "#/components/schemas/BadInputResponse"
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["field"]).to eq("merchant_id")
          expect(data["message"]).to eq("Could not find that merchant.")
        end
      end

      response "400", "Bad Request" do 
        let(:id) { "4f572866-0e85-11ea-94a8-acde48001122" }
        let(:merchantconfig) { { minimum_loan_amount: 5, maximum_loan_amount: 2, prequal_enabled: 3 } }
        schema "$ref" => "#/components/schemas/BadInputResponse"
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to eq("Invalid request.")
        end
      end

      response "200", "OK" do
        let(:id) { "4f572866-0e85-11ea-94a8-acde48001122" }
        let(:merchantconfig) { { minimum_loan_amount: 2, maximum_loan_amount: 58, prequal_enabled: true } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to eq("Merchant configuration saved.")
        end
      end
    end

  end
end
