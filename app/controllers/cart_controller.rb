class CartController < ApplicationController

  # def show
  #   @cart = Order.find(session[:cart_order_id])
  #   render :cart
  # end

  def access_cart
    if Order.find_by(id: session[:cart_order_id]).nil?
      @cart = create_cart
    else
      @cart = Order.find(session[:cart_order_id])
    end
    render "orders/cart"
  end

  def add_to_cart
    if session[:cart_order_id].nil?
      @cart = create_cart
    else
      @cart = Order.find_by(id: session[:cart_order_id])
    end
    @product = Product.find(params[:id])
    if @product.stock > 0
      @order_item = OrderItem.create product_id: @product.id, order_id: @cart.id, quantity: 1, is_shipped: "false"
    else
      flash[:status] = :failure
      flash[:result_text] = "Not enough inventory on-hand to complete your request."
    end
    render "orders/cart"
  end

  def update
  end

  def destroy
    @cart = Order.find_by(id: session[:cart_order_id])
    @cart.order_items.each do |order_item|
      order_item.destroy
    end
    session[:cart_order_id] = nil
    @cart.destroy
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
      raise
      flash[:result_text] = "We weren't able to create your shopping cart."
      flash[:mssages] = @cart.errors.messages
      #some redirect, status: :bad_request
    end
    return @cart
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
