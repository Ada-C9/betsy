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
end
