class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def new
    @review = Review.new
    @action = product_reviews_path(params[:product_id])
  end

  def create
    @review = Review.new(review_params)
    @review[:product_id] = params[:product_id]
    @review.save
    if @review
      redirect_to product_path(params[:product_id])
      flash[:success] = "Your comment was saved"
    else
      render :new
      flash[:error] = "Comment was not saved"
    end

  end

private
def review_params
 params.require(:review).permit(:rating,:content)
end
end
