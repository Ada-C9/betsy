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

  private
  def find_cart
    @cart = Cart.find_by(id: params[:id])
    head :not_found unless @cart
  end
end
