require "test_helper"

describe OrderItemsController do
  describe "index" do
    it "sends a success response when there are many order items" do
      get order_items_path

      must_respond_with :success
    end

    it "sends a success response when there are no orders" do
      OrderItem.destroy_all
      get order_items_path
      must_respond_with :success
    end
  end
  describe "show" do
    it "should get show" do
      get order_item_path(OrderItem.first.id)

      must_respond_with :success
    end

  end

  describe "create" do

    it "sends success if the order exists" do
      order = Order.first
      orderitem_data = { product_id: Product.first.id, quantity: Product.first.stock, order_id: order.id }

      post order_items_path, params: {order_item: orderitem_data}

      get order_item_path(order)
      must_respond_with :success
    end
    it "sends not_found if the order does not exist" do
      order_id = Order.last.id + 1
      get order_item_path(order_id)
      must_respond_with :bad_request
      must_redirect_to root_path
    end

  end

  describe "update" do
    it 'updates the quantity of a same product added to the cart' do

      updated_quantity = 3

      patch order_item_path(OrderItem.first.id),
      params: {
        order_item: {
          quantity: updated_quantity,
        }
      }

      updated_op = OrderItem.find(OrderItem.first.id)
      updated_op.quantity.must_equal updated_quantity

    end
  end

  describe "destroy" do
      it "deletes a order item" do
        delete order_item_path(OrderItem.first.id)

        must_respond_with :redirect
      end

      it "reduces order item count" do
        initial = OrderItem.count

        delete order_item_path(OrderItem.first.id)

        OrderItem.count.must_equal initial - 1

      end
    end

end
