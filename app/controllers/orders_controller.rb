class OrdersController < ApplicationController
  before_action :find_order, except: [:index, :new, :create]
  before_action :find_cart, only: [:update]

  def new
    @order = Order.new
    @cart = Cart.find(session[:cart_id])
  end

  def create
    @order = Order.new(order_params)
    @order.cart_id = session[:cart_id]

    if @order.save

      flash[:status] = :success

      redirect_to edit_order_path(@order)
    else

      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not place your order"
      flash.now[:messages] = @order.errors.messages

      render :new, status: :bad_request
    end
  end

  def show
    @order = Order.find_by(id: params[:id])
    @cart = Cart.find_by(id: @order.cart_id)
  end

  def update
    @order.update_attributes(order_params)

    if @order.save

      @cart.cartitems.each do |cartitem|
        product = Product.find(cartitem.product_id)
        product.stock = product.new_stock(cartitem.quantity)
        product.visible = false if product.stock == 0
        unless product.save
          flash.now[:status] = :failure
          flash.now[:result_text] = "Our #{product.name} is out of stock, please update your cart!"
          redirect_to cart_path(@cart)
        end
      end

      flash[:status] = :success
      flash[:result_text] = "Your order has been placed !"
      flash[:order_number] = "Order number: #{@order.id}"
      session[:cart_id] = nil
      redirect_to order_path(@order)
    else

      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not place your order"
      flash.now[:messages] = @order.errors.messages

      render :edit, status: :bad_request
    end

  end

  private
  def order_params
    params.require(:order).permit(:name, :email, :creditcard, :name_on_card, :expiration_month, :expiration_year, :cvv, :mail_address, :billing_address, :zipcode, :status)
  end

  def find_order
    @order = Order.find_by(id: params[:id])
    head :not_found unless @order
  end

  def find_cart
    order = Order.find_by(id: params[:id])
    @cart = Cart.find_by(id: order.cart_id)
    head :not_found unless @cart
  end
end
