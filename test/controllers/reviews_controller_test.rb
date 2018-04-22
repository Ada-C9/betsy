require "test_helper"

describe ReviewsController do


  describe "create" do
    it "creates a review with valid data for a real product" do
      review_data = {
        rating: 2,
        text: "the toy was just ok"
      }
      old_review_count = Review.count
      # Review.new(review_data).must_be :valid?
      post product_reviews_path(Product.first), params: {review: review_data, product_id: Product.first.id}
      # must_respond_with :redirect
      # must_redirect_to product_path(Review.last)
      Review.count.must_equal old_review_count + 1
      Review.last.rating.must_equal review_data[:rating]
      Review.last.text.must_equal review_data[:text]
    end
  end
end
