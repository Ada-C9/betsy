class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    if @merchant.nil?
      render_404
    else
      @category = Category.new
    end
  end

  def create
    if @merchant.nil?
      render_404
    else
      @category = Category.new(category_params)
      if @category.save
        flash[:success] = "Successfully created category: #{@category.name}!"
        redirect_to merchant_products_path(@merchant.id)
      else
        flash[:alert] = @category.errors
        render :new, status: :bad_request
      end
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end

end
