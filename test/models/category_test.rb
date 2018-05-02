require "test_helper"

describe Category do
  let(:category) { Category.new name: "candy", product_id: (Product.create name: "thing", quantity: 2).id }

  describe "validations" do
    it "must be valid" do
      category.valid?.must_equal true
    end

    it 'must have a name' do
      category.name = nil

      category.valid?.must_equal false
      category.errors.must_include :name
    end

    it 'name must have at least one character' do
      category.name = ""

      category.valid?.must_equal false
      category.errors.must_include :name
    end

    it 'name cannot have more than 25 characters' do
      category.name = "12345678901234567890123456"

      category.valid?.must_equal false
      category.errors.must_include :name
    end

    it 'name must be unique' do
      category.name = "Chocolate"

      category.valid?.must_equal false
      category.errors.must_include :name
    end
  end

  describe "relations" do
    it "has a list of products" do
      category.must_respond_to :products

      category.products.each do |product|
        product.must_be_kind_of Product
      end
    end
  end
end
