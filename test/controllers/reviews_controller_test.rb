require "test_helper"

describe ReviewsController do
  describe "Guest users" do

    it "should get a new form" do
      get new_product_review_path(products(:ball))
      must_respond_with :success
    end

    it "renders 404 not_found" do
      get new_product_review_path(-1)
      must_respond_with :not_found
    end

    it "should be able to create a review" do
      proc { post product_reviews_path(products(:ball)), params: { rating: 1}}.must_change 'Review.count', 1
      must_respond_with :redirect
    end

    it "it won't create a review with bad data" do
      proc { post product_reviews_path(products(:ball)), params: { rating: 7}}.must_change 'Review.count', 0
      must_respond_with :bad_request
    end
  end

  describe "Logged in users" do
    it "won't let a merchant review their own product" do
      perform_login(merchants(:astro), :github)
      get new_product_review_path(products(:ball))
      must_respond_with :redirect
      post product_reviews_path(products(:ball)), params: { rating: 5}
      must_respond_with :redirect
    end

    it "will let other users vote for a product" do
      perform_login(merchants(:astro), :github)
      get new_product_review_path(products(:icecream))
      must_respond_with :success

      proc { post product_reviews_path(products(:icecream)), params: {rating: 5}}.must_change 'Review.count', 1
      must_respond_with :redirect
    end
  end
end
