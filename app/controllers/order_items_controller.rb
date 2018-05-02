class OrderItemsController < ApplicationController

  def index
    @order_items = OrderItem.all
  end

  def show
    @order_item = OrderItem.find_by(id: params[:id])
  end

  def new
    @order_item = OrderItem.new
  end

  def create
    @order_item  = OrderItem.new(order_item_params)
    set_order_for_order_item
    if @order_item.save
      flash[:success] = "Successfully added item to cart!"
      redirect_to view_cart_path
    else
      flash[:alert] = @order_item.errors.messages
      redirect_to product_path(order_item_params[:product_id])
    end
  end

  def edit
    @order_item  = OrderItem.find_by(id: params[:id])
  end

  def update
    @order_item  = OrderItem.find_by(id: params[:id])
    @order_item.update(order_item_params)
    redirect_to view_cart_path
  end

  def destroy
    @order_item  = OrderItem.find_by(id: params[:id])
    if @order_item
      @order_item.destroy
      flash[:success] = "Successfully removed item from shopping cart"
      redirect_to view_cart_path
    end
  end

  def mark_shipped
    @order_item  = OrderItem.find_by(id: params[:id])
    @order_item.update(is_shipped: true)
    @order_item.save
    redirect_to order_items_path
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :price, :is_shipped, :product_id, :order_id)
  end

  def set_order_for_order_item
    if session[:cart_id] == nil
      order = Order.create(status: "pending")
      session[:cart_id] = order.id
    else
      order = Order.find_by(id: session[:cart_id])
    end
    order.add_item_to_cart(@order_item)
  end

end
