require "test_helper"

describe OrderItem do
  let(:order_item) { OrderItem.new(order: orders(:order1), product: products(:product1), quantity: 7) }

  describe "relations" do
    it "has an associated product" do
      orderitem = order_items(:orderitem1)
      orderitem.product.must_equal products(:product1)
      orderitem.product_id = products(:product2).id
      orderitem.product.must_equal products(:product2)
    end

    it "has associated order" do
      orderitem = order_items(:orderitem1)
      orderitem.order.must_equal orders(:order1)
      orderitem.order_id = orders(:order2).id
      orderitem.order.must_equal orders(:order2)
    end
  end

  describe "validations" do

    it "must have a positive integer quantity" do
      [-3, 0].each do |num|
        order_item.quantity = num
        order_item.valid?.must_equal false
      end
      (1..5).each do |num|
        order_item.quantity = num
        order_item.valid?.must_equal true
      end
    end
    it "must be in stock" do
      order_item.quantity = 100
      order_item.valid?.must_equal false
    end
    it "can't make an order product from out of stock product" do
      product = products(:product1)
      product.stock = 0
      product.save
      orderitem = OrderItem.new(order: orders(:order1), product: products(:product1), quantity: 7)
      orderitem.valid?.must_equal false
    end
  end

  describe "custom methods" do
    it "returns the subtotal of an orderitem" do
    orderitem = OrderItem.new(order: orders(:order1), product: products(:product1), quantity: 7)
    result_sub_total = 14700
    orderitem.sub_total.must_equal result_sub_total
    end
  end


end
