require "test_helper"

describe ReviewsController do
  before do
    @product = {
      id: 3,
      name: 'controller test product',
      user_id: User.first.id
    }
  end
  describe 'new' do
    it 'succeeds with new review' do
      get new_product_review_path
      must_respond_with :success
    end
  end

  describe 'create' do
    it 'can add a valid review' do

      # Arrange
      review_data = {
        rating: 5,
        review: 'This was a great product',
        product_id: 3
      }

      review_count = Review.count
      #Assumptions
      result = Review.new(review_data)
      result.must_be :valid?
      # Act
      post product_reviews_path, params: { review: review_data }
      # Assert
      must_respond_with :redirect
      must_redirect_to product_path(@product)

      Review.count.must_equal review_count + 1
    end

    it "won't add an invalid review" do
      review_data = {
        rating: 5,
        review: 'This was a great product',
        product_id: 3
      }
      review_count = Review.count

      Review.new(review_data).wont_be :valid?

      post product_reviews_path, params: { review: review_data }

      must_respond_with :bad_request
      Review.count.must_equal review_count
    end
  end
  end
