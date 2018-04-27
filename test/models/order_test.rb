require "test_helper"
require 'pry'

describe Order do
  let(:order) { Order.new }

  it "must be valid" do
    value(order).must_be :valid?
  end

  describe "get total" do
    it "returns order total" do
      order = orders(:one)
      product1 = products(:cat)
      product2 = products(:dog)
      item1 = OrderItem.create(product_id: product1.id, order_id: order.id, quantity: 1)
      item2 = OrderItem.create(product_id: product2.id, order_id: order.id, quantity: 1)

      sum = product1.price + product2.price

      order.get_total.must_equal sum
    end
  end
end
