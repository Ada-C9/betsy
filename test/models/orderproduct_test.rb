require "test_helper"

describe Orderproduct do
  let(:orderproduct) { Orderproduct.new quantity: 2, product_id: Product.first.id, order_id: Order.first.id }

  describe "validations" do
    it "must be valid" do
      orderproduct.must_be :valid?
    end

    it "must have a quantity" do
      orderproduct.quantity = nil

      orderproduct.valid?.must_equal false
      orderproduct.errors.must_include :quantity
    end
  end

  describe "relations" do
    it "must belong to product" do
      orderproduct.must_respond_to :product
    end

    it "must belong to order" do
      orderproduct.must_respond_to :order
    end
  end

  describe "create orderproduct" do
    it "must return a new orderproduct" do
      newop = Orderproduct.create_orderproduct(products(:candy).quantity, products(:candy).id, orders(:open).id)

      newop.must_be :valid?
    end
  end

  describe "sub_total" do
    # subtotal is called in product model but uses an orderproduct
  end
end
