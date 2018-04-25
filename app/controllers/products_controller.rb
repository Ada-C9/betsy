class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  before_action :find_user

  def root
    @products = Product.all
  end

  def index
    @products = Product.all

    # If using this path for displaying the logged in user's products:
    if @user.id == params[:merchant_id].to_i
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
      flash[:status] = :success
      redirect_to product_path(@product.id)
    else
      flash[:failure] = :failure
      flash.now[:result_text]= "Error: product was not added"
      render :new
    end
  end

  def edit
  end

  def update
    @product.merchant_id = @merchant.id
    assign_merchant_id
    if @product.update(product_params)
      flash[:success] = "#{@product.name} updated"
      redirect_to product_path(@product.id)
    else
      binding.pry
      flash[:alert] = "A problem occured : Could not update"
      render :edit
    end
  end

  def destroy
    # if @product.destroy
    #   flash[:message] = "Deleted #{@product.name}"
    #   redirect_to products_path
    # end
  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :quantity, :description, :category_ids => [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    render_404 unless @product
  end

  def assign_merchant_id
    @product.merchant_id = @user.id
  end
end
