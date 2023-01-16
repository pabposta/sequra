require 'rails_helper'

RSpec.describe Order, type: :model do
  fixtures :shoppers
  fixtures :merchants

  describe '#create!' do
    it 'creates an order with and without a date' do
      expect do
        Order.create!(merchant: merchants(:one), shopper: shoppers(:one), amount: 1.1, completed_at: Time.new)
      end.to change {
               Order.count
             }.by(1)
      expect { Order.create!(merchant: merchants(:one), shopper: shoppers(:one), amount: 1.1) }.to change {
                                                                                                     Order.count
                                                                                                   }.by(1)
    end

    it 'raises an error when the merchant does not exist' do
      expect do
        Order.create!(merchant_id: -1, shopper: shoppers(:one), amount: 1.1,
                      completed_at: Time.new)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error when the merchant is missing' do
      expect do
        Order.create!(shopper: shoppers(:one), amount: 1.1,
                      completed_at: Time.new)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error when the shopper does not exist' do
      expect do
        Order.create!(merchant: merchants(:one), shopper_id: -1, amount: 1.1,
                      completed_at: Time.new)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error when the shopper is missing' do
      expect do
        Order.create!(merchant: merchants(:one), amount: 1.1,
                      completed_at: Time.new)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error when the amount is missing' do
      expect do
        Order.create!(merchant: merchants(:one), shopper: shoppers(:one),
                      completed_at: Time.new)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error when the amount is not a number' do
      expect do
        Order.create!(merchant: merchants(:one), shopper: shoppers(:one), amount: 'x',
                      completed_at: Time.new)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error when the amount is less than 0' do
      expect do
        Order.create!(merchant: merchants(:one), shopper: shoppers(:one), amount: -1.1,
                      completed_at: Time.new)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
