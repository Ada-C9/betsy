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
    not_found_check(@order)
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
    if @order.nil?
      render_404
    else
        @order.update_attributes(order_params)
         if @order.valid?
           @order.save

           redirect_to order_path(@order.id)
            
           flash[:success] = "#{@order.name} has been updated"

         else
           render :show , status: :bad_request
           flash[:error] = "#{@order.name} update has failed"

         end
     end
  end

  def cancel
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      render_404
    else
      @order.update(status: "cancelled")
      redirect_back fallback_location: order_confirmation_path(@order)
    end
  end

  def destroy
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      render_404
    else
      if @order
        @order.order_items.each do |item|
          item.destroy
        end
        @order.destroy
      end
    end
  end

  private
  def order_params
   params.require(:order).permit(:status,:name,:email,:street_address,:city,:state,:zip,:name_cc,:credit_card,:expiry,:ccv,:billing_zip)
  end


end
