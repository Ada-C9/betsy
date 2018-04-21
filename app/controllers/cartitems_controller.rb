class CartitemsController < ApplicationController
  before_action :find_cartitem

  def edit
  end

  def update
    @cartitem.update_attributes(quantity: params[:cartitem][:quantity])
    # business login to find if available in model product
    # binding.pry
    if @cartitem.product.available?(@cartitem.quantity)
      if @cartitem.save
        flash[:status] = :success
        flash[:result_text] = "Successfully updated your #{@cartitem.product.name} quantity"
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not update your #{@cartitem.product.name} quantity"
        flash[:messages] = @cartitem.errors.messages
      end

    else
      flash[:status] = :failure
      flash[:result_text] = "There is not enough #{@cartitem.product.name} in stock"
    end
    redirect_to cart_path(@cartitem.cart_id)
  end

  def destroy
    @cartitem.destroy
    flash[:status] = :success
    flash[:result_text] = "Successfully removed item #{@cartitem.product.name}"
    redirect_to cart_path(@cartitem.cart_id)
  end

  private
  def find_cartitem
    @cartitem = Cartitem.find_by(id: params[:id])
    render_404 unless @cartitem
  end

  # def cartitem_params
  #   params.require(:cartitem).permit(:quantity)
  # end
end
