require "test_helper"

describe CartsController do
  describe "show" do
    it "sends success if the order exists" do
      order = Order.first
      get order_path(order)
      must_respond_with :success
    end

    it "sends success if the orders products exist" do
      order = Order.first
      product = Product.first
      orderitem = Orderitem.create!(product: product, order_id: order.id, quantity: 1)
      order.products.must_respond_with :success
    end

    it "sends success if the orderitems exist" do
      order = Order.first
      product = Product.first
    end
  end

  describe "update" do
    #kat will poke this
    it "updates an existing order with valid data" do
      get root_path
      order = Order.find(session[:order_id])

      order.must_be :valid?
      order_item = order.orderitems.first
      order_item.must_be :valid?

      order_item.product.id.must_equal 6


      old_order_item_quantity = order_item.quantity
      old_order_item_quantity.must_equal 3

      new_quantity = 6

      patch cart_path(order), params: { product_id: order_item.product.id, quantity: new_quantity, order_id: order.id }
      order.reload
      result = order_item.quantity
      result.must_equal new_quantity

    end

  #   it "sends failure for invalid data" do
  #     order = Order.first
  #     order_item = order.orderitems.first
  #     old_order_item_quantity = order_item.quantity
  #     new_quantity = "three"
  #
  #     patch cart_path(order), params: { quantity: new_quantity }
  #     order.reload
  #     result = order_item.quantity
  #     result.wont_equal new_quantity
  #   end
  #
  #   it "removes a product from the cart" do
  #     order = Order.first
  #     order_item_id = order.orderitems.first.id
  #     new_quantity = 0
  #
  #     patch cart_path(order), params: { quantity: new_quantity }
  #     order.reload
  #     result = order.orderitems
  #     result.wont_include order_item_id
  #   end
  #
  #   it "changes the quantity of an existing product in the cart" do
  #     order = Order.first
  #     order_item = order.orderitems.first
  #     old_order_item_quantity = order_item.quantity
  #     new_quantity = 1
  #
  #     patch cart_path(order), params: { quantity: new_quantity }
  #     order.reload
  #     result = order_item.quantity
  #     result.must_equal new_quantity
  #   end
  #
  #   it "sends not_found for an order that does not exist" do
  #     skip
  #   end
  # end
  #
  # describe "add_to_cart" do
  #   it "successfully adds in-stock products to the cart" do
  #     order = orders(:order_two)
  #     puts "#{order.id} order id"
  #     product = products(:regret)
  #     puts "#{product.id} product id"
  #     old_order_item_count = order.products.count
  #     new_quantity = 1
  #     product.stock.must_be :>, 1
  #     post add_to_cart_path, params: { id: order.id, product_id: product.id, quantity: new_quantity }
  #
  #     result = order.products
  #     must_respond_with :redirect
  #     result.must_include product
  #
  #   end
  #
  #   it "does not add products to the cart that are out of stock" do
  #     skip
  #   end
  #
  #
  # end
  #
  # describe "checkout" do
  #   it "renders the shipping and payment info form" do
  #     get checkout_path(Order.first)
  #     must_respond_with :success
  #   end
  # end
  #
  # describe "finalize" do
  #   it "reduces the number of inventory for each product purchased" do
  #     order = Order.first
  #     product = Product.first
  #     old_stock_count = product.stock
  #
  #
  #   end
  #
  #   it "changes the order status from 'pending' to paid" do
  #     skip #what is order status initialized as?
  #   end

    it "creates a Buyer Detail record" do
      get root_path
      order_id = session[:order_id]
      order = Order.find(session[:order_id])

      order.must_be :valid?

      payment_info = {
        email: "test@test.com",
        mailing_address: "123 Street",
        buyer_name: "Buyer Person",
        card_number: "1234567890",
        expiration: "01/01",
        cvv: "1234",
        zipcode: "12345",
        order_id: order_id
      }
      buyer = Buyerdetail.new(payment_info)
      buyer.must_be :valid?
      buyer.save
      post checkout_path(order), params: { buyerdetail: payment_info }

      result = Buyerdetail.find_by(order_id: order_id).id

      result.must_equal buyer.id
    end

    it "responds with bad_request if the order has errors" do
      skip
    end
  end

  describe "order_details" do
    it "successfully renders the order details" do
      order = Order.first
      get order_path(order)
      must_respond_with :success
    end
  end

  describe "clear_cart" do
    it "clears the current cart" do
      #TODO where is this executed?
    end
  end
end
