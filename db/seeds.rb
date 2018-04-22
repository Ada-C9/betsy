# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

CATEGORY_FILE = Rails.root.join('db','seed-data', 'categories.csv')
puts "Loading raw category data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.id = row['id']
  category.name = row['name']
  puts "Created category: #{category.inspect}"
  successful = category.save
  if !successful
    category_failures << category
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categorys failed to save"
puts
puts

ORDER_FILE = Rails.root.join('db','seed-data', 'orders.csv')
puts "Loading raw order data from #{ORDER_FILE}"


order_failures = []
CSV.foreach(ORDER_FILE, :headers => true) do |row|
  order = Order.new
  order.id = row['id']
  order.status = row['status']
  order.name = row['name']
  order.email = row['email']
  order.street_address = row['street_address']
  order.city = row['city']
  order.state = row['state']
  order.zip = row['zip']
  order.name_cc = row['name_cc']
  order.expiry = row['expiry']
  order.credit_card = row['credit_card']
  order.ccv = row['ccv']
  order.billing_zip = row['billing_zip']
  puts "Created order: #{order.inspect}"
  successful = order.save
  if !successful
    order_failures << order
  end
end

puts "Added #{Order.count} order records"
puts "#{order_failures.length} orders failed to save"
p order_failures
puts

USER_FILE = Rails.root.join('db','seed-data', 'users.csv')
puts "Loading raw user data from #{USER_FILE}"

user_failures = []
CSV.foreach(USER_FILE, :headers => true) do |row|
  user = User.new
  user.id = row['id']
  user.username = row['username']
  user.email = row['email']
  user.uid = row['uid']
  user.provider = row['provider']
  puts "Created user: #{user.inspect}"
  successful = user.save
  if !successful
    user_failures << user
  end
end

puts "Added #{User.count} user records"
puts "#{user_failures.length} users failed to save"
puts
puts


PRODUCT_FILE = Rails.root.join('db','seed-data', 'products.csv')
puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.id = row['id']
  product.name = row['name']
  product.price = row['price']
  product.stock = row['stock']
  product.description = row['description']
  product.photo_url = row['photo_url']
  product.is_active = row['is_active']
  product.user_id = row['user_id']
  puts "Created product: #{product.inspect}"
  successful = product.save
  if !successful
    product_failures << product
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"
puts
puts

REVIEW_FILE = Rails.root.join('db','seed-data', 'reviews.csv')
puts "Loading raw review data from #{REVIEW_FILE}"

review_failures = []
CSV.foreach(REVIEW_FILE, :headers => true) do |row|
  review = Review.new
  review.id = row['id']
  review.rating = row['rating']
  review.product_id = row['product_id']
  review.content = row['content']
  puts "Created review: #{review.inspect}"
  successful = review.save
  if !successful
    puts review.errors
    review_failures << review
  end
end

puts "Added #{Review.count} review records"
puts "#{review_failures.length} reviews failed to save"
p review_failures
puts


OP_FILE = Rails.root.join('db','seed-data', 'orderitems.csv')
puts "Loading raw order_item data from #{OP_FILE}"

order_item_failures = []
CSV.foreach(OP_FILE, :headers => true) do |row|
  order_item = OrderItem.new
  order_item.order_id = row['order_id']
  order_item.product_id = row['product_id']
  order_item.quantity= row['quantity']
  order_item.is_shipped = row['is_shipped']
  puts "Created order_item: #{order_item.inspect}"
  successful = order_item.save
  if !successful
    order_item_failures << order_item
  end
end

puts "Added #{OrderItem.count} order-item records"
puts "#{order_item_failures.length} order_item failed to save"
p order_item_failures
puts

OP_FILE = Rails.root.join('db','seed-data', 'categories_products.csv')
puts "Loading raw order_item data from #{OP_FILE}"

category_product_failures = []
CSV.foreach(OP_FILE, :headers => true) do |row|
  prd = Product.find(row['product_id'])
  cat = Category.find(row['category_id'])
  prd.categories << cat
end

# c=Category.find(1); p = Product.find(1);  p.categories << c
# c=Category.find(2); p = Product.find(1);  p.categories << c
# c=Category.find(1); p = Product.find(2);  p.categories << c
# c=Category.find(2); p = Product.find(2);  p.categories << c
# c=Category.find(1); p = Product.find(3);  p.categories << c
# c=Category.find(2); p = Product.find(3);  p.categories << c
# c=Category.find(2); p = Product.find(4);  p.categories << c
# c=Category.find(4); p = Product.find(4);  p.categories << c
# c=Category.find(4); p = Product.find(5);  p.categories << c
# c=Category.find(7); p = Product.find(6);  p.categories << c
# c=Category.find(2); p = Product.find(7);  p.categories << c
# c=Category.find(9); p = Product.find(8);  p.categories << c
# c=Category.find(7); p = Product.find(9);  p.categories << c
# c=Category.find(7); p = Product.find(10);  p.categories << c
# c=Category.find(9); p = Product.find(11);  p.categories << c
# c=Category.find(9); p = Product.find(12);  p.categories << c
# c=Category.find(4); p = Product.find(13);  p.categories << c
# c=Category.find(7); p = Product.find(14);  p.categories << c
# c=Category.find(1); p = Product.find(15);  p.categories << c
# c=Category.find(4); p = Product.find(16);  p.categories << c
# c=Category.find(9); p = Product.find(17);  p.categories << c

puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end
