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
    end
  end
end
