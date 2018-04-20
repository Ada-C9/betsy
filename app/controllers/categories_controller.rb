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
      flash[:status] = :success
      flash[:result_text] = "Successfully created a category for #{@category.name}!"
      # redirect_to user_path(@user)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create this category."
      flash[:messages] = @category.errors.messages
      render :new, status: :bad_request
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
