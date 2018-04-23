class CartitemsController < ApplicationController
  before_action :find_cartitem

  def new
    @cartitem = Cartitem.new
  end

  def create
    if session[:cart_id]
      cart = Cart.find_by(id: session[:cart_id])
      @cartitem = Cartitem.new(cart_id: session[:cart_id])
      if @cartitem.save
        flash[:status] = :success
        flash[:result_text] = "This product has been added to your shopping cart"
        redirect_back
      else
        cart = Cart.new
        if cart.save
          session[:cart_id] = cart.id
          @cartitem = Cartitem.new(cart_id: session[:cart_id])
          if @cartitem.save
            redirect_back fallback_location: products_path
          else
            flash[:failure] = :failure
            flash[:result_text] = "It was not possible to add this product to the cart"
            redirect_back fallback_location: products_path
          end
        else
          flash[:failure] = :failure
          flash[:result_text] = "It was not possible to add this product to the cart"
          redirect_back fallback_location: products_path

        end
      end
    end
  end


  def update
    @cartitem.update_attributes(quantity: params[:cartitem][:quantity])

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

    head :not_found unless @cartitem
  end

end
