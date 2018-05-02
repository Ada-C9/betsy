require "test_helper"

describe Review do
  let(:review) { Review.new rating:1, comment:"A coment here" }

  describe "validations" do
    it "must be valid" do
      review.product = products(:candy)

      review.valid?.must_equal true
    end

    it "must be have a rating" do
      review.rating = nil

      review.valid?.must_equal false
      review.errors.must_include :rating
    end

    it "rating must be between 1 and 5" do
      review.rating = 6

      review.valid?.must_equal false
      review.errors.must_include :rating
    end
  end

  describe "relations" do
    it "belongs to a product and creates an error message if no product is given" do
      review = Review.new(rating: 1, comment:"qwewe")
      review.must_respond_to :product

      review.wont_be :valid?
      review.errors.messages.must_include :product
    end
  end

end
