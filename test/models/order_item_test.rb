require "test_helper"

describe OrderItem do
  let(:order_item) { OrderItem.new(product_id: products(:cat).id, order_id: orders(:one).id, quantity: 1) }

  it "must be valid" do
    value(order_item).must_be :valid?
  end

  describe "get subtotal" do
    it "returns correct subtotal for quantity" do
      order = orders(:one)
      product = products(:cat)
      order_item.quantity = 3
      sum = product.price * 3

      order_item.get_subtotal.must_equal sum
    end
  end

  describe "already_exists" do
    it "returns true if product is already in pending order" do
      order = orders(:one)
      second = OrderItem.new(product_id: products(:cat).id, order_id: orders(:one).id, quantity: 2)

      second.already_exists?.must_equal true
    end
  end
end
