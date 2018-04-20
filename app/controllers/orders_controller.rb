class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

  end

  def show
      @order = Order.find_by(id: params[:id])
  end

  def edit
    @order = Order.find_by(id: params[:id])
  end

  def update
  @order = Order.find_by(id: params[:id])
      if @order
       @order.status = params[:status]
       @order.name = params[:name]
       @order.email = params[:email]
       @order.street_address = params[:street_address]
       @order.city = params[:city]
       @order.state = params[:state]
       @order.zip = params[:zip]
       @order.name_cc = params[:name_cc]
       @order.credit_card = params[:credit_card]
       @order.expiry = params[:expiry]
       @order.ccv= params[:ccv]
       @order.billing_zip = params[:billing_zip]
     end
  end

  def destroy
    @order = Order.find_by(id: params[:id])
      if @order
        @order.order_item.each do |item|
          item.destroy
        end
        @order.destroy
      end
  end

  private
  def order_params
   params.require(:order).permit(:status,:name,:email,:street_address,:city,:state,:zip,:name_cc,:credit_card,:expiry,:ccv,:billing_zip)
  end

end
