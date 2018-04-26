class ReviewsController < ApplicationController

  def create
    @review = Review.new(review_params)
    @review[:product_id] = params[:product_id]
    binding.pry
      if @review.save
        redirect_to product_path(params[:product_id])
        flash[:success] = "Your comment was saved"
      else
        binding.pry
        render :new, status: :bad_request
        flash[:error] = "Comment was not saved"
      end
  end

private
def review_params
 params.require(:review).permit(:rating,:content)
end
end
