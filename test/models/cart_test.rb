require "test_helper"

describe Cart do
  let(:cart) { Cart.new }

  it "must be valid" do
    value(cart).must_be :valid?
  end

  describe "subtotal" do
    it "calculates subtotal for all items in the cart" do
      cart1 = Cart.first
      result = cart1.subtotal
      result.must_equal 17.16
    end
  end
end
