class ReviewsController < ApplicationController
  # before_action :find_product, only: [:new, :create]
  skip_before_action :require_login

  def new
    #needs validation on session[:user_id] to check that they aren't reviewing their own product they sell; is user_id on product the seller?
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)

    @review.product_id = @product.id
    #added this line back
    if session[:user_id] == @product.user_id
      flash[:status] = :error
      flash[:result_text] = "You can't review your own products!"
      redirect_to product_path(@review.product_id)

    elsif @review.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created review"
      redirect_to product_path(@product)
    else
      flash.now[:status] = :error
      flash.now[:result_text] = "Could not create Review"
      render :new, status: :bad_request
    end
  end

  private

  def review_params
    return params.require(:review).permit(:rating, :product_id, :review)
  end

end
