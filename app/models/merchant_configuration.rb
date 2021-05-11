# frozen_string_literal: true

class MerchantConfiguration
  include ActiveModel::Validations

  validates :merchant_id, presence: true
  validates :merchant_name, presence: true
  validates :minimum_loan_amount, presence: true, numericality: true
  validates :maximum_loan_amount, presence: true, numericality: true
  # added validation for prequal_enabled boolean
  validates :prequal_enabled, presence: true, inclusion: [true, false]

  # added prequal_enabled to schema
  def initialize(merchant_id, merchant_name, minimum_loan_amount, maximum_loan_amount, prequal_enabled)
    @merchant_id = merchant_id
    @merchant_name = merchant_name
    @minimum_loan_amount = minimum_loan_amount
    @maximum_loan_amount = maximum_loan_amount
    @prequal_enabled = prequal_enabled
  end

  def minimum_loan_amount=(minimum_loan_amount)
    @minimum_loan_amount = minimum_loan_amount
  end

  def maximum_loan_amount=(maximum_loan_amount)
    @maximum_loan_amount = maximum_loan_amount
  end

  def prequal_enabled=(prequal_enabled)
    @prequal_enabled = prequal_enabled
  end
end
