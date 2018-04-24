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
      product = Product.create!(name: 'key lime pie', price: 399, merchant: merchant)

      merchant.products.must_include product
      merchant.product_ids.must_include product.id
    end
  end

  describe 'show_four' do
    it 'shows first four products of the merchant' do
      merchant = Merchant.first
      product1 = {
        name: 'product1',
        price: 233,
        merchant: merchant
      }
      product2 = {
        name: 'product2',
        price: 233,
        merchant: merchant
      }
      product3 = {
        name: 'product3',
        price: 233,
        merchant: merchant
      }
      product4 = {
        name: 'product4',
        price: 233,
        merchant: merchant
      }
      product5 = {
        name: 'product5',
        price: 233,
        merchant: merchant
      }
      new_products = [product1, product2, product3, product4, product5]
      new_products.each do |pro|
        Product.create(pro)
      end

      result = merchant.show_four
      result.count.must_equal 4
      result.wont_include product5
    end

    it "returns all products if there is four or less than four products in the merchant" do
      merchant = Merchant.first
      product1 = {
        name: 'product1',
        price: 233,
        merchant: merchant
      }
      product2 = {
        name: 'product2',
        price: 233,
        merchant: merchant
      }
      product3 = {
        name: 'product3',
        price: 233,
        merchant: merchant
      }

      new_products = [product1, product2, product3]
      new_products.each do |pro|
        merchant.products << Product.create(pro)
      end

      result = merchant.show_four

      result.count.must_equal 3
      result[0].name.must_equal product1[:name]
      result[0].price.must_equal product1[:price]
    end
  end
end
