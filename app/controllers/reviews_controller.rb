class ReviewsController < ApplicationController

  # I'm fairly certain we don't need these
  # def index
  #   @reviews = Review.all
  # end
  #
  # def show
  #   @review = Review.find_by(id: params[:id])
  #   head :not_found unless @review
  # end

  def new
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created a review"
      redirect_to product_path(@review.product_id)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create a review"
      flash[:messages] = @review.errors.messages
      redirect_back fallback_location: products_path, status: :bad_request
    end
  end

  private
  def review_params
    return params.require(:review).permit(:rating, :comment, :product_id)
  end
end
