class OrdersController < ApplicationController

  def index
    @orders = Order.all
  end

  def show
    # if params[:merchant_id] # extra code, probably redundant
    #   @order = Order.find_by(id: params[:id])
    # else
      @order = Order.find_by(id: params[:id])
    # end
  end

  def new
    @order = Order.new
  end

  def create
    @order  = Order.new(order_params)
    #note: I'm not sure which is more suitable, the above or Order.create(order_params)
    if @order.save
      flash[:success] = "Successfully created order"
      redirect_to view_cart_path
    else
      flash[:alert] = @order.errors
      render :new
    end
  end

  def edit
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      redirect_to products_path
    end
  end

  def checkout_order
    @order = Order.find_by(id: params[:id])
    @order.update(order_params)
    if @order.save
      flash[:success] = "Order placed!"
      session[:cart_id] = nil
      redirect_to order_path(params[:id])
    else
      flash[:alert] = @order.errors
      redirect_back fallback_location: view_cart_path
    end
  end

  def cancel_order
    @order = Order.find_by(id: params[:id])
    @order.update(status: "cancelled")
    @order.save
    redirect_to root_path
  end

  def update
    @order = Order.find_by(id: params[:id])
    @order.update(order_params)
    if @order.save
      flash[:success] = "Successfully updated order"
      redirect_to order_path(params[:id])
    else
      flash[:alert] = @order.errors
      render :edit
    end
  end

  def cart
    if session.has_key?(:cart_id)
      @order = Order.find_by(id: session[:cart_id])
      
    else
      flash[:status] = "Cart is empty"
    end
  end

  def destroy
  end

  private
  def order_params
    return params.require(:order).permit(:email_address, :cc_name, :cc_number, :cc_exp_month, :cc_exp_year, :cc_cvv, :cc_zip, :status, :street , :customer_name ,:city, :state, :mailing_zip )
  end

end
