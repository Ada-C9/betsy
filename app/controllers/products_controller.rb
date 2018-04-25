class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  skip_before_action :require_login, only: [:root, :index]

  def root
    @products = Product.all
    @categories = Category.all
    @merchants = Merchant.all
  end

  def index
    merch_id = params[:merchant_id]
    if merch_id.nil?
      @products = Product.all
      @order_product = current_order.order_products.new
    else
      @products = Merchant.find(merch_id).products
    end
  end

  def new
    @product = Product.new(merchant_id: params[:merchant_id])
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:success] = "Product added successfully"

      redirect_to merchant_products_path(@current_user.id)

    else
      flash.now[:failure] = "Validations Failed"
      render :new, status: :bad_request
    end
  end

  def edit; end

  def show
    @order_product = current_order.order_products.new
  end

  def update
    @product.assign_attributes(product_params)

    if @product.save
      redirect_to product_path
    else render :edit, status: :bad_request
    end
  end

  def destroy
    @product.destroy

    redirect_to products_path
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id])

    head :not_found unless @product
  end

  def product_params
    return params.require(:product).permit(:name, :price, :available, :merchant_id)
  end

  def review_params
    return params.require(:review).permit(:rating, :description)
  end

end
