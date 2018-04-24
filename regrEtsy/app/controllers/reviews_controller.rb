class ReviewsController < ApplicationController
  before_action :find_product, only: [:new]

  def new
    #needs validation on session[:user_id] to check that they aren't reviewing their own product they sell; is user_id on product the seller?
    @review = Review.new
  end

  def


  private
  def find_product
    @product = Product.find_by(id: params[:product_id])

    unless @product
      head :not_found
    end
  end

  def review_params
    return params.require(:review).permit(:rating, :review, :product_id)
  end
end
