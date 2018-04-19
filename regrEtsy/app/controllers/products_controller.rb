class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :delete]


  def root
    @products = Product.all
  end

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Product added successfully"
      redirect_to products_path
    else
      # Validations failed! What do we do?
      # This flash message is redundant but for demonstration purposes
      flash.now[:failure] = "Cound not add product"
      render :new, status: :bad_request
    end
  end

  def edit; end

  def update
    @product.assign_attributes(product_params)

    if @product.save
      redirect_to product_path(@product)
    else
      render :edit, status: :bad_request
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  private
  def product_params
    return params.require(:product).permit(:name,:description, :price, :stock, :url, :user_id)
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end
end
