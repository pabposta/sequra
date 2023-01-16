# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_230_116_212_205) do
  create_table 'disbursements', force: :cascade do |t|
    t.datetime 'week_start', null: false
    t.integer 'order_id', null: false
    t.integer 'merchant_id', null: false
    t.float 'amount', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['merchant_id'], name: 'index_disbursements_on_merchant_id'
    t.index ['order_id'], name: 'index_disbursements_on_order_id'
    t.index %w[week_start merchant_id], name: 'index_disbursements_on_week_start_and_merchant_id'
  end

  create_table 'merchants', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'email', null: false
    t.string 'cif', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'orders', force: :cascade do |t|
    t.integer 'merchant_id', null: false
    t.integer 'shopper_id', null: false
    t.float 'amount', null: false
    t.datetime 'completed_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['merchant_id'], name: 'index_orders_on_merchant_id'
    t.index ['shopper_id'], name: 'index_orders_on_shopper_id'
  end

  create_table 'shoppers', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'email', null: false
    t.string 'nif', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'disbursements', 'merchants'
  add_foreign_key 'disbursements', 'orders'
  add_foreign_key 'orders', 'merchants'
  add_foreign_key 'orders', 'shoppers'
end
