class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :edit, :update]
  before_action :current_user

  def index

    if session[:user_id]
      @user = User.find(session[:user_id])
      if params[:user_id]
        @orders = Order.all.where(id: params[:order_id])
      else
        @orders = Order.all
      end


    else
      @orders = Order.all

    end
  end



  def new
    @order = Order.new
    # session[:order_id] = @order.id
  end


  def show

  end

  def update
    @order = Order.find_by(id: params[:id])
    @order.assign_attributes(order_params)
    # @order.status = "paid"

    if @order.save
      @order.status = "paid"
      @order.reduce_inventory
      session[:order_id] = nil

      # if @order.save
      flash[:success] = 'Your order has been placed'
      redirect_to order_path
      # end
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Please enter the Order details again"
      flash.now[:messages] = @order.errors.messages
      render :edit, status: :found
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
    return params.require(:order).permit(:status, :email, :mail_adr, :cc_name, :cc_num, :cc_exp, :cc_cvv, :bill_zip)
  end

  def find_order
    @order = Order.find_by(id: params[:id])
    render_404 unless @order
  end


end
