class CartsController < ApplicationController
  before_action :find_cart
  def new
    @cart = Cart.new
  end

  def update_create_cart
    if session[:cart_id]
      @cart = Cart.find_by(id: session[:cart_id])
    else
      @cart = Cart.new
      session[:cart_id] = @cart.id
    end
  end


  def show
  end



  private
  def find_cart
    @cart = Cart.find_by(id: params[:id])
    head :not_found unless @cart
  end
end
