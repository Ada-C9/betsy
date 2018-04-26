class ReviewsController < ApplicationController

  def create
    @review = Review.new(review_params)
    @review[:product_id] = params[:product_id]
    @review.save
    if @review
      redirect_to product_path(params[:product_id])
      flash[:status] = :success
      flash[:result_text] = "Your comment was saved"
    else
      render :new
      flash[:status] = :failure
      flash[:result_text] = "Your comment was saved"
      flash[:messages] = @review.errors.messages , status: :bad_request
    end

  end

private
def review_params
 params.require(:review).permit(:rating,:content)
end
end
