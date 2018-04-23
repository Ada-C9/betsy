class CartController < ApplicationController

  def new
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
    end
    redirect_to cart_path
  end

  def access_cart
    if @order = Order.find(id: session[:cart_order_id])
      @cart = @order
    else
      @cart = Cart.create
    end
  end

  def show
    @cart = Order.find(session[:cart_order_id])
    render :cart
  end

  def create
    @cart = Order.new status: "pending"
    session[:cart_order_id] = @order.id
    if @cart.save
      flash[:status] = :success
      flash[:result_text] = "Welcome to the Puppsy shopping experience!"
    else
      flash[:status] = :failure
      raise
      flash[:result_text] = "We weren't able to create your shopping cart."
      flash[:mssages] = @order.errors.messages
      #some redirect, status: :bad_request
    end
  end

  def add_to_cart_X
    access_cart


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

  def update
  end

  def destroy
  end



end
