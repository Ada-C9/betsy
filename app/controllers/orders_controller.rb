class OrdersController < ApplicationController

  before_action :find_order, only: [:show, :edit, :update, :destroy]

  before_action :require_login, except: [:show, :edit, :update, :destroy]

  def index
    @cartitems = Order.filter_by(session[:user_id])
  end

  def show; end

  def edit; end

  def update
    @order.assign_attributes(order_params)

    if @order.save(context: :purchase) && @order.complete_checkout
      flash.now[:success] = "Your Order is on it's way!"
      session[:order_id] = nil
      render :show
    else
      flash.now[:failure] = "Sorry, could not process your order"
      render :edit, status: :bad_request
    end
  end

  def destroy
    if @order.cancel
      flash.now[:success] = "Your Order has been cancelled!"
      render :show
    else
      flash.now[:success] = "Sorry, could not cancel your order!"
      render :show, status: :bad_request
    end
  end


  private

  def find_order
    @order = Order.find_by(id: session[:order_id])
    if !@order
      @order = Order.find_by(id: params[:id])
    end
    head :not_found unless @order
  end

  def order_params
    return params.require(:order).permit(:name, :email, :address, :state, :zipcode, :ccnumber, :ccexpiration, :cvv)
  end

end
