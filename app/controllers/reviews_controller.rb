class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def show
    @review = Review.find_by(id: params[:id])
    head :not_found unless @review
  end

  def new
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new
  end

  def create
    @review = Review.new(product_id: params[:product_id], rating: params[:rating], comment: params[:comment])
    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created a review"
      redirect_to products_path
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create a review"
      flash[:messages] = @review.errors.messages
      redirect_back(fallback_location: products_path)
    end
  end

  private
  def review_params
    return params.require([:review][:rating], [:review][:product_id]).permit([:review][:comment])
  end
end
