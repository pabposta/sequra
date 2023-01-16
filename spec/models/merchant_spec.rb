require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe '#create!' do
    it 'creates a merchant' do
      expect { Merchant.create!(name: 'merchant', email: 'merchant@example.com', cif: 'B12345678') }.to change {
                                                                                                          Merchant.count
                                                                                                        }.by(1)
    end

    it 'raises an error when name is missing' do
      expect do
        Merchant.create!(email: 'merchant@example.com', cif: 'B12345678')
      end.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'raises an error when email is missing' do
      expect { Merchant.create!(name: 'merchant', cif: 'B12345678') }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'raises an error when cif is missing' do
      expect do
        Merchant.create!(email: 'merchant@example.com', name: 'merchant')
      end.to raise_error(ActiveRecord::NotNullViolation)
    end
  end
end
