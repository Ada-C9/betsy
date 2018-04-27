class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :retire, :destroy]

  def homepage;end

  def index
    @products = Product.where(visible: true).paginate(:page => params[:page], :per_page => 5)
  end


  def new
    if session[:merchant_id]
      @product = Product.new(merchant_id: params[:merchant_id])
    else
      flash[:message] = "You must log in to add a product"
      redirect_back fallback_location: products_path
    end
  end

  def create
    if session[:merchant_id]
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
    else
      flash[:status] = :failure
      flash[:result_text] = "You must be logged in to do that"
      redirect_back fallback_location: products_path
    end
  end

  def show
    @cartitem = Cartitem.new
    @review = Review.new
  end

  def edit
    if session[:merchant_id]
      @product = Product.find(params[:id])
    else
      flash[:status] = :failure
      flash[:result_text] = "You must be logged in to do that"
      redirect_to products_path
      return
    end
  end

  def update
    if session[:merchant_id]
      @product.merchant_id = session[:merchant_id]
      @product.assign_attributes(product_params)
      if @product.save
        redirect_to product_path(@product)
      else
        render :edit, status: :bad_request
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "You must be logged in to do that"
      redirect_to products_path, status: :unauthorized
      return
    end
  end


  def retire
    if session[:merchant_id]
      if @product.visible == true
        @product.update(visible: false)
        flash[:status] = :success
        flash[:result_text] = "Successfully retire #{@product.name}"
      elsif
        @product.visible == false && @product.stock != 0
        @product.update(visible: true)
        flash[:status] = :success
        flash[:result_text] = "Successfully unretire #{@product.name}"
      else
        flash[:status] = :failure
        flash[:result_text] = "#{@product.name} has already retired."
      end
    else
      flash[:status] = :failure
      if @product.visible == true
        flash[:result_text] = "Failed to retire #{@product.name}"
      else
        flash[:result_text] = "Failed to unretire #{@product.name}"
      end
    end
    redirect_back fallback_location: root_path
  end

  def by_name
    product_name = params[:name]
    @products = Product.where(visible: true).where("LOWER(name) like ?", "%#{product_name.downcase}%")

    render :index
  end

  private
  def product_params
    params.require(:product).permit(:name, :price, :merchant_id, :description, :image, :stock, :visible, category_ids: [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end
end
