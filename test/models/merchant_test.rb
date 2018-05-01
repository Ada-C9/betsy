require "test_helper"

describe Merchant do

  describe "validations" do

    before do
      @merchant = merchants(:merchant_one)
    end

    it "is valid with all the required fields" do
      result = @merchant.valid?

      value(result).must_equal true
    end

    it "is invalid without a username" do
      @merchant.username = nil

      result = @merchant.valid?

      value(result).must_equal false
    end

    it "is invalid without an email" do
      @merchant.email = nil

      result = @merchant.valid?

      value(result).must_equal false
    end

    it "is invalid when there is a duplicate username" do
      duplicate = merchants(:merchant_two)
      duplicate.username = "merchant_one"

      result = duplicate.valid?

      value(result).must_equal false
    end

    it "is invalid when there is a duplicate email" do
      duplicate = merchants(:merchant_two)
      duplicate.email = "merchant_one@gmail.com"

      result = duplicate.valid?

      value(result).must_equal false
    end

  end

  describe 'relations' do

    before do
      @merchant = merchants(:merchant_one)
    end

    it "has a list of products to sell" do
      @merchant.must_respond_to :products
      @merchant.products.each do |product|
        product.must_be_kind_of Product
      end
    end

    it "has many orders" do
      @merchant.must_respond_to :orders
      @merchant.orders.each do |order|
        order.must_be_kind_of Order
      end
    end

    it "has many product categories" do
      @merchant.product_categories.each do |category|
        category.must_be_kind_of Category
      end
    end

  end

end
