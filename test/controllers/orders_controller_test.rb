require "test_helper"
require 'pry'

describe OrdersController do

  describe "index" do

    it "should get index" do
      get orders_path
      must_respond_with :success
    end

    it "succeeds with no orders" do

      orders = Order.all
      orders.destroy_all

      get orders_path

      must_respond_with :success
    end
  end


  describe "new" do
    it "succeeds" do
      get new_order_path
      must_respond_with :success
    end
  end



  describe "update" do
    it "updates an order with valid data" do
      new_order = orders(:one)

      order_info = {
      name_on_card: "Bunny",
      cc_num: "1234123412341234",
      cvv: 121,
      email: "hello@hi.org",
      street_address: "111 Candy Cane Lane",
      state: "NP",
      city: "Santa",
      zip: 54321,
      status: "paid"
      }

      proc   {
        put order_path(new_order.id), params: { order: order_info }
      }.must_change 'Order.where(status: "paid").count', 1

      placed_order = Order.find_by(cc_num: 1234123412341234)

      placed_order.status.must_equal "paid"
      must_respond_with :redirect
      must_redirect_to order_path(placed_order.id)
    end

    it "renders bad_request and does not update the DB for bogus data" do
      order = orders(:one)

      bad_order_hash = {
        name_on_card: nil,
      }

      proc   {
        put order_path(order.id), params: { order: bad_order_hash }
      }.must_change 'Order.where(status: "paid").count', 0

      must_respond_with :bad_request
    end

    it "reduces the quantity of each product on the order" do
      order = Order.create(status: "pending")

      product = products(:cat)

      item = OrderItem.new(product_id: product.id, order_id: order.id, quantity: 2)
      item.save

      order_info = {
      name_on_card: "Bunny",
      cc_num: "1234123412341234",
      cvv: 121,
      email: "hello@hi.org",
      street_address: "111 Candy Cane Lane",
      state: "NP",
      city: "Santa",
      zip: 54321,
      status: "paid"
      }

      proc   {
        put order_path(order.id), params: { order: order_info }
        product = Product.find(item.product_id)
      }.must_change 'product.stock', -2


    end
  end


  describe "show" do
    it "succeeds for an extant order ID" do
      order = orders(:one)

      get order_path(order.id)
      must_respond_with :success

    end

    it "renders 404 not_found for a bogus order ID" do
      get order_path("abc")
      must_respond_with :not_found
    end
  end

end
