require "test_helper"

describe Product do
  let(:product) { Product.new }
  let(:product1) {products(:product1)}
  let(:product2) {users(:product2)}

  describe 'relations' do
    it "must belong to a user" do
      product = products(:product1)
      product.must_respond_to :user
      product.must_be_kind_of Product
      product.user.must_be_kind_of User
    end

    it "must belong to a category" do
      product = products(:product1)
      product.must_respond_to :categories

    end

    it "has a list of categories" do
      product1.categories.each do |category|
        category.must_be_instance_of Category
        category.products.must_be_instance_of Array
        category.products.must_include product1
      end
    end

    it "belongs to many categories" do
      Product.first.categories << categories(:decor)
      Product.first.categories << categories(:food)
      Product.last.categories << categories(:decor)
      Product.first.categories.must_equal [categories(:decor),categories(:food)]
      Product.last.categories.must_equal [categories(:decor)]
    end

    it "has reviews" do
      product = products(:product1)
      product.must_respond_to :reviews
    end

    it "has a list of orderitems " do
      product1.order_items.each do |order_item|
        order_item.must_be_instance_of OrderItem
        order_item.product.must_be_instance_of Product
        order_item.product.must_equal product1
      end
    end

  end
  describe 'validations' do
    it "must have a name to be valid" do
      product1.valid?.must_equal true
      product1.name = ""
      product1.valid?.must_equal false
      product1.errors.messages.must_include :name
    end

    it "must have a unique name" do
      product_name = "test productname"
      new_product = Product.new(name: product_name, price: 50, stock: 10)

      new_product.save!

      new_product2 = Product.new(name: product_name, price: 30, stock: 5)
      result = new_product2.save
      result.must_equal false
      new_product2.errors.messages.must_include :name
    end

    it "must have a price to be valid" do
      product1.valid?.must_equal true
      product1.price = ""
      product1.valid?.must_equal false
    end

    it "must have a price greater than 0" do
      product1.valid?.must_equal true
      product1.price = 0
      product1.valid?.must_equal false
      product1.price = -5
      product1.valid?.must_equal false
    end

    it "must have a stock to be valid" do
      product1.valid?.must_equal true
      product1.stock = ""
      product1.valid?.must_equal false
    end

    it "must have an integer as stock" do
      product1.valid?.must_equal true
      product1.stock = 0.4
      product1.valid?.must_equal false
    end

    it "must have as stock a number greater than or equal to 0" do
      product1.valid?.must_equal true
      product1.stock = 0
      product1.valid?.must_equal true
    end

    it "cannot have a negative number as stock" do
      product1.valid?.must_equal true
      product1.stock = -10
      product1.valid?.must_equal false
    end

  end

  describe 'custom methods' do

    it "returns correct average rating" do
      product = products(:product1)
      product.show_rating.must_equal 3

      product = products(:product2)
      product.show_rating.must_equal 4
    end

    it "returns no reviews when the product does not have reviews" do
      product.show_rating.must_equal "No reviews"
    end


    it "returns a collection of products" do
  
      Product.by_pet_type.must_be_kind_of Hash
    end


    it 'reduces the stock of the product' do
      product = Product.first
      product.stock = 10
      product.save

      product.stock_reduction(3)
      product.reload

      product.stock.must_equal 7
    end
  end

end
