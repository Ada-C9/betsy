require "test_helper"

describe OrderItemsController do

  describe 'Update' do
    it 'should update a current valid order item' do
      proc{
      patch order_item_path(order_items(:order_item_4)), params:{
            order_item:{
              quantity:2,
              is_shipped:order_items(:order_item_4).is_shipped,
              product:order_items(:order_item_4).product,
              order:order_items(:order_item_4).order
            }
      }}.wont_change "OrderItem.count"
      updated_order_item = OrderItem.find_by(id:   order_items(:order_item_4).id)

      updated_order_item.id.must_equal order_items(:order_item_4).id
      updated_order_item.quantity.must_equal 2
      flash[:result_text].must_equal "Quantity updated!"
      must_respond_with :redirect
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

    it 'will not update an invalid order item' do
      patch order_item_path(order_items(:order_item_4).id), params:{
        order_item:{
          quantity: " ",
          is_shipped: order_items(:order_item_4).is_shipped,
          product: order_items(:order_item_4).product,
          order: order_items(:order_item_4).order
        }
      }
      flash[:result_text].must_equal "Could not add the desired quantity of this item to the cart."
    end
  end

  describe 'Set-status' do
    it 'is able to set the status for a current order' do
      order_items(:order_item_1).order.status.must_equal 'pending'

      put order_item_set_status_path(order_items(:order_item_1).id), params:{
        order_item:{
          quantity: order_items(:order_item_1).quantity,
          is_shipped:order_items(:order_item_1).is_shipped,
          product: order_items(:order_item_1).product,
          order: order_items(:order_item_1).order
        }
      }

      updated_order_item = OrderItem.find_by(id: order_items(:order_item_1).id)
      updated_order_item.order.status.must_equal "complete"
      must_respond_with :found

    end
    it 'will render 404 for an order that does not exist' do
      unavial_order_id = -100001
      put order_item_set_status_path(unavial_order_id), params:{
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
