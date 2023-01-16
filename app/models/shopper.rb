# A class representing shoppers who participate in orders
class Shopper < ApplicationRecord
  has_many :orders
end
