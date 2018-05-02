class ReviewsController < ApplicationController

  def new
    @product = Product.find_by(id:params[:product_id])
    if !@merchant.nil? && @merchant.id == @product.merchant.id
      flash[:error] = "You can't review your own product!"
      redirect_to product_path(@product.id)
    else
      render_404 unless @product
      @review = Review.new
    end
  end

  def create
    @product = Product.find_by(id:params[:product_id])
    if !@merchant.nil? && @merchant.id == @product.merchant.id
      flash.now[:error] = "You can't review your own product!"
      redirect_to product_path(@product.id)
    else
      @review = Review.new(review_params)
      if @review.save
        flash[:success] = "Your review was added succesfully!"
        redirect_to product_path(@review.product_id)
      else
        flash[:error] = @review.errors
        @product = Product.find_by(id: params[:product_id])
        render :new, status: :bad_request
      end
    end
  end

  def review_params
    params.permit(:rating, :comment, :product_id)
  end
end
