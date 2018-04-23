require "test_helper"

describe OrdersController do

  describe "relationship" do

    it "should be invalid with no cart_id" do

      @order = orders(:order_one)

      result = @order.valid?
      result.must_equal true

      @order.cart_id = nil
      result = @order.valid?

      result.must_equal false
    end
  end

  describe "validations" do

    it "shoul be invalid if creadit card is not 16 integers" do
      result =  @order.valid?
      result.must_equal true

      @order.creditcard = 1111111111111111
      result =  @order.valid?
      result.must_equal true

      @order.creditcard = 12345678123456789
      result =  @order.valid?
      result.must_equal false

      result = @order2.valid?
      result.must_equal true

      @order2.creditcard = 12345678123456789
      result = @order2.valid?
      result.must_equal false

      @order2.creditcard =1234
      result = @order2.valid?
      result.must_equal false
    end
  end
end
