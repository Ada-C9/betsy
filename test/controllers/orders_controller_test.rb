require "test_helper"

describe OrdersController do

  describe "index" do
    it "sends success when the user is signed in" do
      login(User.first)

      get orders_path

      must_respond_with :success
    end

    it "responds with unauthorized if not signed in" do
      get orders_path

      must_respond_with :unauthorized
    end

  end

  describe "show" do
    it "responds with success when cart exists" do
      get cart_path

      get order_path(Order.find_by(id: session[:order_id]))

      must_respond_with :success
    end

    it "responds with success when cart doesnt exist" do
      order = Order.create!
      Cartitem.create(order: order, product: Product.first, quantity: 3)

      get order_path(order)

      must_respond_with :success
    end

  end

  describe "edit" do
    it "responds with success if the order exists" do
      get order_path(Order.first)

      must_respond_with :success
    end

    it "responds with not found if the order doesn't exists" do
      order_id = Order.last.id + 1
      get order_path(order_id)

      must_respond_with :not_found
    end
  end


  describe "update" do

    before do
      @order = Order.first
      @order_data = {
        name: "test customer",
        email: "something",
        ccnumber: "12345678901234567",
        ccexpiration: Date.today + 60.days,
        cvv: "234",
        address: "some test address",
        zipcode: "90235"
      }
    end



    it "updates an existing order with valid data" do

      old_order_count = Order.count

      patch order_path(@order), params: { order: @order_data }

      must_respond_with :success
      @order.reload
      @order.name.must_equal @order_data[:name]
      Order.count.must_equal old_order_count
    end



    it "won't update existing order with invalid data" do

      # with past date
      @order_data[:ccexpiration] = Date.today - 2.months

      old_order_count = Order.count

      patch order_path(@order), params: { order: @order_data }

      must_respond_with :bad_request
      @order.reload
      @order.name.wont_equal @order_data[:name]
      Order.count.must_equal old_order_count


      # with future date more than 5 years

      @order_data[:ccexpiration] = Date.today + 6.years

      old_order_count = Order.count

      patch order_path(@order), params: { order: @order_data }

      must_respond_with :bad_request
      @order.reload
      @order.name.wont_equal @order_data[:name]
      Order.count.must_equal old_order_count

      #  with cvv lenght more than 4
      @order_data[:cvv] = "09831"

      old_order_count = Order.count

      patch order_path(@order), params: { order: @order_data }

      must_respond_with :bad_request
      @order.reload
      @order.name.wont_equal @order_data[:name]
      Order.count.must_equal old_order_count

      # with ccnumber less than 16

      @order_data[:ccnumber] = "13538202"

      old_order_count = Order.count

      patch order_path(@order), params: { order: @order_data }

      must_respond_with :bad_request
      @order.reload
      @order.name.wont_equal @order_data[:name]
      Order.count.must_equal old_order_count

      # with ccnumber more than 19

      @order_data[:ccnumber] = "1234567890987654321"

      old_order_count = Order.count

      patch order_path(@order), params: { order: @order_data }

      must_respond_with :bad_request
      @order.reload
      @order.name.wont_equal @order_data[:name]
      Order.count.must_equal old_order_count
    end

    it "won't update existing order with insufficient data" do
      # without name
      @order_data[:name] = nil
      patch order_path(@order), params: { order: @order_data }

      must_respond_with :bad_request
      @order.reload
      @order.name.wont_equal @order_data[:name]


      # without ccnumber
      @order_data[:ccnumber] = nil
      patch order_path(@order), params: { order: @order_data }

      must_respond_with :bad_request
      @order.reload
      @order.name.wont_equal @order_data[:name]


      # without cvv
      @order_data[:cvv] = nil
      patch order_path(@order), params: { order: @order_data }

      must_respond_with :bad_request
      @order.reload
      @order.name.wont_equal @order_data[:name]


      # without ccexpiration
      @order_data[:ccexpiration] = nil
      patch order_path(@order), params: { order: @order_data }

      must_respond_with :bad_request
      @order.reload
      @order.name.wont_equal @order_data[:name]

      # without address
      @order_data[:address] = nil
      patch order_path(@order), params: { order: @order_data }

      must_respond_with :bad_request
      @order.reload
      @order.name.wont_equal @order_data[:name]


      # without zipcode
      @order_data[:zipcode] = nil
      patch order_path(@order), params: { order: @order_data }

      must_respond_with :bad_request
      @order.reload
      @order.name.wont_equal @order_data[:name]


    end

    it "responds with not found if the order doesn't exist" do
      order_id = Order.last.id + 1

      patch order_path(order_id), params: { order: @order_data }

      must_respond_with :not_found
    end

  end

  describe "destroy" do

    before do
      @order = Order.first
      @order_data = {
        name: "test customer",
        email: "something",
        ccnumber: "12345678901234567",
        ccexpiration: Date.today + 60.days,
        cvv: "234",
        address: "some test address",
        zipcode: "90235"
      }
    end

    it "changes order status" do

      patch order_path(@order), params: { order: @order_data }

      @order.reload
      @order.state.must_equal "paid"

      delete order_path(@order)
      @order.reload
      @order.state.must_equal "cancelled"

    end

    it "restocks cartitems within it" do

      product = Product.first
      original_stock = product.stock

      cartitem1 = Cartitem.create!(order: @order, product: product, quantity: 2)

      patch order_path(@order), params: { order: @order_data }

      product.reload
      product.stock.must_equal original_stock - 2

      delete order_path(@order)

      product.reload
      product.stock.must_equal original_stock

    end

    it "responds with not found if order does not exist" do
      order_id = Order.last.id + 1
      delete order_path(order_id)
    end
  end
end
