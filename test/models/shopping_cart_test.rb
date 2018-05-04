require "test_helper"

describe ShoppingCart do
  let(:shopping_cart) { ShoppingCart.new }

  it "must be valid" do
    value(shopping_cart).must_be :valid?
  end
end
