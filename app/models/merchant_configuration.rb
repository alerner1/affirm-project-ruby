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
  validates :minimum_loan_amount, presence: true, numericality: { less_than_or_equal_to: :maximum_loan_amount, message: "must be less than or equal to maximum loan amount" } 

  # need a separate validation line for this because you although you can have multiple helpers for numericality, the custom message will apply to all of them
  # and specifying numericality twice in the same line makes it skip both validations
  validates :minimum_loan_amount, numericality: { greater_than: 0 }
  validates :maximum_loan_amount, presence: true, numericality: { greater_than: 0 }

  # added validation for prequal_enabled boolean
  validates :prequal_enabled, presence: true, inclusion: {in: [true, false], message: "must be a boolean"}

  # added prequal_enabled to schema
  def initialize(merchant_id, merchant_name, minimum_loan_amount, maximum_loan_amount, prequal_enabled)
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
