class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :edit, :update]
  before_action :find_user

  def index
    @orders = Order.where(merchant_id: @user.id).order(id: :desc)
  end

  def show
  end

  def new
    @order = Order.new()
  end

  def create
    @order = Order.new(order_params)
    @order.update(status: "open")
    if @order.save
      redirect_to order_path(@order.id)
    else
      flash.now[:status] = "failure"
      flash.now[:result_text] = "Order could not be created"
      flash.now[:messages] = @order.errors.messages
      render :new
    end
  end

  def update
    # If canceling an order:
    unless @order.status == "open"
      flash.now[:status] = "success"
      flash[:result_text] = "Order #{@order.id} was canceled." if @order.cancel_order
      redirect_to order_path(@order.id)

      # If competing an order by 'checking out':
    else   # _checkout_form comes here
      if @order.update(order_params)
        # @order.update(status: "paid")
        flash.now[:status] = "success"
        flash[:result_text] = "Checkout for order ##{@order.id} was successful."
        redirect_to orders_path
      else
        flash.now[:status] = "failure"
        flash.now[:result_text] = "Cart could not be checked out. Please complete all fields."
        flash.now[:messages] = @order.errors.messages
        render :edit
      end
    end
  end

  def edit
  end

  private

  def order_params
    return params.require(:order).permit(:status, :email, :address, :card_name, :cc_number, :cc_expiration, :cvv, :zip_code)
  end

  def find_order
    @order = Order.find_by(id: params[:id])
    render_404 unless @order
  end
end
