require "test_helper"

describe OrderItemsController do

  describe 'New' do
    it 'generates a new order item' do
      get new_order_item_path
      must_respond_with :success
    end
  end

  describe 'Create' do
    it 'creates a new order item' do
      proc{
      post order_item_path(order_items(:order_item_1)), params:{
            order_item:{
              quantity:44,
              is_shipped:false,
              product:"A dog",
              order:order_items(:order_item_1).order
            }
      }}.must_change "OrderItem.count", 1
    end
  end


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
