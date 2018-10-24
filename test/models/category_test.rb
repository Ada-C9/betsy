require "test_helper"

describe Category do
  describe "validations" do
    before do

      category = Category.first

      @category = Category.new(name: "test name")
    end

    it "can be created with all required fields" do
      result = @category.valid?
      result.must_equal true

    end

    it "is invalid without a name" do
      @category.name = nil

      result = @category.valid?

      result.must_equal false
      # @category.must_include :name
    end

    it "is invalid with a duplicate name" do
      dup_category = Category.first
      @category.name = dup_category.name

      result = @category.valid?

      result.must_equal false
      # @category.must_include :name
    end
  end

  describe "relations" do
    before do
      @category = Category.new(name: 'test name')
    end


    it "connects products and product_ids" do
      # Arrange
      product = Product.first

      # Act
      @category.products << product

      # Assert
      @category.product_ids.must_include product.id

      puts categories(:happy).id
    end
  end

  describe 'self.select_with_products' do
    it "can return all categories that aren't empty" do
      Category.destroy_all
      category = Category.create(name: "Smile")
      category.products << products(:toy)

      category2 = Category.create(name: "Sad")

      valid_cat_count = Category.select_with_products.count

      valid_cat_count.must_equal 1
    end

    # it "will exclude empty categories" do
    #   @category.products << products(:toy)
    #
    #   valid_cat_count = Category.select_with_products.count
    #
    #   valid_cat_count.must_equal 1
    # end

  end
end
