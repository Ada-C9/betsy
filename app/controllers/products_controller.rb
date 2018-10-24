class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy, :retire]
  before_action :require_login, except: [:index, :show]

  def index
    @products = Product.order(:name)
    @products = @products.select { |product| product.product_status == nil }
  end

  def new
    @product = Product.new(user_id: session[:user_id])
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path
    else
      flash[:failure] = "failed to save"
      render :new, :status => :bad_request
    end
  end

  def show
    @review = Review.new
    @cart_item = Cartitem.new
    @categories = @product.categories
  end

  def edit;end

  def update
    @categories = @product.categories
    @product.assign_attributes(product_params)
    if @product.save
      redirect_to product_path(@product)
    else
      render :edit, :status => :bad_request
    end
  end

  def retire
    @product.product_status = 'retired'

    if @product.save
      flash[:success] = "Product successfully retired"
      redirect_back fallback_location: root_path
    else
      flash[:failure]="Unable to delete the product"
      redirect_back fallback_location: root_path
    end
  end


  private
  def product_params
    return params.require(:product).permit(:name, :price, :stock, :product_status, :user_id, :image, :description, category_ids: [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    if !@product
      @product = Product.find_by(id: params[:product_id])
    end

    head :not_found unless @product
  end

end
