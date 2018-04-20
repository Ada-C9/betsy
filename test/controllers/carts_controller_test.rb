require "test_helper"

describe CartsController do

  describe "show" do
    it "succeeds for an extant cart ID" do
      cart1 = Cart.first
      get cart_path(cart1)
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus cart ID" do
      cart404 = Cart.last.id + 404
      get cart_path(cart404)
      must_respond_with :not_found
    end
  end

  describe "destroy" do
    it "succeeds for an extant cart ID" do
      cart1 = Cart.first
      delete cart_path(cart1)
      must_respond_with :redirect
      must_redirect_to cart_path(cart1)
    end

    it "renders 404 not_found and does not update the DB for a bogus product ID" do
      # problem
      cart404 = Cart.last.id + 404
      delete cart_path(cart404)
      must_respond_with :not_found
    end

  end
end
