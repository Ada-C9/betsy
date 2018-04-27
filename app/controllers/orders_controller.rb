class OrdersController < ApplicationController
  # nic used
  # route controller view

  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
    session[:order_id] = @order.id
  end


  def make_cart
    # TODO: adjust quantity to take user input (form?)
    if current_user
      @order = Order.find_by(user_id: current_user.id, status: 'pending')
      OrderItem.new(product_id: params[:product_id], order_id: @order.id, quantity: 1)

      redirect_to order_path(@order.id)
    else
      new_order = Order.create()

      product = OrderItem.new(product_id: params[:product_id], order_id: new_order.id, quantity: 1)

      product.save

      redirect_to order_path(new_order.id)
    end
  end


  def show
    @order = Order.find_by(id: params[:id])
  end

  def update

    @order = Order.find_by(id: params[:id])
    @order.assign_attributes(order_params)

    result = @order.update(order_params)

    if result
      flash[:success] = 'Your order has been placed'
      redirect_to order_path
    else
      flash[:failure] = 'Something went wrong. Please place your order again'
      redirect_to order_path
    end

  end

  def edit
    if params[:id]
      @order = Order.find_by(id: params[:id])
    else
      @order.Order.new
    end
  end

  def destroy
  end

  private
  def order_params
    params.require(:order).permit(:status, :email, :mail_adr, :cc_name,
      :cc_num, :cc_exp, :cc_cvv, :bill_zip)
    end
  end
