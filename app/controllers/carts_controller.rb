class CartsController < ApplicationController

  before_action :find_cart, only: [:show, :empty_cart]

  def show; end

  def empty_cart
    @cart.cartitems.destroy_all

    if @cart.total_items == 0
      flash[:success]
      flash[:result_text] = "Your cart has been emptied"
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not empty your cart"
      flash[:messages] = @cart.errors.messages
    end
    redirect_back(fallback_location: cart_path(@cart))
  end

  def revenue_by_merchant(merch_id)
    my_products = Product.where(merchant_id: merch_id)
    my_cartitems = self.cartitems.where(product_id: my_products)

    total_revenue = 0
    my_cartitems.each do |item|
      revenue = item.product.price * item.quantity
      total_revenue += revenue
    end
    return total_revenue
  end

  private
  def find_cart
    @cart = Cart.find_by(id: params[:id])
    head :not_found unless @cart
  end
end
