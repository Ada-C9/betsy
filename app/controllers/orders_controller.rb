class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def create
  end

  def new
    if @user
      @order = Order.find(session[:user_open_order_id])
    else
      @order = Order.find(session[:guest_order_id])
    end
  end

  def edit
    # if @user
    #   @order = Order.find(session[:user_open_order_id])
    # else
    #   @order = session[:guest_order]
    # end
  end

  def show
    if @user
      @order = Order.find(session[:user_open_order_id])
    else
      @order = session[:guest_order]
    end
    @processed_order = Order.find(params[:id])
    @total = @processed_order.get_total
  end

  def update
    if @user
      @order = Order.find(session[:user_open_order_id])
    else
      @order = Order.find(session[:guest_order_id])
    end

    @order.update_attributes(update_order_params)

    if @order.save
      flash[:success] = "Thank you for placing your order!"

      @order.order_items.each do |item|
        product = Product.find(item.product_id)
        product.change_stock(item.quantity)
      end

      processed_order_id = @order.id

      make_new_order

      redirect_to order_path(params[:id])
    else
      flash.now[:alert] = @order.errors
      render :new
    end
  end

  def destroy
  end

  private
    def update_order_params
      params.require(:order).permit(:status, :cc_num, :cvv, :state, :city, :zip, :name_on_card, :street_address, :email, )
    end
end
