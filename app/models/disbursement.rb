# typed: true

require 'sorbet-runtime'

# A disbursement is a percentage of an order paid to a merchant
class Disbursement < ApplicationRecord
  extend T::Sig

  belongs_to :order
  belongs_to :merchant

  validates :amount, numericality: { greater_than_or_equal_to: 0.0 }

  sig { params(order_amount: Float).returns(Float) }
  def self.calculate_order_disbursement(order_amount:)
    amount = if order_amount < 50
               order_amount * 0.01
             elsif order_amount <= 300
               order_amount * 0.0095
             else
               order_amount * 0.0085
             end
    amount.round(2)
  end

  sig { params(week_start: DateTime).void }
  def self.calculate_disbursements_of_week(week_start:)
    week_end = week_start + 1.week
    orders_of_week = Order.where(completed_at: week_start..week_end)
    disbursements = orders_of_week.map do |order|
      disbursement_amount = calculate_order_disbursement(order_amount: order.amount)
      {
        week_start:,
        merchant: order.merchant,
        order:,
        amount: disbursement_amount
      }
    end
    # create the new disbursements. create in batch to save database operations. if the number becomes too large, divide it into chunks
    Disbursement.create!(disbursements)
  end
end
