require "test_helper"

describe OrderItemsController do
  describe 'Update' do
    it 'should update a current valid order item' do
      proc{
      patch order_item_path(order_items(:order_item_1)), params:{
            order_item:{
              quantity:order_items(:order_item_1).quantity,
              is_shipped:order_items(:order_item_1).is_shipped,
              product:"a very fancy dog",
              order:order_items(:order_item_1).order
            }
      }}.wont_change "OrderItem.count"

      must_respond_with :redirect
      # must_redirect_to user_path(order_items(:order_item_1).product.user.id)
      must_redirect_to cart_path

    end

    it 'should return 404 for an order item ID that does not exist' do
    unavial_product_id = -100001
        patch order_item_path(unavial_product_id), params:{
          order_item:{
            quantity: 1,
            is_shipped:false,
            product: "a product",
            order: "order_50000"
          }
        }

      must_respond_with :not_found
    end
  end
end
