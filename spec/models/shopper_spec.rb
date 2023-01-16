require 'rails_helper'

RSpec.describe Shopper, type: :model do
  describe '#create!' do
    it 'creates a shopper' do
      expect { Shopper.create!(name: 'shopper', email: 'shopper@example.com', nif: '12345678B') }.to change {
                                                                                                       Shopper.count
                                                                                                     }.by(1)
    end

    it 'raises an error when name is missing' do
      expect do
        Shopper.create!(email: 'shopper@example.com', nif: '12345678B')
      end.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'raises an error when email is missing' do
      expect { Shopper.create!(name: 'shopper', nif: '12345678B') }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'raises an error when nif is missing' do
      expect do
        Shopper.create!(email: 'shopper@example.com', name: 'shopper')
      end.to raise_error(ActiveRecord::NotNullViolation)
    end
  end
end
