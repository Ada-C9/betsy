require "test_helper"

describe ReviewsController do
  describe 'index' do
    it 'can succeed with all categories' do
      Review.count.must_be :>, 0

      get reviews_path
      must_respond_with :success
    end

    it 'can succeed with no categories' do
      Review.destroy_all

      get reviews_path
      must_respond_with :success
    end
  end

  describe 'show' do
    it "can find an exsisting category" do
      get review_path(Review.first)
      must_respond_with :success
    end

    it "renders 404 not found for a fake id" do
      fake_review_id = Review.last.id + 1
      get review_path(fake_review_id)
      must_respond_with :not_found
    end
  end

  describe 'new' do
    it 'responds with success' do
      get new_review_path
      must_respond_with :success
    end
  end

  describe 'create' do
    it 'can add a valid review' do
      review_data = {
        rating: 2,
        comment: "nothing important"
      }

      counting = Review.count

      post reviews_path, params: {review: review_data}

      must_respond_with :redirect
      must_redirect_to review_path(Review.last.id)

      Review.count.must_equal counting + 1
      Review.last.rating.must_equal review_data[:rating]
    end

    it 'will not add an invalid review' do
      review_data = {
        rating: "A",
        comment: "not correct"
      }

      counting = Review.count

      Review.new(review_data).wont_be :valid?

      post reviews_path, params: { review: review_data}

      must_respond_with :bad_request
      Review.count.must_equal counting
    end
  end
end
