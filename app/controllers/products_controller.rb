class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :delete]
  skip_before_action :require_login, only: [:root, :index, :show]



  def root
    @products = Product.all
  end

  def index
    if params[:category_id]
      @category = Category.find(params[:category_id])
      @products = @category.products
    elsif params[:user_id]
      @merchant = User.find(params[:user_id])
      @products = @merchant.products
    else
      @products = Product.all
    end
  end

  def show
    @review = Review.new
  end

  def new
    @product = Product.new(user_id: params[:user_id])
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = @login_user.id
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Product added successfully"
      redirect_to products_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not add product"
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
    params.require(:product).permit(:name,:description, :price, :stock, :url, :quantity, :retired)
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end

end
