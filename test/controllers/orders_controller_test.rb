
require "test_helper"

describe OrdersController do
 describe 'index' do
   describe 'index' do
     it 'should get all products' do
       get orders_path
       must_respond_with :success
     end

     it 'should work with no products' do
       Order.destroy_all
       assert Order.all.empty?
       get orders_path
       must_respond_with :success
     end
   end
 end

  it "should get show" do
    get orders_show_url
    value(response).must_be :success?
  end

  it "should get new" do
    get orders_new_url
    value(response).must_be :success?
  end

  it "should get create" do
    get orders_create_url
    value(response).must_be :success?
  end

  it "should get update" do
    get orders_update_url
    value(response).must_be :success?
  end

  it "should get edit" do
    get orders_edit_url
    value(response).must_be :success?
  end

  it "should get destroy" do
    get orders_destroy_url
    value(response).must_be :success?
  end

end
