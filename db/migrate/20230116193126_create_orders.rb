class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :merchant, null: false, foreign_key: true, index: { unique: false }
      t.references :shopper, null: false, foreign_key: true, index: { unique: false }
      t.float :amount, null: false
      t.datetime :completed_at

      t.timestamps
    end
  end
end
