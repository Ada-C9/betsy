require "test_helper"

describe ReviewsController do
  describe "index" do
    it "should get index" do
      get reviews_path
      must_respond_with :success
    end

  end
  describe "show" do
    it "should get show" do
      get reviews_path(reviews(:candy).id)
      value(response).must_be :success?
    end
  end

  describe "new" do
    it "should get new" do

      get new_product_review_path(products(:candy).id)
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a review with valid data" do

      proc {
        post reviews_path, params: {
          review: {
            product_id: products(:candy).id,
            rating: 2,
            comment:"reviewtext"
          }
        }
      }.must_change 'Review.count', 1

      # Assert
      must_respond_with :redirect
      must_redirect_to product_path(products(:candy).id)
    end

    it " does not update the DB for bogus data" do
      review_data = {
        review: {
          product_id: products(:candy).id,
          rating: nil
        }
      }
      start_count = Review.count
      Review.count.must_equal start_count
    end
  end
end
