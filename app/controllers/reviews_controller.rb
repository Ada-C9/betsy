class ReviewsController < ApplicationController
  before_action :find_review, only: [:show, :edit, :update, :destroy]
  before_action :find_user

  def index
    @reviews = Review.all
  end

  def show
    @reviews = Review
  end

  def new
    @review = Review.new
    @product = Product.find_by(id: params[:product_id])

  end

  def create

    @product = Product.find_by(id: params[:review][:product_id])
    # if session[:merchant_id] = @product.merchant_id
    #   flash[:status] = :failure
    #   flash[:result_text]= "AS a merchant u cannot review your own product"
    #   redirect_to product_path(@product.id)
    # else
    @review = Review.new(review_params)
    @review.product_id = @product.id

   if @review.save
     flash[:success] = "#{@review.rating} saved"
     redirect_to product_path(@product.id)
   else
     flash[:alert] = "Could not create #{@review.rating}"
     redirect_to product_path(@product.id)

   end
 #end
  end


  private

  def review_params
     return params.require(:review).permit(:rating, :comment,:product_id)
  end

  def find_review
    @review = Review.find_by(id: params[:id])
<<<<<<< HEAD

=======
    render_404 unless @review
>>>>>>> 797193163aa3d9fb5c9c26c1c89bc4c5771198f2
  end
end
