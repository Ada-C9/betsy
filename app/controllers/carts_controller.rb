class CartsController < ApplicationController
  before_action :find_order_products
  skip_before_action :require_login
  before_action :previous_order, only: [:confirmation]

  def show; end

  def edit; end

  def confirmation; end

  def update
    @current_order.assign_attributes(cart_params)
    @current_order.get_expiry(params)
    @current_order.status = "in progress"
    if @current_order.save
      @current_order.status = "paid"
      if @current_order.save
        # empty cart by setting session[:order_id] to nil
        session[:order_id] = nil
        session[:prev_order_id] = @current_order.id # here
        redirect_to confirmation_path
      end
    else
      render :edit, status: :bad_request
    end
  end

  private
  def find_order_products
    @order_products = @current_order.order_products
    head :not_found unless @order_products
  end

  def cart_params
    params.require(:order).permit(:name, :email, :cc_num, :cc_cvv, :zip, :address, expiry_date: {})
  end

  def previous_order
    @previous_order ||= Order.find_by(id: session[:prev_order_id])
  end

end
