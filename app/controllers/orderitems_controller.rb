class OrderitemsController < ApplicationController
  before_action :find_order_item, only: [:update, :destroy, :ship]
  before_action :order_exists?, only: [:create]


  def create
    @orderitem = OrderItem.new(order_item_params)
    @orderitem.order = @order
    @orderitem.assign_attributes(status: "pending")


    if @orderitem.save
      flash[:success] = "Item added successfully!"
      redirect_to product_path(@orderitem.product_id)
      # redirect_back(fallback_location: root_path)
    else
      raise
      flash.now[:failure] = "Oops! Something went wrong and we couldn't add this item."
      render "products/show", status: :bad_request
    end
  end

  def update
    @orderitem.assign_attributes(order_item_params)

    if @orderitem.save
      flash[:success] = "Item added successfully!"
      redirect_to viewcart_path
    else
      flash.now[:failure] = "Oops! Something went wrong and we couldn't add this item."
      render ":id/viewcart", status: :bad_request
    end
  end

  def destroy
    @orderitem.destroy

    redirect_to "order/show"
  end

  def ship
    @orderitem.assign_attributes(status: "shipped")
    if @orderitem.save
      flash[:success] = "You have shipped #{@orderitem.product.name} for order #{@orderitem.order.id}."
    else
      flash[:failure] = "Could not ship item."
    end
    redirect_to orders_path
  end

  private

  def order_item_params
    params.require(:order_item).permit(:order_id, :product_id, :quantity)
  end

  def find_order_item
    @orderitem = OrderItem.find_by(id: params[:id])
    head :not_found unless @orderitem
  end

  def order_exists?
    unless session[:cart_id]
      @order = Order.create
      session[:cart_id] = @order.id
    end
  end

end
