require "test_helper"

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

    describe "new" do
      it "succeeds" do

        get new_order_path

        must_respond_with :success
      end
    end

    describe "create" do
      it "creates a order with valid data" do
        new_order_hash = {
          name: "Three-Toed Sloth",
          stock: 6,
          price: 2800,
          description: "Chill, mellow, and mindful being. Great mediation partner.",
          status: true,
          user_id: 999,
          image_url: "https://placebear.com/g/500/400"
        }

        proc   {
          post orders_path, params: { new_order: new_order_hash }
        }.must_change 'Order.count', 1

        order = Order.find_by(name: "Three-Toed Sloth")

        must_respond_with :redirect
        must_redirect_to order_path(order.id)
      end

      it "renders bad_request and does not update the DB for bogus data" do
        bad_order_hash = {
          name: "Three-Toed Sloth",
          stock: 6,
          price: 2800,
          description: "Chill, mellow, and mindful being. Great mediation partner.",
          status: true,
          user_id: 999,
          image_url: "https://placebear.com/g/500/400"
        }

        proc   {
          post orders_path, params: { order: bad_order_hash }
        }.must_change 'Order.count', 0

        must_respond_with :bad_request
      end
    end
  end
end
