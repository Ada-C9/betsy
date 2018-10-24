class ReviewsController < ApplicationController
  before_action :find_product, only: [:create, :new]
  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.product = @product

      if @review.save
        flash[:success] = "Review added successfully"
        redirect_to product_path(@product)
      else
        flash.now[:failure] = "Please add ratind"
        render :new, status: :bad_request
      end
  end

  private

    def review_params
      return params.require(:review).permit(:text, :rating)
    end

    def find_product
      @product = Product.find_by(id: params[:product_id])
      head :not_found unless @product
      return @product
    end
end
