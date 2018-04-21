class ProductsController < ApplicationController

  # before_action :find_user

  def index
    if params[:category_id]
      category = Category.find_by(id: params[:category_id])
      @products = user.products
    elsif params[:user_id]
      user = User.find_by(id: params[:user_id])
      @products = user.products
    else
      @products = Product.all
    end
  end

  def new
    @product = Product.new
    @product.user = User.find(params[:user_id])
    @action = user_products_path(params[:user_id])
  end

  def create
    @product = Product.new(product_params)
    @product.user = User.find(params[:user_id])
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "#{@product.name} has been successfully created!"
      redirect_to product_path(@product.id)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create this product."
      flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
    # @review = Review.new
  end

  def edit
    @product = Product.find_by(id: params[:id])
    @product.user = User.find_by(id: params[:user_id])
    # @action = user_products_path(params[:user_id])
  end

  def update
    @product = Product.new(product_params)
    @product.user = User.find_by(id: params[:user_id])
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "#{@product.name} has been successfully updated!"
      redirect_to product_path(@product.id)
    else
      flash[:status] = :failure
      flash[:result_text] = "Update failed."
      flash[:messages] = @product.errors.messages
      render :edit, status: :bad_request
    end
  end

private

  def product_params
    params.require(:product).permit(:name, :is_active, :description, :price, :photo_url, :stock, :user_id, :category_ids => [])
  end
end
