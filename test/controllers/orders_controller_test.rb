require "test_helper"

describe OrdersController do
  describe "new" do
    it "succeeds" do
      cartitem_data = {
        cart: carts(:cart_three),
        product: Product.first,
        quantity: 1
      }
      post cartitems_path, params: { cartitem: cartitem_data }

      get new_order_path, params: { cart_id: carts(:cart_three).id }
      must_respond_with :success
    end
  end

  describe "create" do
    it "succeeds with the required inputs" do
      cartitem_data = {
        cart: carts(:cart_three),
        product: Product.first,
        quantity: 1
      }
      post cartitems_path, params: { cartitem: cartitem_data }

      order_data = {
        cart: carts(:cart_three),
        status: "pending"
      }
      Order.new(order_data).must_be :valid?
      old_order_count = Order.count

      post orders_path, params: { order: order_data }

      must_respond_with :redirect
      must_redirect_to edit_order_path(Order.last.id)
      Order.count.must_equal old_order_count + 1
    end

    it "returns bad request if the order status is not pending" do
      cartitem_data = {
        cart: carts(:cart_three),
        product: Product.first,
        quantity: 1
      }
      post cartitems_path, params: { cartitem: cartitem_data }

      order_data = {
        cart: carts(:cart_three),
        status: "paid"
      }
      old_order_count = Order.count

      post orders_path, params: { order: order_data }

      must_respond_with :bad_request
      Order.count.must_equal old_order_count
    end
  end

  describe "show" do
    it "succeeds for an existing order id" do
      order_id = Order.first.id

      get order_path(order_id)
      must_respond_with :success
    end

    it "responds with not_found for a bogus order ID" do
      order_id = Order.last.id + 1

      get order_path(order_id)
      must_respond_with :not_found
    end
  end

  describe "edit" do
    it "succeeds for an existing order ID" do
      order_id = Order.first.id

      get edit_order_path(order_id)
      must_respond_with :success
    end

    it "responds with not_found for a bogus order ID" do
      order_id = Order.last.id + 1

      get edit_order_path(order_id)
      must_respond_with :not_found
    end
  end

  describe "update" do
    it "successfully updates the order, stock and visibility of product with valid data" do
      order_id = orders(:order_three).id
      product_id = products(:cheesecake).id
      update_data = {
        name: "Sam",
        email: "sam@somethingcool.com",
        creditcard: "1234123412341234",
        expiration_month: "2020-04-16",
        expiration_year: "2020-04-16",
        name_on_card: "Sammy",
        cvv: "123",
        mail_address: "123 Main Street",
        billing_address: "123 Main Street",
        zipcode: "11111"
      }
      products(:cheesecake).stock.must_equal 6
      products(:cheesecake).visible.must_equal true

      patch order_path(order_id), params: { order: update_data }

      must_respond_with :redirect
      must_redirect_to order_path(order_id)
      Order.find_by(id: order_id).name.must_equal "Sam"
      Product.find_by(id: product_id).stock.must_equal 0
      Product.find_by(id: product_id).visible.must_equal false
    end

    it "redirects and does not update the order, stock, or visibility if quantity is greater than stock" do
      product = Product.first
      cartitem_data = {
        cart: carts(:cart_four),
        product: product,
        quantity: 20
      }
      result = Cartitem.new(cartitem_data).valid?
      result.must_equal true
      post cartitems_path, params: { cartitem: cartitem_data }

      order_data = {
        cart: carts(:cart_four),
        status: "pending"
      }
      result = Order.new(order_data).valid?
      result.must_equal true
      post orders_path, params: { order: order_data }
      order = Order.last
      update_data = {
        name: "Sam",
        email: "sam@somethingcool.com",
        creditcard: "1234123412341234",
        expiration_month: "2020-04-16",
        expiration_year: "2020-04-16",
        name_on_card: "Sammy",
        cvv: "123",
        mail_address: "123 Main Street",
        billing_address: "123 Main Street",
        zipcode: "11111",
        status: "paid"
      }

      patch order_path(order.id), params: { order: update_data }
    end

    it "responds with bad request and does not update the order with bogus data" do
      order_id = orders(:order_three).id
      update_data = {
        name: "Sam",
        email: "sam@somethingcool.com",
        creditcard: nil,
        expiration_month: "2020-04-16",
        expiration_year: "2020-04-16",
        name_on_card: "Sammy",
        cvv: "123",
        mail_address: "123 Main Street",
        billing_address: "123 Main Street",
        zipcode: "11111",
        status: "paid"
      }

      patch order_path(order_id), params: { order: update_data }

      must_respond_with :bad_request
      Order.find_by(id: order_id).name.must_be_nil
    end
  end

  describe "change_status" do
    it "redirects and updates the database if the merchant is logged in" do
      login(merchants(:wini))
      order = orders(:order_one)
      order.status.must_equal "completed"
      update_data = {
        status: "paid"
      }

      patch change_status_path(order.id), params: { order: update_data }

      must_respond_with :redirect
      must_redirect_to order_path(order.id)
      Order.find_by(id: order.id).status.must_equal "paid"
    end

    it "responds with unauthorized and does not update DB if the order does not correspond to the logged in merchant" do
      login(merchants(:grace))
      order = orders(:order_one)
      order.status.must_equal "completed"
      update_data = {
        status: "paid"
      }

      patch change_status_path(order.id), params: { order: update_data }

      must_respond_with :bad_request
      Order.find_by(id: order.id).status.must_equal "completed"
    end

    it "responds with unauthorized and does not update the database if the merchant is not logged in" do
      order = orders(:order_one)
      order.status.must_equal "completed"
      update_data = {
        status: "paid"
      }

      patch change_status_path(order.id), params: { order: update_data }

      must_respond_with :bad_request
      Order.find_by(id: order.id).status.must_equal "completed"
    end

    it "responds with bad request and does not update the database if the order data is bogus" do
      login(merchants(:wini))
      order = orders(:order_one)
      order.status.must_equal "completed"
      update_data = {
        status: nil
      }

      patch change_status_path(order.id), params: { order: update_data }

      must_respond_with :bad_request
      Order.find_by(id: order.id).status.must_equal "completed"
    end

    it "responds with not found if order id is bogus" do
      order_id = Order.last.id + 1
      update_data = {
        status: nil
      }

      patch change_status_path(order_id), params: { order: update_data }

      must_respond_with :not_found
    end
  end

  describe "my_order" do
    it "succeeds for an existing order ID when the merchant is logged in" do
      login(merchants(:wini))
      order_id = orders(:order_one).id

      get my_order_path(order_id)
      must_respond_with :success
    end

    it "renders not_found for a bogus order ID" do
      order_id = Order.last.id + 1

      get my_order_path(order_id)
      must_respond_with :not_found
    end
  end
end
