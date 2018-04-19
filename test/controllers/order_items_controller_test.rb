require "test_helper"

describe OrderItemsController do
  it "should get update" do
    get order_items_update_url
    value(response).must_be :success?
  end

end
