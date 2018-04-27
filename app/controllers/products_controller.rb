class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]


  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @products = @user.products
      # finds the products for specific user
    else
      @products = Product.all
    end
  end

  def new
    if !current_user
      @product = Product.new(user_id: params[:user_id])
    else
      flash[:result_text] = "You need to be logged in to add a product"
      redirect_to products_path
    end
  end

  def create
    if !current_user
      @product = Product.new(product_params)

      if @product.save
        flash[:success] = "Product added successfully"
        redirect_to products_path
      else
        flash.now[:failure] = "Validations Failed"
        render :new, status: :bad_request
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "You are not allowed to create a product"
      redirect_to products_path
    end

  end

  def show
    @product = Product.find_by(id: params[:id])
    @review = Review.new(product: @product)
    @order_item = OrderItem.new(product: @product, quantity: 1)
  end

  def edit
    if current_user
      if @user.id != @product.user.id
        flash[:status] = :failure
        flash[:result_text] = "This isn't your product!"
        redirect_to product_path(@product.id)
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "You need to log in to edit!"
      redirect_to product_path(@product.id)
    end


  end

  def update
    if find_user && (@user.id != @product.user.id)
      flash[:status] = :failure
      flash[:result_text] = "Oops..This isn't your product!"
      redirect_to product_path(@product.id)
    else
      if @product.save
        flash[:status] = :success
        flash[:result_text] = "Successfully updated #{@product.name}!"
        redirect_to product_path
      else
        flash.now[:status] = :error
        flash.now[:result_text] = "#{@product.name} could not be updated"
        render :edit, status: :bad_request
      end
    end
  end

  def destroy
    @product.destroy
    redirect_to root_path

  end

  def reviews
    @reviews = Review.all
    # call method that takes average on all reviews
  end


  private

  def product_params
    params.require(:product).permit(:name, :stock, :price, :description, :pet_type, :photo_url, :user_id, category_ids: [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end
end
