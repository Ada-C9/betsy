class OrderItemsController < ApplicationController


  def new
    @order_item = OrderItem.new
  end

  def create
    @order_item = OrderItem.new(order_item_params)
    @order_item.order = Order.find(params[:order_id])
    @order_item.product = Product.find(params[:product_id])
  end


  def update
    @order_item = OrderItem.find_by(id: params[:id])
    if @order_item
      @order_item.quantity = params[:order_item][:quantity]
      @order_item.save
    end
    redirect_to cart_path
  end

  def destroy
  end 


  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :is_shipped, :order_id, :product_id)
  end
end
