class ReviewsController < ApplicationController

  def index
    @reviews = Review.all
  end

  def new
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new(product: @product)
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new(review_params)
    @review.product = @product

    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created review"
      redirect_to product_path(@product)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create review"
      flash[:messages] = @review.errors.messages
      render :new, status: :bad_request
    end
  end

  private
  def review_params
    params.require(:review).permit(:rating, :comments)
  end

end
