class ProductsController < ApplicationController
  before_action :current_or_guest_user

  def new
    @product = Product.new
  end

  def create
    @product = Product.create(product_params)

    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created #{@product.name}"
      redirect_to products_path
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@product.name}"
      flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      redirect_to products_path
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])
  end

  def update
    @product = Product.find_by(id: params[:id])
    if @product.update(product_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@product.name}"
      redirect_to products_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update #{@media_category.singularize}"
      flash.now[:messages] = @work.errors.messages
      render :edit, status: :not_found
    end
  end


  private
  def product_params
    params.require(:product).permit(:name, :stock, :price, :description, :status, :user_id, :image_url, category_ids:[])
  end
end
