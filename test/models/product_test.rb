require "test_helper"

describe Product do
  let(:product) { products(:ball) }
  let(:novelty) { categories(:novelty)}
  let(:clothing) { categories(:clothing)}

  describe "valid" do

    it "must be valid" do
      value(product).must_be :valid?
    end

    it "is invalid with nil name" do
      product.name = nil
      value(product).wont_be :valid?
      product.errors.messages.must_include :name
    end

    it "is invalid with name that is not unique" do
      product.update(name: "Mars Mud Soap")
      product.wont_be :valid?
      product.errors.messages.must_include :name
    end

    it "is invalid with nil price" do
      product.price = nil
      value(product).wont_be :valid?
      product.errors.messages.must_include :price
    end

    it "is invalid with price that is not integer" do
      product.price = "string"
      value(product).wont_be :valid?
      product.errors.messages.must_include :price
      product.price = false
      value(product).wont_be :valid?
      product.errors.messages.must_include :price
    end

    it "is invalid with prices less than 0" do
      product.price = -19
      value(product).wont_be :valid?
      product.errors.messages.must_include :price
    end

    it "is invalid if product does not have a merchant" do
      product.merchant = nil
      value(product).wont_be :valid?
      product.errors.messages.must_include :merchant
    end

    it "is invalid if photo url is nil" do
      product.photo = nil
      value(product).wont_be :valid?
      product.errors.messages.must_include :photo
    end

    it "is invalid if stock is nil" do
      product.stock = nil
      value(product).wont_be :valid?
      product.errors.messages.must_include :stock
    end

  end


  describe "relations" do
    it "responds to categories" do
      product.must_respond_to :categories
    end

    it "must have a category field" do
      product.categories.must_equal []
      product.categories << novelty
      category = Category.find_by name: "Novelty"
      product.categories.must_include category
    end

    it "must be added to category's list of products" do
      product.categories << novelty
      novelty.products.must_include(product)
    end

    it "can have multiple categories" do
      product.categories << novelty
      product.categories << clothing
      product.categories.must_equal [categories(:novelty), categories(:clothing)]
      product.categories.count.must_equal 2
    end

    it "can be instantiated with categories" do
      new_product = Product.create(name: "New Product", price: 2, description: "cool item", stock: 2, discontinued: false, photo: "http://placecage.com/c/200/300", merchant: merchants(:astro), categories: [novelty, clothing])
      new_product.valid?.must_equal true
    end

    it "responds to reviews" do
      product.must_respond_to :reviews
    end

    it "can have multiple reviews" do
      product.reviews.count.must_equal 1
      new_review = Review.new(rating: 5, comment: "My son loved this ball")
      product.reviews << new_review
      product.reviews.must_include(new_review)
      product.reviews.count.must_equal 2
    end

    it "responds to order_items" do
      product.must_respond_to :order_items
      product.order_items.must_equal []
    end

    it "can have many order items" do
      product.order_items.must_be_empty
      new_order_item = OrderItem.new(
        quantity: 1, price: 3, is_shipped: false, order: orders(:star_mouse_order)
      )
      second_order_item = OrderItem.new(
        quantity: 2, price: 2, is_shipped: false, order: orders(:star_mouse_order)
      )

      product.order_items << new_order_item
      product.order_items << second_order_item

      product.order_items.must_equal [new_order_item, second_order_item]
    end

    it "responds to merchant" do
      product.must_respond_to :merchant
    end

    it "has a merchant" do
      product.merchant.must_equal merchants(:astro)
    end

    it "can set the merchant" do
      product.merchant = merchants(:quasar)
      product.merchant.must_equal merchants(:quasar)
    end

    it "must be added to merchants's list of products" do
      merchant = merchants(:astro)
      merchant.products.must_include product
    end

  end

  describe "inventory_status method" do
    it "returns 'In Stock' if stock value is greater than 0" do
      value(product).must_be :valid?
      product.inventory_status.must_equal "In stock"
    end

    it "returns 'Out of stock' is stock is 0" do
      product.stock = 0
      product.inventory_status.must_equal "Out of stock"
    end
  end

  describe "get_average_rating method" do
    it "returns average rating of a product if it has existing reviews" do
      product.get_average_rating.must_equal "1.0 out of 5"
    end

    it "returns 'This product has no reviews' if product has no reviews" do
      product = products(:soap)
      product.reviews.count.must_equal 0
      product.get_average_rating.must_equal "This product has no ratings"
    end
  end

  describe "self.products_available method" do
    it "returns an array of products that are not discontinued" do
      Product.products_available.must_be_kind_of Array
      Product.products_available.count.must_equal 4
    end
  end
end
