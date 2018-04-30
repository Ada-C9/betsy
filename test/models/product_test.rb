require "test_helper"

describe Product do
  describe 'validations' do
    before do

      @product = Product.new(
      name: 'headband',
      price: 8,
      available: 300)
    end

    it "can be created with all required fields" do
      # result = @product.valid?
      #
      # result.must_equal true
    end

    it "is invalid without a name" do
      @product.name = nil

      result = @product.valid?
      result.must_equal false
      @product.errors.messages.must_include :name
    end

    it "is invalid with a duplicate name" do
      dup_product = Product.first

      @product.name = dup_product.name

      result = @product.valid?
      result.must_equal false
      @product.errors.messages.must_include :name
    end

    it "it is invalid without a price" do
      @product.price = nil

      result = @product.valid?
      result.must_equal false
      @product.errors.messages.must_include :price
    end

    it "it is invaild if price is 0 or less" do
      @product.price = -2

      result = @product.valid?
      result.must_equal false
      @product.errors.messages.must_include :price
    end

    it "it is invalid if price is not an integer" do
      @product.price = 'hi'

      result = @product.valid?
      result.must_equal false
      @product.errors.messages.must_include :price

    end
  end

  describe 'relationships' do
    before do
      @product = Product.new(
      name: 'headband',
      price: 8,
      available: 300,
      merchant_id: Merchant.first.id)
    end

    it "connects merchant and merchant_id" do
      merchant = Merchant.first

      @product.merchant = merchant

      @product.must_respond_to :merchant
      @product.merchant_id.must_equal merchant.id
      @product.merchant.must_be_kind_of Merchant
    end

    it "connects categories and category_ids" do

      category = Category.first

      @product.categories << category

      @product.must_respond_to :categories
      @product.category_ids.must_include category.id

    end

    it "has a list of categories" do
      @product.must_respond_to :categories

      @product.categories.each do |category|
        category.must_be_kind_of Categories
      end
    end

    it "has a list of order_products" do
      @product = Product.first

      @product.must_respond_to :order_products

      @product.order_products.each do |order_product|
        order_product.must_be_kind_of Order_product
      end
    end
  end
end
