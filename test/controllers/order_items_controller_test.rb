require "test_helper"
describe OrderItemsController do


  describe "create" do
    it "creates an order item with valid data for a real product and open order" do
      product = products(:cat)
      order = orders(:one)

      proc {
        post order_items_path, params: { order_item: { product_id: product.id, order_id: order.id, quantity: 1 } }
      }.must_change 'OrderItem.count', 1

      must_respond_with :redirect
      must_redirect_to new_order_path
    end

    it "renders bad_request and does not update the DB for bogus data" do

      proc {
        post order_items_path, params: { order_item: { product_id: nil } }
      }.must_change 'OrderItem.count', 0

      must_respond_with :bad_request
    end
  end

  describe "update" do
    it "changes the quantity of the item in pending order" do
      order = orders(:one)
      product = products(:dog)

      item = OrderItem.create(product_id: product.id, order_id: order.id, quantity: 1)


      proc   {
      put order_item_path(item.id), params: { quantity: { quantity: 3 } }
      item = OrderItem.find(item.id)
      }.must_change 'item.quantity', 2


      must_respond_with :redirect
      must_redirect_to new_order_path
    end
  end

  describe "destroy" do
    it "succeeds for an extant order item ID" do
      item = order_items(:one)
      proc {
        delete order_item_path(item.id)}.must_change 'OrderItem.count', -1
    end

    it "renders 404 not_found and does not update the DB for a bogus order item ID" do
      proc {
        delete order_item_path('abc')}.must_change 'OrderItem.count', 0

        must_respond_with :bad_request
    end

  end
end
