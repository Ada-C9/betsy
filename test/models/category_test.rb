require "test_helper"

describe Category do
  describe 'relations' do
    it 'connects category and products' do
      product = Product.first

      category = Category.new(name: 'Accessories')
      category.products.push(product)

      category.valid?.must_equal true
      category.products.must_include product
    end
  end

  describe 'validations' do
    it 'cannot be created without a name' do
        old_category_count = Category.count

        category = Category.new(name: nil)

        category.valid?.must_equal false
        Category.count.must_equal old_category_count
        category.errors.must_include :name
    end

    it 'can only be created with a unique name' do
      old_category_count = Category.count

      category = Category.new(name: Category.first.name)

      category.valid?.must_equal false
      Category.count.must_equal old_category_count
      category.errors.must_include :name
    end
  end

  describe 'categories_with_works' do
    it 'only returns categories that have products associated with it' do
      categories_with_works = Category.categories_with_works

      categories_with_works.each do |category|
        category.products.must_be :>, 0
      end
    end

    it 'returns an empty array if there are no categories with products' do
      Category.destroy_all

      categories_with_works = Category.categories_with_works

      categories_with_works.must_be_empty

    end
  end
end
