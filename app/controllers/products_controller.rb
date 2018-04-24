class ProductsController < ApplicationController

  # before_action :find_user

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
    @product.user = User.find(params[:user_id])
#     if params[:user_id]
#       #want this to be a session id - to connect with a cart possibly?
# end
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
    @review = Review.new
    @action = product_reviews_path(params[:id])
  end

  def edit
    @product = Product.find_by(id: params[:id])
    @action = product_path(params[:id])
  end

  def update
    @product = Product.find_by(id: params[:id])
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

  def add_to_cart
    if session[:cart_order_id].nil? #If there is no cart yet
      @order = Order.create status: "pending"
      session[:cart_order_id] = @order.id
      if @order.save
        flash[:status] = :success
        flash[:result_text] = "Welcome to the Puppsy shopping experience!"
      else
        flash[:status] = :failure
        raise
        flash[:result_text] = "We weren't able to create your shopping cart."
        flash[:mssages] = @order.errors.messages
        #some redirect, status: :bad_request
      end
    elsif @order = Order.find(session[:cart_order_id])
      flash[:status] = :success
    else
      flash[:status] = :failure
      flash[:result_text] = "We couldn't find your shopping cart."
      flash[:mssages] = @order.errors.messages
      #some redirect, status: :bad_request
    end
    if @product = Product.find(params[:id])
      flash[:status] = :success
      flash[:result_text] = "#{@product.name} has been successfully added to your cart!"
    else
      flash[:status] = :failure
      flash[:result_text] = "You have chosen an unrecognized product."
      flash[:messages] = @product.errors.messages
      render :index, status: :bad_request
    end
    duplicate = false
    @order.order_items.each do |order_item|
      if order_item.product.id == @product.id
        order_item.quantity += 1
        order_item.sav
        duplicate = true
        flash[:status] = :success
        flash[:result_text] = "#{@product.name} has been successfully added to your cart!"
      end
    end
    unless duplicate == true
      @order_item = OrderItem.create product_id: @product.id, order_id: @order.id, quantity: 1, is_shipped: "false"
      if !@order_item.save
        flash[:status] = :failure
        flash[:result_text] = "Could not add this product to your cart."
        flash[:messages] = @product.errors.messages
      else
        flash[:status] = :success
        flash[:result_text] = "#{@product.name} has been successfully added to your cart!"
      end
    end
    redirect_to cart_path
  end

  def set_status
    @product = Product.find_by(id: params[:id])
    @product.toggle_is_active
    @product.save
    redirect_back fallback_location: user_path(@product.user)
  end

  private

  def product_params
    params.require(:product).permit(:name, :is_active, :description, :price, :photo_url, :stock, :user_id, :term, :category_ids => [] )
  end
end
