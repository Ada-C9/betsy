class CategoriesController < ApplicationController
  before_action :find_category, only: [:show]
  def index
    @categories = Category.all
  end

  def new
    if params[:merchant_id]
      @category = Category.new
    else
      flash[:message] = "You must log in to add a category"
    end
  end

  def show; end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:status] = :success
      flash[:result_text] = "Category added successfully"
      redirect_to new_merchant_product_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Failed to add new category"
      flash.now[:messages] = @category.errors.messages
      render :new, status: :bad_request
    end
  end

  private
  def category_params
    return params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
    head :not_found unless @category
  end
end
