class OrderItemsController < ApplicationController

  def index
    @order_items = OrderItem.where(order_id: session[:order_id])
    @order = Order.find_by(id: session[:order_id])
  end

  def new
    @order_item = OrderItem.new(order_id: params[:order_id])
  end

  def create
    # Step 1: Find or create an order
    @order = Order.find_by(id: session[:order_id])

    unless @order
      @order = Order.new()
      unless @order.save
        flash[:status] = :failure
        flash[:result_text] = "Didn't add to the cart"
        flash[:messages] = @order.errors.messages
        redirect_back fallback_location: root_path
        return
      end
      session[:order_id] = @order.id
      puts "created new order number #{@order.id}"
    else
      puts "Found order number #{@order.id}"
    end

    # If we get here we're guaranteed to have an order
    add_products_to_cart(@order)

  end

  def add_products_to_cart(order)
    # Step 0: Get all the required info
    product_id = order_item_params[:product_id]
    quantity = order_item_params[:quantity]

    # Step 1: get an order item
    # either pull an existing one for this product from the cart
    # or, create a new one
    @order_item = order.order_items.find_by(product_id: product_id)
    if @order_item
      @order_item.quantity += quantity.to_i
    else
      @order_item = order.order_items.new(order_item_params)
    end

    # Step 2: save, report the result
    if @order_item.save

      flash[:success] = "Product added successfully"
      redirect_to order_items_path
    else
      flash[:failure] = "Didn't add to the cart"
      redirect_to product_path(@order_item.product_id), status: :bad_request
    end
  end

  def update
    @order_item = OrderItem.find_by(id: params[:id])
    @order_item.assign_attributes(order_item_params)
    @order_item.save
    redirect_to order_items_path

  end


  def show
  end

  def destroy
    @order_item = OrderItem.find_by(id: params[:id])
    @order_item.destroy
    flash[:status] = :success
    flash[:result_text] = "Successfully deleted"
    redirect_to order_items_path
  end

  private
  def order_item_params
    return params.require(:order_item).permit(:quantity, :product_id)
  end

end
