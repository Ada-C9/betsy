require "test_helper"

describe Order do
  it 'can be created with valid data' do
    old_order_count = Order.count
    order = Order.new(status: :pending)

    order.must_be :valid?

    order = order.save
    result = order.valid?

    result.must_be true
  end

  describe "subtotal" do
    it "calculates the line-item cost of an item" do
      orderitem = orderitems(:oi_one)
      orderitem.quantity.must_equal 6

      price = orderitem.product.price
      total = (price * orderitem.quantity)
      expected_result = 72.86

      order = orderitem.order

      order.must_be :valid?

      result = order.total

      result.must_equal expected_result

    end
  end

end
