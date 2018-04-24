class CartController < ApplicationController

#user clicks on button - if DNE ( create cart show 0 objects or show all objects)

  def access_cart

    @cart = Order.find_by(id: session[:cart_order_id])
    if @cart.nil?
      @cart = create_cart
      session[:cart_order_id] = @cart.id
    end

    @action = order_path(@cart.id)

    render "orders/cart"

  end

  def add_to_cart
    if session[:cart_order_id].nil?
      @cart = create_cart
      session[:cart_order_id] = @cart.id
    else
      @cart = Order.find_by(id: session[:cart_order_id])
    end
    @product = Product.find(params[:id])
    desired_quantity = total_quantity_requested
    if desired_quantity > @product.stock
      flash[:status] = :failure
      flash[:result_text] = "Not enough inventory on-hand to complete your request."
    else
      if @target_item = @cart.order_items.find_by(product_id: params[:id])
        @target_item.quantity = desired_quantity
        @target_item.save
      else
        @order_item = OrderItem.create product_id: @product.id, order_id: @cart.id, quantity: desired_quantity, is_shipped: "false"
      end
    end
    desired_quantity = 1
    redirect_to cart_path
  end

  def update_to_paid
    @cart = Order.find_by(id: session[:cart_order_id])
    @cart.status = "paid"
    if !@cart.save
      flash[:status] = :failure
      flash[:result_text] = "We weren't able to process your order. Please double-check the form."
      flash[:mssages] = @cart.errors.messages
      redirect_to cart_path
    else
      flash[:status] = :success
      flash[:result_text] = "Your order has been submitted!"
      @order = Order.find_by(id: session[:cart_order_id])
      session[:cart_order_id] = nil
      render "orders/confirmation"
    end
  end

  def destroy
    @cart = Order.find_by(id: session[:cart_order_id])
    @cart.order_items.each do |order_item|
      order_item.destroy
    end
    render :empty_cart
  end

  def remove_single_item
    @order_item = OrderItem.find_by(id: params[:id])
    @order_item.destroy
    redirect_to cart_path
  end

  private

  def create_cart
    @cart = Order.new status: "pending"
    session[:cart_order_id] = @cart.id
    if @cart.save
      flash[:status] = :success
      flash[:result_text] = "Welcome to the Puppsy shopping experience!"
    else
      flash[:status] = :failure
      flash[:result_text] = "We weren't able to create your shopping cart."
      flash[:mssages] = @cart.errors.messages
      #some redirect, status: :bad_request
    end
    return @cart
  end

  def total_quantity_requested
    @product = Product.find(params[:id])
    total_quantity = 1
    @cart.order_items.each do |order_item|
      if order_item.product_id == @product.id
        total_quantity += order_item.quantity
      end
    end
    return total_quantity
  end
end

#
# def add_to_cart
#   if session[:cart_order_id].nil? #If there is no cart yet
#     @order = Order.create status: "pending"
#     session[:cart_order_id] = @order.id
#     if @order.save
#       flash[:status] = :success
#       flash[:result_text] = "Welcome to the Puppsy shopping experience!"
#     else
#       flash[:status] = :failure
#       raise
#       flash[:result_text] = "We weren't able to create your shopping cart."
#       flash[:mssages] = @order.errors.messages
#       #some redirect, status: :bad_request
#     end
#   elsif @order = Order.find(session[:cart_order_id])
#     flash[:status] = :success
#   else
#     flash[:status] = :failure
#     flash[:result_text] = "We couldn't find your shopping cart."
#     flash[:mssages] = @order.errors.messages
#     #some redirect, status: :bad_request
#   end
#   if @product = Product.find(params[:id])
#     flash[:status] = :success
#     flash[:result_text] = "#{@product.name} has been successfully added to your cart!"
#   else
#     flash[:status] = :failure
#     flash[:result_text] = "You have chosen an unrecognized product."
#     flash[:messages] = @product.errors.messages
#     render :index, status: :bad_request
#   end
#   duplicate = false
#   @order.order_items.each do |order_item|
#     if order_item.product.id == @product.id
#       order_item.quantity += 1
#       order_item.sav
#       duplicate = true
#       flash[:status] = :success
#       flash[:result_text] = "#{@product.name} has been successfully added to your cart!"
#     end
#   end
#   unless duplicate == true
#     @order_item = OrderItem.create product_id: @product.id, order_id: @order.id, quantity: 1, is_shipped: "false"
#     if !@order_item.save
#       flash[:status] = :failure
#       flash[:result_text] = "Could not add this product to your cart."
#       flash[:messages] = @product.errors.messages
#     else
#       flash[:status] = :success
#       flash[:result_text] = "#{@product.name} has been successfully added to your cart!"
#     end
#   end
#   redirect_to cart_path
# end


# def new
#   if session[:cart_order_id].nil? #If there is no cart yet
#       @order = Order.create status: "pending"
#       session[:cart_order_id] = @order.id
#       if @order.save
#         flash[:status] = :success
#         flash[:result_text] = "Welcome to the Puppsy shopping experience!"
#       else
#         flash[:status] = :failure
#         raise
#         flash[:result_text] = "We weren't able to create your shopping cart."
#         flash[:mssages] = @order.errors.messages
#         #some redirect, status: :bad_request
#       end
#   end
#   redirect_to cart_path
# end
