class OrderproductsController < ApplicationController
  before_action :find_orderproduct, only: [:edit, :update, :destroy]
  before_action :find_user

  def index
    @orderproducts = Orderproduct.all
  end

  def show
  end

  def new
    @orderproduct = Orderproduct.new
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    @orderproduct = OrderProduct.new(orderproduct_params)
    @orderproduct.product_id = @product.id
    if @orderproduct.save
      status = :success
      flash[:result_text] = "#{@orderproduct.quantity} #{@orderproduct.product.name} have been added to your order!"
      redirect_to products_path
    else
      status = :bad_request
      flash[:result_text] = "Error - products not added to your order"
      render :new, status: status
    end
  end

  def edit
  end

  def update
    if @orderproduct.update(orderproduct_params)
      flash[:status] = :success
      flash[:result_text] = "Cart updated"
      redirect_to orders_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Cart could not be updated"
      flash.now[:messages] = @orderproduct.errors.messages
      render :edit
    end
  end

  def destroy
    order = @orderproduct.order
    @orderproduct.destroy
    if order.orderproducts.empty?
      order.destroy
    end
    flash[:status] = :success
    flash[:result_text] = "Successfully removed from your cart!"
    redirect_to orders_path
  end

  private

  def orderproduct_params
    params.require(:order_product).permit(:quantity,:product_id)
  end

  def find_orderproduct
    @orderproduct = Orderproduct.find_by(id: params[:id])
    render_404 unless @orderproduct
  end
end
