require "test_helper"

describe OrderItemsController do
  # it "should get update" do
  #   get order_items_update_url
  #   value(response).must_be :success?
  # end
  describe 'Update' do
    it 'should update a current valid order item' do

    end

    it 'should return 404 not found for an out of stock/not available order item' do
  # order_item PATCH  /order_items/:id(.:format)
    unavial_product_id = 100001
    binding.pry
        post order_item_path(unavial_product_id), params:{
          order_item:{
            quantity: 1
            is_shipped:false
            product: "a product"
            order: "order_50000"
          }
        }

      must_respond_with :not_found
    end


  end

end
