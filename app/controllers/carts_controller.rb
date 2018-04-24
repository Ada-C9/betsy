class CartsController < ApplicationController

  before_action :find_cart, only: [:show]

  # may not need this eventually
  # def create
  #   @cart = Cart.new
  #
  #   if @cart.save
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully created cart"
  #     redirect_to carts_path(@cart)
  #   else
  #     flash[:status] = :failure
  #     flash[:result_text] = "Could not create cart"
  #     flash[:messages] = @cart.errors.messages
  #     redirect_back(fallback_location: root_path)
  #   end
  # end

  def show; end

  private
  def find_cart
    @cart = Cart.find_by(id: params[:id])
    head :not_found unless @cart
  end
end
