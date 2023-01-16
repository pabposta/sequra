# A disbursement is a percentage of an order paid to a merchant
class Disbursement < ApplicationRecord
  belongs_to :order
  belongs_to :merchant

  validates :amount, numericality: { greater_than_or_equal_to: 0.0 }
end
