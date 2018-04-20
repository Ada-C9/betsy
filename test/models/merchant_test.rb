require "test_helper"

describe Merchant do
  describe 'validations' do
    before do
      @merchant = Merchant.new(username: 'dan', email: 'dan@alibonbon.com')
    end

    it 'can be created with all required fields' do
      result = @merchant.valid?

      result.must_equal true
    end

    it 'is invalid without a username' do
      @merchant.username = nil

      result = @merchant.valid?

      result.must_equal false
    end

    it 'is invalid without an email' do
      @merchant.email = nil

      result = @merchant.valid?

      result.must_equal false
    end

    it 'is invalid with a duplicate username' do
      existing_merchant = Merchant.first
      @merchant.username = existing_merchant.username

      result = @merchant.valid?

      result.must_equal false
    end

    it 'is invalid with a duplicate email' do
      existing_merchant = Merchant.first
      @merchant.email = existing_merchant.email

      result = @merchant.valid?

      result.must_equal false
    end
  end

  describe 'relations' do
    it 'has many products' do
      merchant = merchants(:wini)
      product = Product.create!(
        name: 'key lime pie',
        price: 3.99,
        merchant: merchant)

      merchant.products.must_include product
      merchant.product_ids.must_include product.id
    end
  end
end
