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

    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @product = Product.find_by(id: params[:review][:product_id])

    if @product.merchant_id == session[:merchant_id]
      flash[:status] = :faliure
      flash[:result_text] = "You can not review your own product"
      redirect_back fallback_location: products_path
    else
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
  end

  private
  def review_params
    return params.require(:review).permit(:rating, :comment, :product_id)
  end

  def find_product
    @product = Product.find_by(id: params[:product_id])
    head :not_found unless @product
  end
end
