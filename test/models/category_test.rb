require "test_helper"

describe Category do
  describe 'validations' do
    before do
      @category = Category.new(name: 'new category')
    end

    it 'can be created with all required fields' do
      result = @category.valid?

      result.must_equal true
    end

    it 'is invalid without a name' do
      @category.name = nil

      result = @category.valid?

      result.must_equal false
    end

    it 'is invalid with a duplicate name' do
      existing_category = Category.first
      @category.name = existing_category.name

      result = @category.valid?

      result.must_equal false
    end
  end

  describe 'relations' do
    it 'has many products' do
      category = Category.first
      product_one = Product.first
      product_two = Product.last

      category.products << product_one
      category.products << product_two

      category.products.must_include product_one
      category.products.must_include product_two
      category.product_ids.must_include product_one.id
      category.product_ids.must_include product_two.id
    end
  end

  describe 'show_four' do
    it 'shows first four products of the category' do
      category = Category.first
      product1 = {
        name: 'product1',
        price: 233,
        merchant: Merchant.first
      }
      product2 = {
        name: 'product2',
        price: 233,
        merchant: Merchant.first
      }
      product3 = {
        name: 'product3',
        price: 233,
        merchant: Merchant.first
      }
      product4 = {
        name: 'product4',
        price: 233,
        merchant: Merchant.first
      }
      product5 = {
        name: 'product5',
        price: 233,
        merchant: Merchant.first
      }
      new_products = [product1, product2, product3, product4, product5]
      new_products.each do |pro|
        category.products << Product.create(pro)
      end

      result = category.show_four
      result.count.must_equal 4
      result.wont_include product5
    end

    it "returns all products if there is four or less than four products in the category" do
      category = Category.first
      product1 = {
        name: 'product1',
        price: 233,
        merchant: Merchant.first
      }
      product2 = {
        name: 'product2',
        price: 233,
        merchant: Merchant.first
      }
      product3 = {
        name: 'product3',
        price: 233,
        merchant: Merchant.first
      }

      new_products = [product1, product2, product3]
      new_products.each do |pro|
        category.products << Product.create(pro)
      end

      result = category.show_four

      result.count.must_equal 3
      result[0].name.must_equal product1[:name]
      result[0].price.must_equal product1[:price]
    end
  end
end
