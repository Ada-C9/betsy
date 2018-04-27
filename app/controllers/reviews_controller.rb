class ReviewsController < ApplicationController

  before_action :find_product, only: [:new]

  def new
    if session[:user_id] == @product.user_id
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
      flash[:result_text] = "Successfully reviewed!"
      redirect_to product_path(@product.id)

    else
      render :new, status: :bad_request
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

end
