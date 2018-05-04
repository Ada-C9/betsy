require "test_helper"

describe Category do
  describe "relations" do
    it "connects product and product_id" do
      product = Product.first
      category = Category.first

      product.categories << category

      product.category_ids.must_include category.id
    end
  end

  describe "validations" do
    it "must be valid with all required fields" do
      category = Category.new(name: "test category")
      category.save
      category.valid?.must_equal true
    end

    it "requires a name" do
      category = Category.new(name: nil)
      category.save
      category.valid?.must_equal false
      category.errors.messages.must_include :name
    end

    it "allows products to have multiple categoriess" do
      category1 = categories(:decor)
      category2 = categories(:food)
      category1.valid?.must_equal true
      category1.valid?.must_equal true
    end

    it "must have a unique name" do
      category_name = "test category"
      new_category = Category.new(name: category_name)

      new_category.save!

      new_category2 = Category.new(name: category_name)
      result = new_category2.save
      result.must_equal false
      new_category2.errors.messages.must_include :name
    end
  end

  
end
