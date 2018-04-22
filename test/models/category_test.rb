require "test_helper"

describe Category do
  let(:category) { Category.new }
  let(:category1) { categories(:category_1) }

  describe "relationships" do
    it "has list of products" do
      category1.products.each do |product|
        product.must_be_instance_of Product
        product.categories.must_be_instance_of Array
        product.categories.must_include category1
      end
    end

    it "belongs to many products" do
      Category.first.products << products(:product_1)
      Category.first.products << products(:product_2)
      Category.last.products << products(:product_1)
      Category.first.products.must_equal [products(:product_1),products(:product_2)]
      Category.last.products.must_equal [products(:product_1)]
    end
  end

  describe "validations" do
    it "has validation for empty parameters" do
      category.valid?.must_equal false
    end

    it "has validation for name presence" do
      category1.name = nil
      category1.valid?.must_equal false
      category1.errors.messages.must_include :name

      category1.name = ""
      category1.valid?.must_equal false
      category1.errors.messages.must_include :name
    end

    it "has validation for uniqueness" do
      category = Category.new(name: category1.name)

      category.valid?.must_equal false
      category.errors.messages.must_include :name
    end

    it "has validation for case insensitive uniqueness" do
      category = Category.new(name: category1.name.upcase)
      category.valid?.must_equal false
      category.errors.messages.must_include :name

      category = Category.new(name: category1.name.downcase)
      category.valid?.must_equal false
      category.errors.messages.must_include :name
    end

    it "has validatons" do
      category1.valid?.must_equal true
    end
  end
end
