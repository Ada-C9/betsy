
require "test_helper"

describe Review do
  let(:review) { Review.new }
  let(:ball) {reviews(:one_star)}
  let(:sweater) {reviews(:five_star)}

  it "must be valid" do
    ball.must_be :valid?
  end

  it "must have rating present" do
    ball.rating = 1
    ball.valid?.must_equal true

    ball.rating = "  "
    ball.valid?.must_equal false
  end

  it "belongs to product" do
    sweater.product.must_equal products(:sweater)
    sweater.product_id.must_equal products(:sweater).id
  end

  it "must have ratings between 1-5" do
    (1..5).each do |n|
      review = Review.new(rating: n, product: products(:sweater))
      review.valid?.must_equal true
    end
  end

  it "can't have ratings over 5 or less than 1" do
    [-1, 0, 10].each do |n|
      review = Review.new(rating: n, product: products(:sweater))
      review.valid?.must_equal false
    end
  end

end
