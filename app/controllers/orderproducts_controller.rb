class OrderproductsController < ApplicationController
  before_action :find_orderproduct, only: [:edit, :update, :destroy]
  before_action :find_user
  before_action :find_order

  def index
    @orderproducts = Orderproduct.where(order_id: @order.first.id) if @order.first
  end

  def show
  end

  def new
    @orderproduct = Orderproduct.new
  end

  def create
    # if user is logged in enter here
    if @user != nil
      if @order.length > 0
        # creates orderproduct
        if params['orderproduct']
          orderproduct = Orderproduct.create_orderproduct(params['orderproduct']['quantity'], params['orderproduct']['product_id'], @order.first.id)
        else
          orderproduct = Orderproduct.create_orderproduct(params['quantity'], params['product_id'], @order.first.id)
        end
      else
        @order = Order.create(merchant_id: @user.id, status: "open")
        # creates orderproduct
        if params['orderproduct']
          orderproduct = Orderproduct.create_orderproduct(params['orderproduct']['quantity'], params['orderproduct']['product_id'], @order.id)
        else
          orderproduct = Orderproduct.create_orderproduct(params['quantity'], params['product_id'], @order.id)
        end
      end

      if orderproduct.save
        flash[:status] = "success"
        flash[:result_text] = "#{orderproduct.quantity} #{orderproduct.product.name} added to your cart!"
        reduce_inventory(orderproduct)
        redirect_to orderproducts_path

      else
        flash[:status] = "failure"
        flash[:result_text] = "Error - products not added to your cart"
        render :new, status: status
      end

      # else user must log in
    else
      flash[:status] = "failure"
      flash[:result_text] = "Must log in to create an order!"
      redirect_to homepage_path
    end
  end

  def edit
  end

  def update
    if @orderproduct.update(orderproduct_params)
      reduce_inventory(@orderproduct)
      flash[:status] = "success"
      flash[:result_text] = "Cart updated!"
      reduce_inventory(@orderproduct)
      redirect_to orderproducts_path
    else
      flash.now[:status] = "failure"
      flash.now[:result_text] = "Cart could not be updated"
      flash.now[:messages] = @orderproduct.errors.messages
      render :edit
    end
  end

  def destroy
    if @orderproduct.destroy
      add_inventory(@orderproduct)
      flash[:status] = "success"
      flash[:result_text] = "Item successfully removed from your cart!"
      redirect_to orderproducts_path
    end
  end

  def clear_cart
    add_inventory(@orderproduct)
    Orderproduct.where(order_id: @order.first.id).delete_all
    redirect_to orderproducts_path
  end

  private

  def orderproduct_params
    params.require(:orderproduct).permit(:quantity, :product_id)
  end

  def find_orderproduct
    @orderproduct = Orderproduct.find_by(id: params[:id])
    render_404 unless @orderproduct
  end

  def reduce_inventory(orderproduct)
    @product = Product.find_by(id: orderproduct.product_id)
    @product.quantity -= orderproduct.quantity
    @product.save
  end

  def add_inventory(orderproduct)
    @order.first.orderproducts.each do |op|
      @product = Product.find_by(id: op.product_id)
      @product.quantity += op.quantity
      @product.save
    end
  end

end
