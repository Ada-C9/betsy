require "test_helper"

describe CartsController do
  before_action :find_cart
  def show
  end

  # Empty the cart
  def delete
    @cart.destroy
    flash[:status] = :success
    flash[:result_text] = "Successfully empty your shopping cart"
    redirect_to cart_path(@cart)
  end

  private
  def find_cart
    @cart = Cart.find_by(id: params[:cart_id])
    render_404 unless @cart
  end
end
