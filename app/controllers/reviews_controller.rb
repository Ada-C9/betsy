class ReviewsController < ApplicationController

  before_action :current_or_guest_user
  before_action :find_product,

  def new
    if session[:user_id] == @product.user_id
      flash[:status] = :failure
      flash[:message] = "You cant review your product"
      redirect_to products_path
      return
    else
      @review = Review.new
    end
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    @review = @product.reviews.new(
      review_params
    )
    if @review.save
      redirect_to product_path(@product.id)
    # save_and_flash(@review, name: "")
    #   redirect_to product_path(review_params[:product_id])
      # return
    else
      render :new, status: :bad_request
    end
  end
end

private

def find_product
  @product = Product.find_by(id: params[:product_id])
  unless @product
    head :not_found
  end
end

def review_params
  return params.require(:review).permit(:rating, :text_review, :product_id)
end
