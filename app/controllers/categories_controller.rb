class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)


    if @category.save
      flash[:success] = "Category created"
      redirect_to user_path(@user)
    else
      flash[:error] = "Category could not be created"
      redirect_back(fallback_location: user_path(@user))
    end
  end

  def show
    @category = Category.find_by(id: params[:id])

    if @category
      @products = @category.get_products
    else
      redirect_to root_path
    end
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end

end
