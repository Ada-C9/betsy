class ReviewsController < ApplicationController

  def create
    @review = Review.new(review_params)
    @review[:product_id] = params[:product_id]
    if @review.save
      redirect_to product_path(params[:product_id])
      flash[:status] = :success
      flash[:result_text] = "Your comment was saved"
    else
      render :new, status: :bad_request
      flash[:status] = :failure
      flash[:result_text] = "Your comment was not saved"
      flash[:messages] = @review.errors.messages
    end
  end

  private
    def review_params
     params.require(:review).permit(:rating,:content)
    end
end
