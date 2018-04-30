require "test_helper"

describe CartsController do

  describe "show" do
    it "succeeds for an extant cart ID" do
      cart_id = Cart.first.id
      get cart_path(cart_id)
      must_respond_with :success
    end

    it "renders not_found for a bogus cart ID" do
      cart_id = Cart.last.id + 1
      get cart_path(cart_id)
      must_respond_with :not_found
    end
  end

  describe "empty_cart" do
    it "succeeds for an extant cart ID" do
      data = {
        product_id: Product.first.id,
        quantity: 3
      }
      post cartitems_path, params: { cartitem: data }

      cart = Cart.find_by(id: session[:cart_id])

      patch empty_cart_path(cart.id)

      cart.total_items.must_equal 0
      must_respond_with :redirect
      must_redirect_to cart_path(cart.id)
    end

    it "renders not_found and does not update the DB for a bogus cart ID" do
      cart_id = Cart.last.id + 1
      old_item_count = Cartitem.count

      patch empty_cart_path(cart_id)

      Cartitem.count.must_equal old_item_count
      must_respond_with :not_found
    end

    it "redirects if there are no items in the cart" do
      cart = Cart.first
      cart.cartitems.destroy_all

      patch empty_cart_path(cart.id)

      must_respond_with :redirect
      must_redirect_to cart_path(cart.id)
    end

    it "does not allow to empty other user's cart" do
      cart = Cart.first
      items_in_cart = cart.cartitems.count
      old_item_count = Cartitem.count

      cart = Cart.last
      patch empty_cart_path(cart.id)

      must_respond_with :redirect
      flash[:status].must_equal :failure
    end
  end
end
