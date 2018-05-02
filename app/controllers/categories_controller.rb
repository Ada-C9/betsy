class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]
  before_action :find_user

  def index
    @categories = Category.all
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:status] = "success"
      flash[:result_text] = "Successfully added #{@category.name}"

      redirect_to new_product_path

      #categories_path(@category.id)
    else
      flash[:status] = "failure"
      flash[:result_text] = "Could not create this category"
      redirect_to categories_path
    end
  end

  def update
    if @category.update(category_params)
      flash[:status] = "success"
      flash[:result_text] = "Category updated!"
      redirect_to categories_path(@category)
    else
      flash.now[:status] = "failure"
      flash[:result_text] = "Could not update this category"
      render :edit, status: :not_found
    end
  end

  def edit
  end

  def destroy
    # shouls a user be able to delete a category? Maybe not...
    @category.destroy if @category
    redirect_to categories_path
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
    render_404 unless @category
  end
end
