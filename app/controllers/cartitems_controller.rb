class CartitemsController < ApplicationController
  def change_quantity

  end

  def destroy
    @cartitem.destroy
    flash[:status] = :success
    flash[:result_text] = "Successfully removed item #{@cartitem.product.name}"
    redirect_to
  end
end
