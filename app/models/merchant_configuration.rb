# frozen_string_literal: true

class MerchantConfiguration
  include ActiveModel::Validations

  # need to be able to get merchant_id and merchant_name for validation checking
  attr_reader :merchant_id, :merchant_name
  attr_accessor :minimum_loan_amount, :maximum_loan_amount, :prequal_enabled

  validates :merchant_id, presence: true
  validates :merchant_name, presence: true

  # added validator to check that minimum loan amount is less than maximum loan amount
  # added validators to check that loan amounts are both greater than zero 
  validates :minimum_loan_amount, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: :maximum_loan_amount }
  validates :maximum_loan_amount, presence: true, numericality: { greater_than: 0 }

  # added validation for prequal_enabled boolean
  validates :prequal_enabled, presence: true, inclusion: [true, false]

  # added prequal_enabled to schema
  def initialize(merchant_id, merchant_name, minimum_loan_amount, maximum_loan_amount, prequal_enabled=false)
    @merchant_id = merchant_id
    @merchant_name = merchant_name
    @minimum_loan_amount = minimum_loan_amount
    @maximum_loan_amount = maximum_loan_amount
    @prequal_enabled = prequal_enabled
  end

  def update_conf(minimum_loan_amount, maximum_loan_amount, prequal_enabled)
    self.minimum_loan_amount = minimum_loan_amount
    self.maximum_loan_amount = maximum_loan_amount
    self.prequal_enabled = prequal_enabled
  end
  
end
