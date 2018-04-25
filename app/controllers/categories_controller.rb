class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create(category_params)

    if @category.save
      redirect_to categories_path
    else
      render :new
    end
  end

  def show
    @category = Category.find_by(id: params[:id])
    @products = @category.products
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end

end
