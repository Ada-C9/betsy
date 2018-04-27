require "test_helper"

describe ReviewsController do
  describe 'new' do
    it 'responds with success' do
      get new_review_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a review with valid data for an existing product" do
      review_data = {
        rating: 2,
        comment: "excellent",
        product_id: Product.first.id
      }
      Review.new(review_data).must_be :valid?
      old_review_count = Review.count

      post reviews_path, params: { review: review_data }

      must_respond_with :redirect
      must_redirect_to product_path(review_data[:product_id])
      Review.count.must_equal old_review_count + 1
      Review.last.comment.must_equal review_data[:comment]
    end
  end

  it "renders forbidden and does not update the DB when product belongs to the merchant" do
    product = Product.first
    merchant = product.merchant
    login(merchant)

    review_data = {
      rating: 2,
      comment: "excellent",
      product_id: product.id
    }
    Review.new(review_data).must_be :valid?
    old_review_count = Review.count

    post reviews_path, params: { review: review_data }

    must_respond_with :forbidden
    Review.count.must_equal old_review_count
  end

  it "renders bad request and does not update the DB for bogus data" do
    review_data = {
      rating: 0,
      comment: "disgusting",
      product_id: Product.first.id
    }
    Review.new(review_data).wont_be :valid?
    old_review_count = Review.count

    post reviews_path, params: { review: review_data }

    must_respond_with :bad_request
    Review.count.must_equal old_review_count
  end

  it "renders not found and does not update the DB for a fake product" do
    review_data = {
      rating: 3,
      comment: "average",
      product_id: Product.last.id + 1
    }
    Review.new(review_data).wont_be :valid?
    old_review_count = Review.count

    post reviews_path, params: { review: review_data }

    must_respond_with :not_found
    Review.count.must_equal old_review_count
  end
end
