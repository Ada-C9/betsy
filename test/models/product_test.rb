require "test_helper"

describe Product do
  let(:product) { Product.new name: "A product", price: 1, quantity: 2, categories: [Category.first, Category.last], status:"active", merchant_id: Merchant.first.id, photo:"hi.jpg" }

  describe 'Validations' do
    it "must be valid" do
      product.must_be :valid?
    end

    # Category:
    it "must have at least one category" do
      product.categories.delete_all

      product.valid?.must_equal false
      product.errors.must_include :categories
    end

    # Status:
    it "must have a status" do
      product.status = nil

      product.valid?.must_equal false
      product.errors.must_include :status
    end

    # Name:
    it "must have a name" do
      product.name = nil

      product.valid?.must_equal false
      product.errors.must_include :name
    end

    it "name must be unique" do
      new_product = Product.new(name: products(:candy).name, price: 1, quantity: 2, categories: [Category.first, Category.last], status:"active", merchant_id: Merchant.first.id)

      result = new_product.save

      result.must_equal false
      new_product.errors.messages.must_include :name
    end

    it "must have name length greater than zero" do
      product.name = ""

      product.valid?.must_equal false
      product.errors.must_include :name
    end

    # Quantity:
    it "must have a quantity" do
      product.quantity = nil

      product.valid?.must_equal false
      product.errors.must_include :quantity
    end

    it "must not have a quantity less than zero" do
      product.quantity = -1

      product.valid?.must_equal false
      product.errors.must_include :quantity
    end

    # Price:
    it 'price should be a number' do
      product.price = "a string"

      product.valid?.must_equal false
      product.errors.must_include :price
    end

    it "must have a price" do
      product.price = nil

      product.valid?.must_equal false
      product.errors.must_include :price
    end

    it "must not have a price less than zero" do
      product.price = -2

      product.valid?.must_equal false
      product.errors.must_include :price
    end
  end

  describe 'relations' do

    it 'belongs to a merchant' do
      product.must_respond_to :merchant_id
    end

    it "has a list of categories" do
      product.must_respond_to :categories

      product.categories.each do |category|
        category.must_be_kind_of Category
      end
    end

    it "has a list of reviews" do
      product.must_respond_to :reviews

      product.reviews.each do |review|
        review.must_be_kind_of Review
      end
    end

    # it "has a list of orderproducts" do
    #   product.must_respond_to :orderproduct
    #
    #   product.orderproducts.each do |orderproduct|
    #     orderproduct.must_be_kind_of Orderproduct
    #   end
    # end
    # TODO: why do we have a orderproducts_id there if it can have more than one orderproduct created for this product?
  end

# Custom methods:

  describe "average_rating" do
    it "should return a string if there are no reviews for the product" do
      Review.destroy_all
      assert Review.all.empty?

      product.average_rating.must_be_kind_of String
      product.average_rating.must_equal "No reviews yet"
    end

    it "returns a avarage of the total of the reviews for the product" do
      product.save

      Review.create(rating: 2, comment: "A tasty candy", product_id: product.id)
      Review.create(rating: 2, comment: "A tasty candy", product_id: product.id)

      product.reviews.count.must_equal 2
      product.average_rating.must_be_kind_of Float
      product.average_rating.must_equal 2
    end
  end

  describe "change_status" do
    it "changes the status of a product to 'retired' if the status is equal 'active' " do
      assert product.status == "active"

      product.change_status.must_equal true
      product.status.must_equal "retired"
    end

    it "changes the status of a product to 'active' if the status is equal 'retied' " do
      product.status = "retired"
      product.save
      assert product.status == "retired"

      product.change_status.must_equal true
      product.status.must_equal "active"
    end
  end

  describe "has_atleast_one_category" do
    it "returns a custom error" do
      product.categories.delete_all

      assert product.categories.empty?
      result = product.save

      result.must_equal false
      product.errors.must_include :categories
    end
  end
end
