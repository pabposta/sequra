require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  fixtures :merchants
  fixtures :shoppers
  fixtures :orders

  describe '#create!' do
    it 'creates a disbursement' do
      expect do
        Disbursement.create!(week_start: Time.now, order: orders(:one), merchant: merchants(:one), amount: 1.1)
      end.to change {
               Disbursement.count
             }.by(1)
    end

    it 'raises an error if no week is given' do
      expect do
        Disbursement.create!(order: orders(:one), merchant: merchants(:one),
                             amount: 1.1)
      end.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'raises an error if no week is given' do
      expect do
        Disbursement.create!(order: orders(:one), merchant: merchants(:one),
                             amount: 1.1)
      end.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'raises an error when the order does not exist' do
      expect do
        Disbursement.create!(week_start: Time.now, order_id: -1, merchant: merchants(:one),
                             amount: 1.1)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error when the order is missing' do
      expect do
        Disbursement.create!(week_start: Time.now, merchant: merchants(:one),
                             amount: 1.1)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error when the merchant does not exist' do
      expect do
        Disbursement.create!(week_start: Time.now, order: orders(:one), merchant_id: -1,
                             amount: 1.1)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error when the merchant does not exist' do
      expect do
        Disbursement.create!(week_start: Time.now, order: orders(:one),
                             amount: 1.1)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error when the amount is missing' do
      expect do
        Disbursement.create!(week_start: Time.now, merchant: merchants(:one),
                             order: orders(:one))
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error when the amount is not a number' do
      expect do
        Disbursement.create!(week_start: Time.now, merchant: merchants(:one), order: orders(:one),
                             amount: 'x')
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error when the amount is less than 0' do
      expect do
        Disbursement.create!(week_start: Time.now, merchant: merchants(:one), order: orders(:one),
                             amount: -1.0)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
