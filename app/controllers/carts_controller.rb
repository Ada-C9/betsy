class CartsController < ApplicationController
  before_action :find_cart

  def show
  end



  private
  def find_cart
    @cart = Cart.find_by(id: params[:id])
    head :not_found unless @cart
  end
end
