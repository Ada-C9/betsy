require "test_helper"

describe CartitemsController do
  describe "destroy" do
    it "succeeds for an extant cartitem ID" do
      cartitem1 = Cartitem.first
      delete cartitem_path(cartitem1)
      must_respond_with :redirect
      must_redirect_to cart_path(cartitem1.cart_id)
    end

    it "renders 404 not_found and does not update the DB for a bogus product ID" do
      # problem 
      cartitem404 = Cartitem.last.id + 404
      delete cartitem_path(cartitem404)
      must_respond_with :not_found
    end
  end
end
