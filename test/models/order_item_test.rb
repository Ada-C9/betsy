require "test_helper"

describe OrderItem do
  let(:order_item) { OrderItem.new }
  let(:oi) { order_items(:order_item_1) }


  describe "relations" do
    it "has an order" do
      oi.must_respond_to :order
      oi.order.must_be_kind_of Order
      oi.order.must_equal orders(:order_1)
    end
    it "has a product" do
      oi.must_respond_to :product
      oi.product.must_be_kind_of Product
      oi.product.must_equal products(:product_1)
    end

    it "changes in order_id and product_id reflects in order and product" do
      oi.order_id = orders(:order_2).id
      oi.order.must_equal orders(:order_2)

      oi.product_id = products(:product_2).id
      oi.product.must_equal products(:product_2)
    end
  end

  describe "validations" do

    it "has validation for empty parameters" do
      order_item.valid?.must_equal false
    end

    it "has validation for quantity presence" do
      oi.quantity = nil
      oi.valid?.must_equal false
      oi.errors.messages.must_include :quantity

      oi.quantity = ""
      oi.valid?.must_equal false
      oi.errors.messages.must_include :quantity
    end

    it "has quantity as integer, greater than 0" do
      ["one", -1, 0].each {|element|
        order_item.quantity = element
        order_item.valid?.must_equal false
      }
    end

    it "checks product is active" do
      oi.product.is_active = false
      oi.valid?.must_equal false
      oi.errors.messages.must_include :is_active
    end

    it "checks quantity is available" do
      oi.product.stock = 0
      oi.valid?.must_equal false
      oi.errors.messages.must_include :stock

      order_items(:order_item_6).product.stock = 2
      order_items(:order_item_6).valid?.must_equal false
      order_items(:order_item_6).errors.messages.must_include :stock
    end

    it "checks subtotal" do
      oi.product.price = 299
      oi.subtotal.must_equal 2.99
      oi.product.price = 29
      oi.subtotal.must_equal 0.29
    end

    it "must be valid" do
      oi.valid?.must_equal true
    end
  end
end
