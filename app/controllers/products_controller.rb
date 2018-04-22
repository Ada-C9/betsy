class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:success] = 'Successfully added product'
      redirect_to merchant_products_path
    else
      flash.now[:failure] = 'Product not created'
      render :new, status: :bad_request
    end
  end

  def show; end

  def edit; end

  def update
    @product.assign_attributes(product_params)

    if @product.save
      flash[:succes] = "Successfully updated product #{@product.id}"
      redirect_to merchant_products_path
    else
      flash.now[:failure] = 'Product not updated'
      render :edit, status: :bad_request
    end
  end

  def destroy # this will likely be replaced or used 'non-restfully' - can retire an item but not destroy it
  end

  private

  def product_params
    return params.require(:product).permit(:name, :merchant_id, :stock, :price, :description)
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end
end
