class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def show
    @review = Review.find_by(id: params[:id])
    if @review == nil
      head :not_found unless @review
    end
  end

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created #{@review.singularize} #{@review.id}"
      redirect_to reviews_path(@review)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@review.singularize}"
      flash[:messages] = @review.errors.messages
      render :new, status: :bad_request
    end
  end

  private
  def review_params
    params.require(:rating).permit(:comment)
  end
end
