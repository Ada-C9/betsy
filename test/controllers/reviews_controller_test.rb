require "test_helper"

describe ReviewsController do


  describe 'new' do
    it 'responds with success' do
      get new_product_review_path(Product.first)
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a review with valid data for a real product" do
      review_data = {
        rating: 2,
        text: "the toy was just ok"
      }
      old_review_count = Review.count
      r = Review.new(review_data)
      r.product = Product.first
      r.must_be :valid?
      post product_reviews_path(Product.first), params: {review: review_data, product_id: Product.first.id}
      must_respond_with :redirect
      must_redirect_to product_path(Product.first)
      Review.count.must_equal old_review_count + 1
      Review.last.rating.must_equal review_data[:rating]
      Review.last.text.must_equal review_data[:text]
    end
  end

  it "won't add an invalid review" do
    review_data = {
      rating: nil,
      text: "the toy was just ok"
    }
    old_review_count = Review.count
    r = Review.new(review_data)
    r.product = Product.first
    r.wont_be :valid?
    post product_reviews_path(Product.first), params: {review: review_data, product_id: Product.first.id}
    must_respond_with :bad_request
    Review.count.must_equal old_review_count
  end
end
