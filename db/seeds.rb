# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require'csv'
require 'faker'

# Categories:
CATEGORIES_FILE = Rails.root.join('db', 'seeds', 'categories.csv')

CSV.foreach(CATEGORIES_FILE, :headers => true) do |row|
categories = Category.create(name: row['name'])
puts "Category #{categories.id} created "
end

# Mercahnts
MERCHANT_FILE = Rails.root.join('db', 'seeds', 'merchants.csv')
puts "Loading raw Merchant data from #{MERCHANT_FILE}"

CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.create(username:row['username'],email:row['email'])
puts "Merchant #{merchant.id} created "
puts "#{merchant.username} created in the category"
end

# Products
PRODUCT_FILE = Rails.root.join('db', 'seeds', 'products.csv')
puts "Loading raw Product data from #{PRODUCT_FILE}"

CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.create!(name:row['name'],price:row['price'],quantity:row['quantity'],description:row['description'],photo:row['photo'],status:row['status'], categories: [Category.all.sample], merchant_id: Merchant.all.sample.id)
puts "Product #{product.id} created "
puts "#{product.name} created in the category: #{product.categories.first.name}"
end


# Reviews
REVIEW_FILE = Rails.root.join('db','seeds', 'reviews.csv')
CSV.foreach(REVIEW_FILE, :headers => true) do |row|
 review = Review.create(rating: row['rating'],  product_id: row['product_id'])
 puts "Review #{review.id} created with rating #{review.rating}"
end
