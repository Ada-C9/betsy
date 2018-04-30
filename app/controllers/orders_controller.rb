class OrdersController < ApplicationController
  before_action :require_login, only: [:show, :index]
  before_action :find_order, only: [:show, :ship_order]

  def index
    @merchant = Merchant.find(session[:merchant_id])

    orders = []
    OrderProduct.all.each do |order_product|
      product = Product.find(order_product.product_id)
      if product.merchant_id == @merchant.id
        orders << order_product
      end
    end
    @orders = orders

    products = []
    orders.each do |order|
      product = Product.find(order.product_id)
      products << product
    end
    @products = products

    unshipped_orders = []
    @orders.each do |order_product|
      if order_product.order.status == 'paid'
        unshipped_orders << order_product.product.price
      end
    end

    shipped_orders = []
    @orders.each do |order_product|
      if order_product.order.status == 'shipped'
        shipped_orders << order_product.product.price
      end
    end

    @unshipped_orders = unshipped_orders.sum
    @shipped_orders = shipped_orders.sum

    @total = @unshipped_orders + @shipped_orders
  end

  def ship_order
    @order.ship_order
  end

  def show; end

  def create
    @order = Order.new(order_params)
    @order.status = 'pending'
    if @order.save
      redirect_to order_path(@order.id)
    else
      render :new, status: :bad_request
    end
  end

  private

  # does this need to be edited since we have a cart params??
  def order_params
    params.require(:order).permit(:status, :name, :email, :address, :cc_num, :expiry_date, :cc_cvv, :zip)
  end

  def find_order
    @order = Order.find_by_id(params[:id])
    head :not_found unless @order
  end

end
