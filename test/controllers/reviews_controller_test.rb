require "test_helper"


describe ReviewsController do

  describe 'Create' do
    it 'will create a new review that is valid for a product' do

      proc{
        post product_reviews_path(products(:product_4).id), params:{
          review: {rating:reviews(:review_4).rating,
            content:reviews(:review_4).content,
            product:reviews(:review_4).product }
          }
        }.must_change 'Review.count', 1
        must_respond_with :redirect
        updated_review = Review.find_by(id: reviews(:review_4).id)
        updated_review.rating.must_equal 4
        updated_review.content.must_equal "content_4"
        updated_review.product.name.must_equal products(:product_4).name
        flash[:result_text].must_equal "Your comment was saved"
      end

      it 'will render a bad request for an invalid review' do
        proc{
          post product_reviews_path(products(:product_4).id), params:{
            review: {rating:"",
              content:reviews(:review_4).content,
              product:reviews(:review_4).product }
            }
          }.wont_change 'Review.count'

          must_respond_with :bad_request
        end
      end

      #end of class
    end
