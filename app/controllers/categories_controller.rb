class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def new
    if current_user
      @category = Category.new
    else
      flash[:status] = :failure
      flash[:result_text] = "You need to be logged in to add a category"
      redirect_to users_path
    end
    
  end

  def create
    @category = Category.new(category_params)
    @category.save
    redirect_to users_path
  end

  private
  def category_params
    params.require(:category).permit(:name, product_ids:[])
  end


end
