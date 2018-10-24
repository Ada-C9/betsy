# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

categories_failures = []

CATEGORIES_FILE = Rails.root.join('db','seed_data', 'categories.csv')
CSV.foreach(CATEGORIES_FILE, :headers => true) do |row|
  category = Category.new
  category.name = row['name']

  successful = category.save
  if !successful
    categories_failures << category
    puts "Failed to save categories: #{category.inspect}"
  else
    puts "Created categories: #{category.inspect}"
  end

end

puts "Added #{Category.count} categories records"
puts "#{categories_failures.length} categories failed to save"

users_failures = []

USERS_FILE = Rails.root.join('db','seed_data', 'users.csv')
CSV.foreach(USERS_FILE, :headers => true) do |row|
  user = User.new
  user.name = row['name']
  user.email = row['email']
  user.uid = row['uid']
  user.provider = row['provider']

  successful = user.save
  if !successful
    users_failures << user
    puts "Failed to save users: #{user.inspect}"
  else
    puts "Created users: #{user.inspect}"
  end
end

puts "Added #{Category.count} categories records"
puts "#{categories_failures.length} categories failed to save"


product_failures = []

PRODUCT_FILE = Rails.root.join('db','seed_data', 'product.csv')
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.stock = rand(1..38)
  product.price = rand(8.25..200.89)
  product.description = row['description']
  product.product_status = row['product_status']
  product.user = User.all.sample

  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save products: #{product.inspect}"
  else
    puts "Created products: #{product.inspect}"
  end

end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"

#adds categories to products
100.times do
  category = Category.all.sample
  prod = Product.all.sample

  prod.categories << category
end
