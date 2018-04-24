class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  # TODO: BUILD OUT HOMEPAGE VIEW FOR WHOLE SITE
  def homepage;end

  def index


    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @products = @merchant.products
    else
      @products = Product.where(visible: true).paginate(:page => params[:page], :per_page => 5)
    end

  end
  # TODO: ADD AS MANY CATEGORY FILTERS AS WINI DEVELOPS

  def new
    if params[:merchant_id]
      @product = Product.new(merchant_id: params[:merchant_id])
    else
      flash[:message] = "You must log in to add a product"
    end
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Product added successfully"
      redirect_to product_path(@product)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Failed to add new product"
      flash.now[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  def show
    @cartitem = Cartitem.new
    @review = Review.new
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

  private
  def product_params
    return params.require(:product).permit(:name, :price, :merchant_id, :description, :image, :stock, :visible, category_ids: [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end

end
