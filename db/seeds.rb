require 'faker'
require 'csv'

PRODUCT_FILE = Rails.root.join('db', 'seed_data', 'products.csv')
puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.id = row['id']
  product.user_id = row['user_id']
  product.image_url = row['image_url']
  product.name = row['name']
  product.price = row['price']
  product.stock = row['stock']
  product.description = row['description']
  product.status = true
  successful = product.save
  if !successful
    procuct_failures << procuct
    puts "Failed to save procuct: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"



USER_FILE = Rails.root.join('db', 'seed_data', 'users.csv')
puts "Loading raw user data from #{USER_FILE}"

user_failures = []
CSV.foreach(USER_FILE, :headers => true) do |row|
  user = User.new
  user.id = row['id']
  user.username = Faker::Cat.name
  user.email = Faker::Internet.email
  user.uid = row['uid']
  user.provider = row['provider']
  successful = user.save
  if !successful
    user_failures << user
    puts "Failed to save user: #{user.inspect}"
  else
    puts "Created user: #{user.inspect}"
  end
end

puts "Added #{User.count} user records"
puts "#{user_failures.length} users failed to save"



ORDERS_FILE = Rails.root.join('db', 'seed_data', 'orders.csv')
puts "Loading raw order data from #{ORDERS_FILE}"

order_failures = []
CSV.foreach(ORDERS_FILE, :headers => true) do |row|
  order = Order.new
  order.id = row['id']
  order.status = row['status']
  order.name_on_card = Faker::Name.name
  order.cc_num = Faker::Number.number(9) # Integer of 16 digits can not be held here while the column is just an Interger.. it must be a big integer
  order.cvv= Faker::Number.number(3)
  order.email = Faker::Internet.email
  order.street_address = Faker::Address.street_address
  order.state = Faker::Address.state_abbr
  order.city = Faker::Address.city
  order.zip = Faker::Address.zip_code
  successful = order.save
  if !successful
    order_failures << order
    puts "Failed to save order: #{order.inspect}"
  else
    puts "Created order: #{order.inspect}"
  end
end

puts "Added #{Order.count} order records"
puts "#{order_failures.length} orders failed to save"

CATEGORIES_FILE = Rails.root.join('db', 'seed_data', 'categories.csv')
puts "Loading raw categories data from #{CATEGORIES_FILE}"

category_failures = []
CSV.foreach(CATEGORIES_FILE, :headers => true) do |row|
  category = Category.new
  category.id = row['id']
  category.name = row['name']
  successful = category.save
  if !successful
    categories_failures << categories
    puts "Failed to save categories: #{category.inspect}"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"


# Since we set the primary key (the ID) manually on each of the
# tables, we've got to tell postgres to reload the latest ID
# values. Otherwise when we create a new record it will try
# to start at ID 1, which will be a conflict.
puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"
