class OrderItemsController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:update]


  def update
    @order_item = OrderItem.find_by(id: params[:id])
    if @order_item.nil?
      render_404 and return
    else
      @order_item.quantity = params[:order_item][:quantity]
      if @order_item.save
        flash[:status] = :success
        flash[:result_text] = "Quantity updated!"
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not add the desired quantity of this item to the cart."
        flash[:messages] = @order_item.errors.messages
      end
    end
    redirect_to cart_path
  end

  def set_status
    @order_item = OrderItem.find_by(id: params[:id])
    @order_item.update(is_shipped: true)

    is_complete = true
    @order_item.order.order_items.each do |order_item|
      if order_item.is_shipped == false
        is_complete = false
      end
    end
    if is_complete
      @order_item.order.update(status: "complete")
    end
    redirect_back fallback_location: user_path(@order_item.product.user)
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :is_shipped, :order_id, :product_id)
  end
end
