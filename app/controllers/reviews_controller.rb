class ReviewsController < ApplicationController
  skip_before_action :require_login

  def create
    @review = Review.new(review_params)
    @review.product_id = params[:product_id]

    if @current_user && @current_user.products.include?(@review.product)
      flash[:error] = "You can't review your own products"
      redirect_to product_path(@review.product)

    elsif @review.save
      redirect_to product_path(@review.product_id)
    else
      flash[:error] = "You must submit a rating of 1-5 and a description."
      @product = Product.find_by(id: params[:product_id])
      render 'products/show', status: :bad_request
    end
  end
end

private
def review_params
  return params.require(:review).permit(:rating, :description)
end
