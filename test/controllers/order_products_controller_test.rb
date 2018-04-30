require "test_helper"
require 'pry'
describe OrderProductsController do

  describe 'create' do

    it "can create an OrderProduct with valid data" do
      order = Order.first

      item_data = {
        order_id: order.id,
        quantity: 10,
        product_id: Product.first.id
      }

      # equals 0
      old_count = order.order_products.count

      post order_products_path, params: { order_product: item_data }

      must_respond_with :redirect
      must_redirect_to products_path

      # still equals 0, not saving
      order.order_products.count.must_equal old_count + 1
    end

    it "does not create an OrderProduct with incomplete data" do
      order = Order.first

      item_data = {
        quantity: 10,
      }
      old_count = order.order_products.count

      post order_products_path, params: { order_product: item_data }

      must_respond_with :bad_request
      # still equals 0, not saving
      order.order_products.count.must_equal old_count
    end

  end

  describe 'update' do

    it "updates the quantity of an existing OrderProduct with a valid number" do
      order = Order.first

      order_product = OrderProduct.create!(quantity: 1, order_id: order.id, product_id: Product.first.id)

      item_data = order_product.attributes
      item_data[:quantity] = 2

      patch order_product_path(order_product), params: { order_product: item_data }

    end

  end

end
