class CategoriesController < ApplicationController
  before_action :current_or_guest_user

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

  private
  def category_params
    params.require(:category).permit(:name)
  end

end
