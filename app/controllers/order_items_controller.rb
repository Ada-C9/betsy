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

    @order_item.update(id: params[:id], is_shipped: true)
    redirect_to user_path(@order_item.product.user.id)
  end



  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :is_shipped, :order_id, :product_id)
  end
end
