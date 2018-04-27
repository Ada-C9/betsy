class CartsController < ApplicationController
before_action :reload_order, only: [:show]
skip_before_action :require_login

  def show
    @order
    @products = @order.products
    @orderitems = @order.orderitems
  end

  def edit; end

  def update
    orderitem = @order.orderitems.find_by(product_id: params[:product_id])

    orderitem.quantity = params[:quantity]

    if orderitem.save
      flash[:status] = :success
      if orderitem.quantity == 0
        orderitem.destroy
        flash[:result_text] = "Removed #{@product.name}"
      else
        flash[:result_text] = "Successfully changed #{@product.name} quantity to #{params[:quantity]}."
      end
    else
      flash.now[:status] = :failure
      flash.now[:messages] = orderitem.errors.messages
      render :show
    end
    redirect_to cart_path(@order)
  end

  def add_to_cart
    flash[:status] = :failure
    quantity = params[:quantity].to_i
    if @product.sufficient_stock(quantity)
      orderitem = Orderitem.new(product: @product, order_id: @order.id, quantity: quantity)
      orderitem = @order.find_existing(orderitem)

      puts "OrderItem ID after find_existing: #{orderitem.id}"

      if orderitem.save
        flash[:status] = :success
        flash[:result_text] = "Successfully added #{quantity} #{@product.name} to cart"
      else
        flash[:messages] = orderitem.errors.messages
      end
    else
      flash[:result_text] = "Could not add item to cart"
      flash[:messages] = @product.errors.messages
    end
    redirect_back fallback_location: product_path(@product)
  end

  def checkout

    @paymentinfo = Buyerdetail.new
  end

  def finalize
    puts "Order attributes before Buyerdetail: #{@order.attributes}"
    @paymentinfo = Buyerdetail.new(payment_params)
    @paymentinfo.assign_attributes(order_id: @order.id)
    puts "Buyerdetail order_id: #{@paymentinfo.order_id}"
    if @paymentinfo.save
      @order.status = :paid
      @order.assign_attributes(buyerdetail_id: @paymentinfo.id)

      puts "Order attributes before save #{@order.attributes}"
      if @order.save

        puts "Order attributes after save #{@order.attributes}"
        @order.products.each do |product|
          quantity = Orderitem.find_by(order_id: @order.id, product_id: product.id).quantity
          product.decrement_stock(quantity)
        end
        flash[:status] = :success
        flash[:result_text] = "Successfully completed Order # #{@order.id}"

        redirect_to order_path(@order)
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Could not complete order."
        flash.now[:messages] = @paymentinfo.errors.messages && @order.errors.messages
        render :checkout, status: :bad_request
      end
    end
  end

  def order_details
    @order = Order.find(params[:id])
    @products = @order.products
    @orderitems = Orderitem.where(order_id: @order.id)
    @customer = Buyerdetail.find_by(id: @order.buyerdetail_id)
  end

  private
  def payment_params
    params.require(:buyerdetail).permit(:email, :mailing_address, :buyer_name, :card_number, :expiration, :cvv, :zipcode)
  end

  def reload_order
    @order.reload
  end
end
