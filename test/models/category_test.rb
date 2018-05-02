require "test_helper"

describe Category do
  let(:novelty) { categories(:novelty) }

  describe "valid" do
    it "must be valid" do
      categories(:novelty).must_be :valid?
    end

    it "must have at least one character" do
      new_category = Category.create(name: "")
      new_category.valid?.must_equal false
      new_category.errors.must_include :name

      Category.create(name: "         ").valid?.must_equal false

      Category.create(name: nil).valid?.must_equal false

      Category.create().valid?.must_equal false
    end

    it "must have a unique name" do
      new_category = Category.create(name: categories(:novelty).name)
      new_category.valid?.must_equal false
      new_category.errors.must_include :name
    end

    it "must have a unique name regardless of case" do
      new_cat_name = categories(:novelty).name
      new_cat_name[0] = new_cat_name.chr.swapcase

      new_category = Category.create(name: new_cat_name)
      new_category.valid?.must_equal false
      new_category.errors.must_include :name
    end

    it "removes strips white space from name" do
      new_category = Category.create(name: "     Hello      World     ")
      new_category.valid?.must_equal true
      new_category.name.must_equal "Hello World"

    end

    it "strips white space from name before testing validity" do
      Category.create(name: "Foo Bar      ").name.must_equal "Foo Bar"

      # Should be invalid because whitespaces are removed and it's a duplicate
      new_category = Category.create(name: "Foo       Bar")
      new_category.valid?.must_equal false
      new_category.errors.must_include :name

      # Should be invalid because whitespaces are removed and it's a duplicate
      new_category = Category.create(name: "     Foo Bar")
      new_category.valid?.must_equal false
      new_category.errors.must_include :name
    end
  end

  describe "relations" do
    it "responds to products" do
      category = categories(:novelty)
      category.must_respond_to :products
      category.products.must_equal []
    end

    it "can have products" do
      category = categories(:novelty)
      category.products << products(:ball)

      category.products.must_include(products(:ball))
    end

    it "must be added to product's list of categories" do
      product = products(:sweater)
      category = categories(:clothing)
      category.products << product

      product.categories.must_include(category)
    end

    it "can have multiple products" do
      category = categories(:novelty)
      category.products << products(:ball)
      category.products << products(:icecream)

      category.products.must_equal [products(:ball), products(:icecream)]
    end

    it "can be initialized with products" do
      new_category = Category.create(name: "foo", products: [products(:ball), products(:icecream)])
      new_category.valid?.must_equal true
    end

    # it "can be initialized with products" do
    #   # new_category = Category.new(name: "foo", products: [Date.today])
    #   # new_category.valid?.must_equal false
    #   new_category = Category.create(name: "foo")
    #   new_category.products << products(:icecream)
    #   new_category.add_product(Date.today)
    #
    #   new_category.products.must_equal [products(:icecream)]
    # end
  end
end
