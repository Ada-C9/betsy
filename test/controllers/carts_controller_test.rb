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
      cart = Cart.first
      items_in_cart = cart.cartitems.count
      old_item_count = Cartitem.count

      patch empty_cart_path(cart.id)

      (old_item_count - Cartitem.count).must_equal items_in_cart
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
  end
end
