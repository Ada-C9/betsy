class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      flash[:success] = "Your order has been made - congratulations!"
      redirect_to order_confirmation_path(@order.id)
    else
      flash[:error] = "Something has gone wrong in your orders processing."
      render :new, status: :bad_request
    end
  end

  def confirmation
    @order = Order.find_by(id: params[:id])
  end

  def show
    @order = Order.find_by(id: params[:id])
    not_found_check(@order)
  end

  def edit
    @order = Order.find_by(id: params[:id])
    not_found_check(@order)
  end

  def update
  @order = Order.find_by(id: params[:id])
  not_found_check(@order)
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
       if @order.save
         redirect_to order_path(@order.id)
         flash[:success] = "#{@order.name} has been updated"
       else
         render :new
         flash[:error] = "#{@order.name} update has failed"
       end
     end
  end

  def cancel
    @order = Order.find_by(id: params[:id])
    not_found_check(@order)
    @order.update(status: "cancelled")
    redirect_back fallback_location: order_confirmation_path(@order)

  end

  def destroy
    @order = Order.find_by(id: params[:id])
    not_found_check(@order)
      if @order
        @order.order_items.each do |item|
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
