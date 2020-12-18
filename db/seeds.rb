# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d rails_engine_development db/data/rails-engine-development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

items_csv = File.read('db/data/items.csv')
items = CSV.parse(items_csv, headers: true)
items.each do |item|
  binding.pry
  i = Item.new
  i.id = item["id"]
  i.name = item["name"]
  i.description = item["description"]
  i.unit_price = item["unit_price"]
  i.merchant_id = item["merchant_id"]
  i.save
end