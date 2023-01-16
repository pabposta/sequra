# A class representing orders. An order belongs to a merchant and a shopper, has a positive amount, is created on a date, and can be completed on a (future) date.
class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :shopper

  validates :amount, numericality: { greater_than_or_equal_to: 0.0 }
end
