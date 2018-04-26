require "test_helper"
require 'pry'

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
      end

      it 'will render a bad request for an invalid review' do
        proc{
          post product_reviews_path(products(:product_4).id), params:{
            review: {rating:"",
              content:reviews(:review_4).content,
              product:reviews(:review_4).product }
            }
          }.must_change 'Review.count', 0
          must_respond_with :bad_request
        end
      end

      #end of class
    end
