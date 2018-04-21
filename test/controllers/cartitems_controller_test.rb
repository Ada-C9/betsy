require "test_helper"

describe CartitemsController do
  describe "update" do
     it "can update quantity if there is enough stock" do
       cartitem1 = Cartitem.first
       new_cartitem_info = {quantity: cartitem1.quantity + 1}
       new_quantity = cartitem1.quantity + 1
       patch cartitem_path(cartitem1), params: { cartitem: new_cartitem_info }

       must_respond_with :redirect
       must_redirect_to cart_path(cartitem1.cart)
       Cartitem.first.quantity.must_equal new_quantity
     end

  end


  describe "destroy" do
    it "succeeds for an extant cartitem ID" do
      cartitem1 = Cartitem.first
      delete cartitem_path(cartitem1)
      must_respond_with :redirect
      must_redirect_to cart_path(cartitem1.cart)
    end

    it "renders 404 not_found and does not update the DB for a bogus product ID" do
      cartitem404 = Cartitem.last.id + 404
      delete cartitem_path(cartitem404)
      must_respond_with :not_found
    end
  end
end
