# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'csv'

category_file = Rails.root.join('db', 'categories_seeds.csv')

category_failures = []
CSV.foreach(category_file, :headers => true) do |row|
  category = Category.new
  category.name = row['category']
  successful = category.save
  if !successful
    category_failures << category
    puts "Failed to save category: #{category.inspect}"
  else
    puts "Created category: #{category.inspect}"
  end
end

merchant_file = Rails.root.join('db', 'merchants_seeds.csv')
merchant_failures = []
i = 100000
CSV.foreach(merchant_file, :headers => true) do |row|
  merchant = Merchant.new
  merchant.username = row['username']
  merchant.email = row['email']
  if row['uid'] != nil
    merchant.uid = row['uid']
  else
    merchant.uid = i
  end
  merchant.provider = "github"

  successful = merchant.save
  if !successful
    merchant_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}"
  else
    puts "Created merchant: #{merchant.inspect}"
  end
  i += 1
end


product_file = Rails.root.join('db', 'products_seeds.csv')
product_failures = []

CSV.foreach(product_file, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.price = row['price']
  product.description = row['description']
  product.stock = row['stock']
  product.discontinued = row['discontinued']
  product.photo = row['photo']
  product.merchant_id = row['merchant_id']
  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end

end



order_file = Rails.root.join('db', 'orders_seeds.csv')
order_failures = []

CSV.foreach(order_file, :headers => true) do |row|
  order = Order.new
  order.email_address = row['email_address']
  order.cc_name = row['cc_name']
  order.cc_number = row['cc_number']
  order.cc_cvv = row['cc_cvv']
  order.cc_zip = row['cc_zip']
  order.status = row['status']
  order.street = row['street']
  order.customer_name = row['customer_name']
  order.city = row['city']
  order.state = row['state']
  order.mailing_zip = row['mailing_zip']
  order.cc_exp_month = row['cc_exp_month']
  order.cc_exp_year = row['cc_exp_year']
  successful = order.save
  if !successful
    order_failures << order
    puts "Failed to save order: #{order.inspect}"
  else
    puts "Created order: #{order.inspect}"
  end

end

order_items_file = Rails.root.join('db', 'order_items_seeds.csv')
order_item_failures = []

CSV.foreach(order_items_file, :headers => true) do |row|
  order_item = OrderItem.new
  order_item.quantity = row['quantity']
  order_item.price = row['price']
  order_item.is_shipped = row['is_shipped']
  order_item.product_id = row['product_id']
  order_item.order_id = row['order_id']
  successful = order_item.save
  if !successful
    order_item_failures << order_item
    puts "Failed to save order_item: #{order_item.inspect}"
  else
    puts "Created order_item: #{order_item.inspect}"
  end
end

review_file = Rails.root.join('db', 'reviews_seeds.csv')
review_failures = []


CSV.foreach(review_file, :headers => true) do |row|
  review = Review.new
  review.rating = row['rating']
  review.comment = row['comment']
  review.product_id = row['product_id']
  successful = review.save
  if !successful
    review_failures << review
    puts "Failed to save review: #{review.inspect}"
  else
    puts "Created review: #{review.inspect}"
  end
end


product = Product.find(1); category=Category.find(1); product.categories << category
product = Product.find(1); category=Category.find(7); product.categories << category
product = Product.find(2); category=Category.find(3); product.categories << category
product = Product.find(3); category=Category.find(3); product.categories << category
product = Product.find(4); category=Category.find(7); product.categories << category
product = Product.find(4); category=Category.find(9); product.categories << category
product = Product.find(5); category=Category.find(1); product.categories << category
product = Product.find(5); category=Category.find(3); product.categories << category
product = Product.find(6); category=Category.find(1); product.categories << category
product = Product.find(7); category=Category.find(8); product.categories << category
product = Product.find(8); category=Category.find(7); product.categories << category
product = Product.find(8); category=Category.find(9); product.categories << category
product = Product.find(9); category=Category.find(9); product.categories << category
product = Product.find(10); category=Category.find(3); product.categories << category
product = Product.find(10); category=Category.find(9); product.categories << category
product = Product.find(11); category=Category.find(6); product.categories << category
product = Product.find(11); category=Category.find(11); product.categories << category
product = Product.find(12); category=Category.find(1); product.categories << category
product = Product.find(12); category=Category.find(9); product.categories << category
product = Product.find(13); category=Category.find(1); product.categories << category
product = Product.find(13); category=Category.find(7); product.categories << category
product = Product.find(14); category=Category.find(9); product.categories << category
product = Product.find(15); category=Category.find(7); product.categories << category
product = Product.find(15); category=Category.find(9); product.categories << category
product = Product.find(16); category=Category.find(1); product.categories << category
product = Product.find(16); category=Category.find(8); product.categories << category
product = Product.find(17); category=Category.find(8); product.categories << category
product = Product.find(18); category=Category.find(2); product.categories << category
product = Product.find(19); category=Category.find(3); product.categories << category
product = Product.find(20); category=Category.find(5); product.categories << category
product = Product.find(21); category=Category.find(3); product.categories << category
product = Product.find(21); category=Category.find(8); product.categories << category
product = Product.find(22); category=Category.find(7); product.categories << category
product = Product.find(22); category=Category.find(9); product.categories << category
product = Product.find(23); category=Category.find(12); product.categories << category
product = Product.find(24); category=Category.find(7); product.categories << category
product = Product.find(25); category=Category.find(1); product.categories << category
product = Product.find(25); category=Category.find(8); product.categories << category
product = Product.find(26); category=Category.find(3); product.categories << category
product = Product.find(26); category=Category.find(8); product.categories << category
product = Product.find(27); category=Category.find(9); product.categories << category
product = Product.find(28); category=Category.find(5); product.categories << category
product = Product.find(29); category=Category.find(1); product.categories << category
product = Product.find(29); category=Category.find(5); product.categories << category
product = Product.find(30); category=Category.find(4); product.categories << category
product = Product.find(31); category=Category.find(4); product.categories << category
product = Product.find(32); category=Category.find(7); product.categories << category
product = Product.find(33); category=Category.find(6); product.categories << category
product = Product.find(33); category=Category.find(10); product.categories << category
product = Product.find(34); category=Category.find(6); product.categories << category
product = Product.find(35); category=Category.find(9); product.categories << category
product = Product.find(36); category=Category.find(8); product.categories << category
product = Product.find(37); category=Category.find(7); product.categories << category
product = Product.find(37); category=Category.find(9); product.categories << category
product = Product.find(38); category=Category.find(1); product.categories << category
product = Product.find(38); category=Category.find(8); product.categories << category
product = Product.find(39); category=Category.find(10); product.categories << category
product = Product.find(40); category=Category.find(3); product.categories << category
product = Product.find(41); category=Category.find(9); product.categories << category
product = Product.find(42); category=Category.find(12); product.categories << category
product = Product.find(43); category=Category.find(3); product.categories << category
product = Product.find(44); category=Category.find(1); product.categories << category
product = Product.find(44); category=Category.find(9); product.categories << category
product = Product.find(45); category=Category.find(1); product.categories << category
product = Product.find(46); category=Category.find(10); product.categories << category
product = Product.find(47); category=Category.find(9); product.categories << category
product = Product.find(48); category=Category.find(1); product.categories << category
product = Product.find(48); category=Category.find(3); product.categories << category
product = Product.find(49); category=Category.find(6); product.categories << category
product = Product.find(49); category=Category.find(12); product.categories << category
product = Product.find(50); category=Category.find(3); product.categories << category
product = Product.find(51); category=Category.find(7); product.categories << category
product = Product.find(51); category=Category.find(9); product.categories << category
product = Product.find(52); category=Category.find(11); product.categories << category
product = Product.find(52); category=Category.find(12); product.categories << category
product = Product.find(53); category=Category.find(1); product.categories << category
product = Product.find(53); category=Category.find(3); product.categories << category
product = Product.find(54); category=Category.find(7); product.categories << category
product = Product.find(55); category=Category.find(1); product.categories << category
product = Product.find(55); category=Category.find(6); product.categories << category
product = Product.find(56); category=Category.find(6); product.categories << category
product = Product.find(57); category=Category.find(12); product.categories << category
product = Product.find(58); category=Category.find(12); product.categories << category
product = Product.find(59); category=Category.find(12); product.categories << category
product = Product.find(60); category=Category.find(12); product.categories << category
product = Product.find(61); category=Category.find(11); product.categories << category
product = Product.find(61); category=Category.find(12); product.categories << category
product = Product.find(62); category=Category.find(8); product.categories << category
product = Product.find(62); category=Category.find(12); product.categories << category
product = Product.find(63); category=Category.find(8); product.categories << category
product = Product.find(63); category=Category.find(12); product.categories << category
product = Product.find(64); category=Category.find(12); product.categories << category
product = Product.find(65); category=Category.find(11); product.categories << category
product = Product.find(65); category=Category.find(12); product.categories << category
product = Product.find(66); category=Category.find(7); product.categories << category
product = Product.find(66); category=Category.find(12); product.categories << category
product = Product.find(67); category=Category.find(11); product.categories << category
product = Product.find(67); category=Category.find(12); product.categories << category
product = Product.find(68); category=Category.find(11); product.categories << category
product = Product.find(68); category=Category.find(12); product.categories << category
product = Product.find(69); category=Category.find(12); product.categories << category
product = Product.find(70); category=Category.find(12); product.categories << category
product = Product.find(71); category=Category.find(12); product.categories << category
product = Product.find(72); category=Category.find(8); product.categories << category
product = Product.find(72); category=Category.find(12); product.categories << category
product = Product.find(73); category=Category.find(12); product.categories << category
product = Product.find(74); category=Category.find(2); product.categories << category
product = Product.find(74); category=Category.find(12); product.categories << category
product = Product.find(75); category=Category.find(2); product.categories << category
product = Product.find(75); category=Category.find(12); product.categories << category
product = Product.find(76); category=Category.find(8); product.categories << category
product = Product.find(76); category=Category.find(12); product.categories << category
product = Product.find(77); category=Category.find(8); product.categories << category
product = Product.find(77); category=Category.find(12); product.categories << category
product = Product.find(78); category=Category.find(2); product.categories << category
product = Product.find(78); category=Category.find(12); product.categories << category
product = Product.find(79); category=Category.find(12); product.categories << category
product = Product.find(80); category=Category.find(12); product.categories << category
product = Product.find(81); category=Category.find(12); product.categories << category
product = Product.find(82); category=Category.find(12); product.categories << category
product = Product.find(83); category=Category.find(12); product.categories << category
product = Product.find(84); category=Category.find(8); product.categories << category
product = Product.find(84); category=Category.find(12); product.categories << category
product = Product.find(85); category=Category.find(8); product.categories << category
product = Product.find(85); category=Category.find(12); product.categories << category
product = Product.find(86); category=Category.find(12); product.categories << category
product = Product.find(87); category=Category.find(2); product.categories << category
product = Product.find(87); category=Category.find(12); product.categories << category
product = Product.find(88); category=Category.find(2); product.categories << category
product = Product.find(88); category=Category.find(12); product.categories << category
product = Product.find(89); category=Category.find(12); product.categories << category
product = Product.find(90); category=Category.find(2); product.categories << category
product = Product.find(90); category=Category.find(12); product.categories << category
product = Product.find(91); category=Category.find(12); product.categories << category
product = Product.find(92); category=Category.find(12); product.categories << category
product = Product.find(93); category=Category.find(12); product.categories << category
product = Product.find(94); category=Category.find(11); product.categories << category
product = Product.find(94); category=Category.find(12); product.categories << category
product = Product.find(95); category=Category.find(8); product.categories << category
product = Product.find(95); category=Category.find(12); product.categories << category
product = Product.find(96); category=Category.find(2); product.categories << category
product = Product.find(96); category=Category.find(12); product.categories << category
product = Product.find(97); category=Category.find(8); product.categories << category
product = Product.find(97); category=Category.find(12); product.categories << category
product = Product.find(98); category=Category.find(2); product.categories << category
product = Product.find(98); category=Category.find(12); product.categories << category
product = Product.find(99); category=Category.find(2); product.categories << category
product = Product.find(99); category=Category.find(12); product.categories << category
product = Product.find(100); category=Category.find(8); product.categories << category
product = Product.find(100); category=Category.find(12); product.categories << category
product = Product.find(101); category=Category.find(12); product.categories << category
product = Product.find(102); category=Category.find(7); product.categories << category
product = Product.find(102); category=Category.find(12); product.categories << category
product = Product.find(103); category=Category.find(2); product.categories << category
product = Product.find(103); category=Category.find(12); product.categories << category
product = Product.find(104); category=Category.find(12); product.categories << category
product = Product.find(105); category=Category.find(12); product.categories << category
product = Product.find(106); category=Category.find(4); product.categories << category
product = Product.find(106); category=Category.find(12); product.categories << category
product = Product.find(107); category=Category.find(2); product.categories << category
product = Product.find(107); category=Category.find(12); product.categories << category
