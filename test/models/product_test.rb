require "test_helper"

describe Product do
  describe 'validations' do
    before do
      @product = Product.new(
        name: 'new product',
        price: 5.00,
        merchant: Merchant.first)
    end

    it 'can be created with all required fields' do
      result = @product.valid?

      result.must_equal true
    end

    it 'is invalid without a name' do
      @product.name = nil

      result = @product.valid?

      result.must_equal false
    end

    it 'is invalid without a price' do
      @product.price = nil

      result = @product.valid?

      result.must_equal false
    end

    it 'is invalid without a merchant' do
      @product.merchant = nil

      result = @product.valid?

      result.must_equal false
    end

    it 'is invalid if price is not a number' do
      @product.price = 'three ninety-nine'

      result = @product.valid?

      result.must_equal false
    end

    it 'is invalid if price is less than 0' do
      @product.price = -0.99

      result = @product.valid?

      result.must_equal false
    end
  end

  describe 'relations' do
    it 'has a merchant' do
      product = products(:bonbon)
      product.merchant.must_equal merchants(:wini)
    end

    it 'can set the merchant' do
      product = Product.new(name: 'tasty treat', price: 1.99)
      product.merchant = merchants(:analisa)
      product.merchant_id.must_equal merchants(:analisa).id
    end

    it 'has many categories' do
      category = Category.first
      product = Product.first

      product.categories << category

      @product.categories.must_include category
    end
  end
end
