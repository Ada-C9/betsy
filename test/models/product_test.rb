require "test_helper"

describe Product do
  describe "validations" do
    before do
      @product = products(:dog)
    end

    describe "price" do
      it "has a price" do
        @product.price.must_equal 2750.00
      end


      it "must have a valid price" do
        @product.price = 0
        @product.valid?.must_equal false
      end
    end

    describe "name" do
      it "must have a name" do
        @product.name.must_equal "Cavalier King Charles Spaniel"
      end

      it "must have a valid name" do
        @product.name = ""
        @product.valid?.must_equal false
      end
    end

    describe "stock" do
      it "must be a number" do
        @product.stock = "c"
        @product.valid?.must_equal false
      end

      it "can be equal to 0" do
        @product.stock = 0
        @product.valid?.must_equal true
      end

      it "must not be less than 0" do
        @product.stock = -2
        @product.valid?.must_equal false
      end
    end
  end

  describe "relations" do
    before do
      @product = products(:dragon)
    end

    describe "reviews" do
      it "responds to reviews with no reviews" do
        a = products(:dog)
        a.reviews.count.must_equal 0
      end

      it "responds to reviews" do
        @product.reviews.count.must_equal 2
      end

      it "can register new reviews" do
        Review.create({
          text_review: "This is another review that will be created",
          rating: 2,
          product_id: @product.id,
          user_id: users(:ada)
          })

          @product.reviews.count.must_equal 3
      end
    end

    describe "categories" do
      it "responds to categories with no categories added" do
        @product.categories.length.must_equal 0
      end

      it "responds to categories with added categories" do
        @product.categories << categories(:three)
        @product.categories.length.must_equal 1
      end
    end
  end

  describe "methods" do
    describe "by_category" do
      it "returns an empty array if category has no items" do
        Product.by_category(categories(:one)).length.must_equal 0
        Product.by_category(categories(:one)).must_equal []
      end

      it "returns an item assigned to a category" do
        product = products(:cat)
        product.categories << categories(:one)
        product.categories << categories(:three)

        product.categories.must_include categories(:one)

        filtered = Product.by_category(categories(:one))

        filtered.length.must_equal 1
        filtered.first.name.must_equal product.name
      end

      it "returns multiple items assigned to a category" do
        Product.by_category(categories(:three)).must_equal []

        product_1 = products(:cat)
        product_2 = products(:dragon)
        product_1.categories << categories(:three)
        product_2.categories << categories(:three)

        filtered = Product.by_category(categories(:three))

        filtered.length.must_equal 2
      end
    end

    describe "by_merchant" do #is this method redundant?
      before do
        @user = users(:lily)
      end
      it "returns an empty array if merchant has no items" do
        @user.products.must_equal []
        Product.by_merchant(@user.id).must_equal []
      end

      it "returns an item assigned to a user" do
        data = {
          name: "Bunny",
          stock: 14,
          price: 5,
          description: "Too many, please help",
          status: true,
          user_id: @user.id,
          image_url: "www.test-URL.com"
        }

        Product.create(data)
        Product.by_merchant(@user.id).length.must_equal 1
      end

      it "returns multiple items assigned to a category" do

        Product.create({
          name: "Jaguar",
          stock: 2,
          price: 500,
          description: "Excellent",
          status: true,
          user_id: @user.id,
          image_url: "https://placebear.com/g/500/400"
          })

        Product.create({
          name: "Bunny",
          stock: 14,
          price: 5,
          description: "Too many, please help",
          status: true,
          user_id: @user.id,
          image_url: "www.test-URL.com"
          })

        Product.by_merchant(@user.id).length.must_equal 2
      end
    end
  end
end
