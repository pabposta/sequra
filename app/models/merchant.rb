# A class representing merchants who can have orders and disbursements
class Merchant < ApplicationRecord
  has_many :orders
  has_many :disbursements
end
