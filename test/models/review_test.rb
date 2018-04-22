require "test_helper"

describe Review do
  let(:review) { Review.new }
  let(:r) { reviews(:review_1) }

  describe "relationships" do
    it "has a product" do
      r.must_respond_to :product
      r.product.must_be_kind_of Product
      r.product.must_equal products(:product_1)
    end
  end

  describe "validations" do
    it "has validation for empty parameters" do
      review.valid?.must_equal false
    end

    it "has validation for rating presence" do
      r.rating = nil
      r.valid?.must_equal false
      r.errors.messages.must_include :rating

      r.rating = ""
      r.valid?.must_equal false
      r.errors.messages.must_include :rating
    end

    it "has rating as integer, greater than 0" do
      ["one", -1, 0].each {|element|
        r.rating = element
        r.valid?.must_equal false
      }
    end

    it "has validation for rating to be between 1..5" do
      [-1,0,6,22].each {|element|
        r = Review.new({rating: element, content: "content_1", product: products(:product_1)})
        r.valid?.must_equal false
      }
    end

    it "must be valid" do
      r.valid?.must_equal true
    end
  end
end
