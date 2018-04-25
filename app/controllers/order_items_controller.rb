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

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :is_shipped, :order_id, :product_id)
  end
end
