require "test_helper"

describe ReviewsController do
  describe 'new' do
    it 'responds with success with a logged out user' do
      product = Product.first
      get new_product_review_path(product)

      must_respond_with :success
    end

    it "renders 404 not_found " do
      get new_product_review_path(-1)
      must_respond_with :not_found
    end

    it "won't let the product's owner to review product" do
      product_id = Product.first.id
      login(users(:one))
      get new_product_review_path(products(:product1))
      must_respond_with :redirect

      post product_reviews_path(products(:product1)), params: {rating: 5, comments: "la la la", product_id: product_id}
      must_respond_with :redirect
    end
  end

  describe "create" do

    it "it won't create a review with bogus data" do
      product = Product.create(name:"cat rug",price: 10, user: users(:one), stock: 15)
      start = product.reviews.count
      post product_reviews_path(product.id), params: {review:{rating: 15, comments: "beautiful"}}
      product.reviews.count.must_equal start
      must_respond_with :bad_request
    end

    it "creates a review with valid data" do
      product_id = Product.first.id
      review_data = { rating: 5, comments: 'comments', product_id: product_id  }

      old_review_count = Review.count

      Review.new(review_data).must_be :valid?
      post product_reviews_path(product_id), params: { review: review_data}

      must_respond_with :redirect
      must_redirect_to product_path(product_id)
      Review.count.must_equal old_review_count + 1
      Review.last.comments.must_equal 'comments'
    end

  end
end
