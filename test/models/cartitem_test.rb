require "test_helper"

describe Cartitem do
  before do
    @order = Order.first
    @product = Product.first
  end
  describe "validations" do
    it "can be created with all valid data" do
      cart_item = Cartitem.new(
        order: @order,
        product: @product,
        quantity: 3
      )

      result = cart_item.valid?

      result.must_equal true

    end

    it "cannot be created with invalid data" do
      cart_item = Cartitem.new(
        order: @order,
        product: @product,
        quantity: 0
      )

      result = cart_item.valid?

      result.must_equal false
    end

    it "cannot be created with insufficient data" do

      # first case: without order
      without_order = Cartitem.new(
        product: @product,
        quantity: 1
      )

      result1 = without_order.valid?

      result1.must_equal false


      # second case: without product
      without_product = Cartitem.new(
        order: @order,
        quantity: 1
      )

      result2 = without_product.valid?

      result2.must_equal false


      # third case: without quanity
      without_quantity = Cartitem.new(
        order: @order,
        product: @product
      )

      result2 = without_quantity.valid?

      result2.must_equal false
    end

    it 'duplicate cartitems cannot be added to product' do
      cart_item = Cartitem.new(
        order: @order,
        product: @product,
        quantity: 3
      )
      cart_item.save

      dup_item = Cartitem.new(
        order: @order,
        product: @product,
        quantity: 2
      )
      result = dup_item.valid?
      result.must_equal false
    end
  end

  describe "relations" do
    it "connects to product and product_id" do
      cart_item = Cartitem.create!(
        order: @order,
        product: @product,
        quantity: 1,
      )

      cart_item.must_respond_to :product
      cart_item.product.id.must_equal @product.id
    end

    it "connects to order and order_id" do
      cart_item = Cartitem.create!(
        order: @order,
        product: @product,
        quantity: 1,
      )

      cart_item.must_respond_to :order
      cart_item.order.id.must_equal @order.id
    end
  end

  describe "#mark_shipped" do
    it "marks an item shipped and order as complete" do
      order = Order.first
      product = Product.first

      cart_item = Cartitem.create!(order: order, product: product, quantity: 3)
      cart_item.must_respond_to :mark_shipped
      cart_item.shipped.must_be_nil

      result = cart_item.mark_shipped
      result.must_equal true

      cart_item.order.state.must_equal 'complete'
    end
  end
end
