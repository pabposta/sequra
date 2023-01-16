# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

merchants = JSON.parse(File.read(Rails.root.join('db/data/merchants.json')))['RECORDS']

merchants.each do |merchant|
  Merchant.create!(
    id: merchant['id'].to_i,
    name: merchant['name'],
    email: merchant['email'],
    cif: merchant['cif']
  )
end

shoppers = JSON.parse(File.read(Rails.root.join('db/data/shoppers.json')))['RECORDS']

shoppers.each do |shopper|
  Shopper.create!(
    id: shopper['id'].to_i,
    name: shopper['name'],
    email: shopper['email'],
    nif: shopper['nif']
  )
end

orders = JSON.parse(File.read(Rails.root.join('db/data/orders.json')))['RECORDS']

def parse_datetime_or_nil(datetime_str)
  datetime_str === '' ? nil : DateTime.parse(datetime_str)
end

orders.each do |order|
  Order.create!(
    id: order['id'].to_i,
    merchant_id: order['merchant_id'].to_i,
    shopper_id: order['shopper_id'].to_i,
    amount: order['amount'].to_f,
    created_at: parse_datetime_or_nil(order['created_at']),
    completed_at: parse_datetime_or_nil(order['completed_at'])
  )
end
