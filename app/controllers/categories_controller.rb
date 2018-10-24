class CategoriesController < ApplicationController
before_action :find_category, only: [:show, :destroy]
before_action :require_login, except: [:index, :show]

  def index
    @categories = Category.select_with_products
  end

  def show; end

  def new
    @category = Category.new()
  end

  def create
    @products = Product.new
    @category = Category.new(category_params)

    if @category.save
      # redirect_to '/books'
      flash[:success] = "Category created successfully"
      redirect_to categories_path
    else
      # Validations failed! What do we do?
      # This flash message is redundant but for demonstration purposes
      flash.now[:failure] = "Validations Failed"
      render :new, status: :bad_request
    end
  end

  def destroy

    if @category.products.count > 0
      flash.now[:failure] = "Category contains active products, deletion failed."
    else
      @category.destroy
      flash[:success] = "Category deleted successfully"
    end

    redirect_to categories_path
  end

private
  def find_category
    @category = Category.find_by(id: params[:id])

    head :not_found unless @category
  end

  def category_params
    params.require(:category).permit(:name, product_ids: [])
  end
end
