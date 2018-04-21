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
end
