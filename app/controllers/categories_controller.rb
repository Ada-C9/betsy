class CategoriesController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:create]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    category_id = params[:category][:id]
    if category_id
      redirect_to category_products_path(category_id)
    else
      @category = Category.new(category_params)

      if @category.save
        flash[:status] = :success
        flash[:result_text] = "Successfully created a category for #{@category.name}!"
        redirect_to products_path
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not create this category."
        flash[:messages] = @category.errors.messages
        render :new, status: :bad_request
      end
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
