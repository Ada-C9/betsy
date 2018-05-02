class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  before_action :find_user

  def root
    @products = Product.all
  end

  def index
    @products = find_active_products
    # If using this path for displaying the logged in user's products:
    if @user && @user.id == params[:merchant_id].to_i
      @user_products = Product.where(merchant_id: @user.id).order(id: :desc)
    end
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    assign_merchant_id

    if @product.save
      flash[:status] = "success"
      flash.now[:result_text] = "#{@product.name} was created"
      redirect_to product_path(@product.id)
    else
      flash[:status] = "failure"
      flash.now[:result_text]= "Error: product was not added."
      flash.now[:messages] = @product.errors.messages
      render :new
    end
  end

  def edit
  end

  def update

    assign_merchant_id

    if @product.update(product_params)

      flash[:status] = "success"
      flash.now[:result_text]= "#{@product.name} updated"
      redirect_to product_path(@product.id)
    else
      flash[:status] = "failure"
      flash.now[:result_text]= "A problem occured : Could not update"
      flash.now[:messages] = @product.errors.messages
      render :edit
    end
  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :quantity, :status, :photo, :description, :category_ids => [])
  end

  def find_active_products
    return Product.where(status:"active")
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    render_404 unless @product
  end

  def assign_merchant_id
    @product.merchant_id = @user.id
  end
end
