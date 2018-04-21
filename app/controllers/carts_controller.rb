class CartsController < ApplicationController
  before_action :find_cart
  def show
    @products = Product.all
  end

  # Empty the cart
  def destroy
    # need delete all cartitems in the cart
    # @cart.cartitems.each do |cartitem|
    #   cartitem.destroy
    # end

    flash[:status] = :success
    flash[:result_text] = "Successfully empty your shopping cart"
    redirect_to cart_path(@cart)
  end

  private
  def find_cart
    @cart = Cart.find_by(id: params[:id])
    head :not_found unless @cart
  end
end
