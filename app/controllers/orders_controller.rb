class OrdersController < ApplicationController
  before_action :find_order

  def index
    @orders = Order.all
  end

  def show
    if Order.exists?(id: params[:id])
      @processed_order = Order.find(params[:id])
      @total = @processed_order.get_total
    else
      find_order
      render :new, status: :not_found
    end
  end

  def update

    @order.update_attributes(update_order_params)

    if @order.save

      flash[:success] = "Thank you for placing your order!"

      @order.order_items.each do |item|
        product = Product.find(item.product_id)
        product.change_stock(item.quantity)
      end

      processed_order_id = @order.id

      make_new_order
      redirect_to order_path(processed_order_id)
    else
      flash.now[:alert] = @order.errors
      render :new, status: :bad_request
    end
  end


  private
    def update_order_params
      params.require(:order).permit(:status, :cc_num, :cvv, :state, :city, :zip, :name_on_card, :street_address, :email, )
    end
end
