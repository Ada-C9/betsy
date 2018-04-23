class OrderItemsController < ApplicationController
  def update
    @order_item = OrderItem.find_by(id: params[:id])

    @order_item.update(id: params[:id], is_shipped: true)
    redirect_to user_path(@order_item.product.user.id)
  end
end
