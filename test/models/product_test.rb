require "test_helper"

describe Product do
  let(:product) { Product.new }
  let(:p) { products(:product_1)}

  describe "relations" do
    it "has an user" do
      p.must_respond_to :user
      p.user.must_be_kind_of User
      p.user.must_equal users(:user_1)
    end

    it "has a list of categories" do
      p.categories.each do |cat|
        cat.must_be_instance_of Category
        cat.products.must_be_instance_of Array
        cat.products.must_include p
      end
    end

    it "belongs to many categories" do
      Product.first.categories << categories(:category_1)
      Product.first.categories << categories(:category_2)
      Product.last.categories << categories(:category_1)
      Product.first.categories.must_equal [categories(:category_1),categories(:category_2)]
      Product.last.categories.must_equal [categories(:category_1)]
    end

    it "has a list of reviews " do
      p.reviews.each do |review|
        review.must_be_instance_of Review
        review.product.must_be_instance_of Product
        review.product.must_equal p
      end
    end

    it "has a list of orderitems " do
      p.order_items.each do |order_item|
        order_item.must_be_instance_of OrderItem
        order_item.product.must_be_instance_of Product
        order_item.product.must_equal p
      end
    end

  end

  describe "validations" do
    it "has validation for empty parameters" do
      product.valid?.must_equal false
    end

    it "has validation for name presence" do
      p.name = nil
      p.valid?.must_equal false
      p.errors.messages.must_include :name

      p.name = ""
      p.valid?.must_equal false
      p.errors.messages.must_include :name
    end

    it "has validation for name uniqueness" do
      p1 = Product.new({ name: p.name, is_active: true, description: "description_1", price: 1, photo_url: nil, stock: 1,user: users(:user_1) })
      p1.valid?.must_equal false
      p1.errors.messages.must_include :name
    end

    it "has validation for name case insensitive uniqueness" do
      p1 = Product.new({ name: p.name.downcase, is_active: true, description: "description_1", price: 1, photo_url: nil, stock: 1,user: users(:user_1) })
      p1.valid?.must_equal false
      p1.errors.messages.must_include :name

      p1 = Product.new({ name: p.name.upcase, is_active: true, description: "description_1", price: 1, photo_url: nil, stock: 1,user: users(:user_1) })
      p1.valid?.must_equal false
      p1.errors.messages.must_include :name
    end

    it "has validation for price presence" do
      p.price = nil
      p.valid?.must_equal false
      p.errors.messages.must_include :price

      p.price = ""
      p.valid?.must_equal false
      p.errors.messages.must_include :price
    end

    it "has price as integer, greater than 0" do
      ["one", -1, 0].each {|element|
        p.price = element
        p.valid?.must_equal false
      }
    end

    it "has validation for stock presence" do
      p.stock = nil
      p.valid?.must_equal false
      p.errors.messages.must_include :stock

      p.stock = ""
      p.valid?.must_equal false
      p.errors.messages.must_include :stock
    end

    it "has stock as integer, greater than or equal to 0" do
      ["one", -1].each {|element|
        p.stock = element
        p.valid?.must_equal false
      }
    end


    it "must be valid" do
      p.valid?.must_equal true
    end

    it "computes average rating" do
      r = Review.create({
        rating: 5, content: "content_5", product: p })
        p.average_rating.must_equal 3
      end

      it "computes average rating as 0 when no reviews" do
        product.average_rating.must_equal 0
      end

      it "toggle_is_active" do
        p = Product.new
        p.toggle_is_active
        p.is_active.must_equal false

        p.toggle_is_active
        p.is_active.must_equal true
      end
    end
  end
