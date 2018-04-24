class CartitemsController < ApplicationController
  before_action :find_cartitem, only: [:show, :update, :destroy]
  before_action :cartitem_params, only: [:update, :create]

  def new
    @cartitem = Cartitem.new
  end

  def create

    @cart = Cart.find_by(id: session[:cart_id])
    if @cart
      @cartitem = Cartitem.new(cartitem_params)
      @cartitem.cart_id = session[:cart_id]
      if @cartitem.save
        flash[:status] = :success
        flash[:result_text] = "Your item has been added to your shopping cart"
        return redirect_to products_path
      else
        if @cart.cartitems.find_by(product_id: @cartitem.product_id)
          flash[:messages] = @cartitem.errors.messages
          return redirect_to cart_path(@cart)
        end
        flash[:result_text] = "It was not possible to add this product to the cart"
        flash[:messages] = @cartitem.errors.messages
      end
    else
      @cart = Cart.new
      if @cart.save
        session[:cart_id] = @cart.id
        @cartitem = Cartitem.new(cartitem_params)
        @cartitem.cart_id = session[:cart_id]
        if @cartitem.save
          flash[:status] = :success
          flash[:result_text] = "This product has been added to your shopping cart"
          return redirect_to products_path
        else
          flash[:result_text] = "It was not possible to add this product to the cart"
        end
      end
    end
    flash[:status] = :failure
    redirect_back(fallback_location: products_path)
  end


  def update
    @cartitem.update_attributes(cartitem_params)
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
    flash[:result_text] = "Successfully removed item #{@cartitem.product.name} from cart"
    redirect_to cart_path(@cartitem.cart_id)
  end

  private
  def find_cartitem
    @cartitem = Cartitem.find_by(id: params[:id])
    head :not_found unless @cartitem
  end

  def cartitem_params
    params.require(:cartitem).permit(:quantity, :product_id)
  end

end
