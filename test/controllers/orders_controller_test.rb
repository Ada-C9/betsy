require "test_helper"

describe OrdersController do
  before do
    @orders = Order.all
  end
  describe "index" do

    it "sends a success response when there are many orders" do
      @orders.count.must_be :>, 0
      get orders_path
      must_respond_with :success
    end

    it "sends a success response when there are no orders" do
      Order.destroy_all
      @orders.count.must_equal 0
      get orders_path
      must_respond_with :success
    end

  end

  describe "update" do

    it "takes customer information and changes status to paid" do
      product = Product.first

      order_item = {product_id: product.id, quantity: product.stock}
      post order_items_path, params: {order_item: order_item}

      order_id = Order.last.id

      order_data = {
        cc_name: "Sarah Parker",
        email: "jackson@petsy.com",
        cc_num: "12345678901234567",
        cc_cvv: "980",
        cc_exp: "01/22",
        mail_adr: "2615 233rd Ave SE, Sammamish",
        bill_zip: "98075",
        status: "pending"
      }
      patch order_path(order_id), params: {order: order_data}

      must_redirect_to order_path


      Order.last.status.must_equal "paid"
    end

    it "does not procees the order if the customer data is incomplete" do
      orderitem = {product_id: Product.first.id, quantity: Product.first.stock}
      post order_items_path, params: {order_item: orderitem}

      order_data = {
        email: "jackson@petsy.com",
        cc_num: "12345678901234567",
        cc_cvv: "980",
        cc_exp: "01/22",
        mail_adr: "2615 233rd Ave SE, Sammamish",
        bill_zip: "98075",
        status: "pending"
      }
      patch order_path(session[:order_id]), params: {order: order_data}

      must_respond_with :found

      Order.last.status.must_equal "pending"

      session[:order_id].must_equal OrderItem.last.order_id
    end


  end

end
