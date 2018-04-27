class ProductsController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:index, :show]


  def index
    @category = Category.new
    @user = User.new
    if params[:category_id]
      @current_category = Category.find_by(id: params[:category_id])
      @products = @current_category.products
      @current_user = nil
    elsif params[:user_id]
      @current_user = User.find_by(id: params[:user_id])
      @products = @current_user.products
      @current_category = nil
    elsif params[:term]
      @products = Product.search(params[:term])
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
    @product.price = params[:product][:price].to_i * 100
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
    if @product.nil?
      render_404
    else
      @review = Review.new
      @action = product_reviews_path(params[:id])
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      render_404
    else
      @action = product_path(params[:id])
    end
  end

  def update
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      render_404
    else
      @product.update(product_params)
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
  end

  def set_status
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      render_404
    else
        @product.toggle_is_active
        @product.save
      redirect_back fallback_location: user_path(@product.user)
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :is_active, :description, :price, :photo_url, :stock, :user_id, :term, :category_ids => [] )
  end
end
