class OrderProductsController < ApplicationController
  skip_before_action :require_login
  before_action :find_order_product, only: [:show, :update, :destroy]

  def create
    @order = current_order
    product = Product.find_by(id: params[:order_product][:product_id])

    # Maybe: make an instance method on Order to do this work and return the item
    @item = @order.order_products.find_by(product: product)
    if @item
      @item.quantity += (params[:order_product][:quantity]).to_i
    else
      @item = @order.order_products.new(item_params)
    end

    if @item.quantity > product.available
      flash[:error] = "Only #{product.available} currently available."
      redirect_to products_path
      return
    end

    if @item.save
      @current_order.total = @current_order.order_total
      @current_order.save
      name = Product.find_by(id: @item.product_id).name.titleize
      session[:order_id] = @order.id
      flash[:success] = "You added #{@item.quantity} #{@item.quantity > 1 ? name.pluralize : name}!"
      redirect_to products_path
    else
      # FLASH MESSAGE
      @order.errors.messages
    end
  end

  def update
    # FLASH MESSAGE
    @item.assign_attributes({quantity: item_params[:quantity]})
    @item.save
    redirect_to cart_path
  end

  def destroy
    @item.destroy
    if @order.save
      flash[:success] = "#{Product.find_by(id: @item.product_id).name.titleize} has been deleted from your cart."
    else
      flash[:failure] = "Something went wrong, but don't sweat it! Here's your cart."
    end
    redirect_to cart_path
  end


  private
  def item_params
    params.require(:order_product).permit(:quantity, :product_id)
  end

  def find_order_product
    @order = current_order
    @item = @order.order_products.find(params[:id])
  end

end
