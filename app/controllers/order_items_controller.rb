class OrderItemsController < ApplicationController
  def update
    @order_item = OrderItem.find_by(id: params[:id])
    if @order_item.nil?
      render_404
    else
      @order_item.update(id: params[:id], is_shipped: true)
      redirect_to user_path(@order_item.product.user.id)
    end
  end
end
