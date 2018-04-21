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
end
