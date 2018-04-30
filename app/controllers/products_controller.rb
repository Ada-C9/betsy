class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :retire, :destroy]
  before_action :correct_merchant, only: [:edit, :update, :destroy]
  skip_before_action :require_login, only: [:index, :root, :show]

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
    @product = Product.new(merchant: @current_user)
  end

  def create
    @product = Product.new(product_params)
    @product.merchant = @current_user

    if @product.save
      flash[:success] = "Product added successfully"

      redirect_to merchant_products_path(@current_user.id)

    else
      flash.now[:failure] = "Validations Failed"
      render :new, status: :bad_request
    end
  end


  def show
  end

  def edit

    # Check that the current_user matches the user associated with the product
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

  def retire
    if @product.merchant = @current_user
      @product.available = 0
      if @product.save
        flash[:success] = "Successfully retired."
      else
        flash[:failure] = "Could not Retire, Try Again"
      end
    end
    redirect_to products_path
  end

  private
  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end

  def correct_merchant
    # find_product
    unless session[:merchant_id] == @product.merchant.id
      flash[:error] = "Merchant and product do not match"
      redirect_to root_path
    end
  end

  def product_params
    return params.require(:product).permit(:name, :price, :available, :photo, :description)
  end

  def review_params
    return params.require(:review).permit(:rating, :description)
  end

end
