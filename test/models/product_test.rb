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

      it "must be a number greater than or equal to 0" do
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
  end
