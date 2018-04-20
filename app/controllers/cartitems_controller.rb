class CartitemsController < ApplicationController
  def change_quantity(quantity)

  end

  def destroy
    cartitem = Cartitem.find_by(id: params[:id])
    render_404 unless cartitem
    cartitem.destroy
    flash[:status] = :success
    flash[:result_text] = "Successfully removed item #{cartitem.product.name}"
    redirect_to cart_path(cartitem.cart_id)
  end
end
