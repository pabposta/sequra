class CreateDisbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :disbursements do |t|
      t.datetime :week_start, null: false
      t.references :order, null: false, foreign_key: true
      t.references :merchant, null: false, foreign_key: true
      t.float :amount, null: false

      t.timestamps
    end

    # This composite index allows to query only by week start as well
    add_index :disbursements, %i[week_start merchant_id], unique: false
  end
end
