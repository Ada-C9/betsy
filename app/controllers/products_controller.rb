class ProductsController < ApplicationController

  def new
    if @user
      @product = Product.new
    else
      redirect_to root_path
    end
  end

  def create

    @product = Product.create(product_params)
    @category = Category.new

    if @product.save
      flash[:result_text] = "Successfully created #{@product.name}"
      redirect_to products_path
    else
      flash[:result_text] = "Could not create #{@product.name}"
      render :new, status: :bad_request
    end
  end

  def index
    @categories= Category.all
    @products = Product.sorted
    find_order
    @orders_products = @order.order_items.new
  end

  def show
    @product = Product.find_by(id: params[:id])
    @merchant = User.find_by(id: @product.user_id)

    if @product.nil?
      redirect_to products_path
    end

    if @user
      @order = Order.find(session[:user_open_order_id])
    else
      @order = session[:guest_order]
    end

    @order_item = OrderItem.new(product_id: @product.id)
  end

  def edit
    # @merchant = User.find_by(id: params[:id])
    # if @merchant != @user
    #   flash[:status] = :error
    #   flash[:result_text] = "Need permission to do that!"
    #   redirect_back fallback_location: root_path
    # end
    @product = Product.find_by(id: params[:id])
    # raise
  end

  def update
    @product = Product.find_by(id: params[:id])
    if @product.update(product_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@product.name}"
      redirect_to products_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update #{@product.name}"
      flash.now[:messages] = @product.errors.messages
      render :edit, status: :not_found
    end
  end


  private
  def product_params
    params.require(:product).permit(:name, :stock, :price, :description, :status, :user_id, :image_url, category_ids:[])
  end

end
