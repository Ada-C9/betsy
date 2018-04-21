require "test_helper"

describe Cartitem do
  let(:cartitem) { Cartitem.new }

  it "must be valid" do
    value(cartitem).must_be :valid?
  end

  describe "subtotal" do
    it "calculates the subtotal for cartitem" do
      cartitem1 = Cartitem.first
      result = cartitem1.subtotal
      result.must_equal 14.48
    end
  end
end
