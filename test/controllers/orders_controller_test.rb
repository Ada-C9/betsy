require "test_helper"

  describe OrdersController do
    describe 'Index' do
      it "should get index" do
        get orders_path
        must_respond_with :success
      end
    end

  describe 'New' do
    it 'should be able to render a new order form' do

        get new_order_path
        must_respond_with :success
    end
  end

  describe 'Create' do
    it 'should be able to create a new order' do
      proc{
        post orders_path, params:{
          order: {status:orders(:order_2).status,
                  name: orders(:order_2).name,
                  email: orders(:order_2).email,
                  street_address: orders(:order_2).street_address,
                  city: orders(:order_2).city,
                  state: orders(:order_2).state,
                  zip: orders(:order_2).zip,
                  name_cc: orders(:order_2).name_cc,
                  credit_card:orders(:order_2).credit_card,
                  expiry: orders(:order_2).expiry,
                  ccv: orders(:order_2).ccv ,
                  billing_zip: orders(:order_2).billing_zip }
      }
    }.must_change 'Order.count', 1
      must_respond_with :redirect
      must_redirect_to order_confirmation_path(Order.last.id)

      Order.last.status.must_equal "complete"
      Order.last.name.must_equal "name_2"
      Order.last.email.must_equal "customer_2@test.com"
      Order.last.street_address.must_equal "street_address_2"
      Order.last.city.must_equal "city_2"
      Order.last.state.must_equal "state_2"
      Order.last.zip.must_equal "22222"
      Order.last.name_cc.must_equal "name_cc_2"
      Order.last.credit_card.must_equal  "1234123412342222"
      Order.last.expiry.must_equal Order.last.expiry
      Order.last.ccv.must_equal "222"
      Order.last.billing_zip.must_equal "22222"

      flash[:result_text].must_equal "Your order has been made - congratulations!"

    

    end

    it 'Invalid Order object should not be posted/created' do
      proc{
       post orders_path, params:{
            order: {status:" ",
              email: orders(:order_2).email,
              street_address: orders(:order_2).street_address,
              city: orders(:order_2).city,
              state: orders(:order_2).state,
              zip: orders(:order_2).zip,
              name_cc: orders(:order_2).name_cc,
              credit_card:orders(:order_2).credit_card,
              expiry: orders(:order_2).expiry,
              ccv: orders(:order_2).ccv ,
              billing_zip: orders(:order_2).billing_zip }
        }}.must_change 'Order.count', 0

        must_respond_with :bad_request

        flash[:result_text].must_equal "Something has gone wrong in your orders processing."
    end

    it 'Will render the current show page for invalid data and return HTTP status code:400 from the server' do
      proc{
       post orders_path, params:{
            order: {status:"",
                    name: orders(:order_1).name,
                    email: orders(:order_1).email,
                    street_address: orders(:order_1).street_address,
                    city: orders(:order_1).city,
                    state: orders(:order_1).state,
                    zip: orders(:order_1).zip,
                    name_cc: orders(:order_1).name_cc,
                    credit_card:orders(:order_1).credit_card,
                    expiry: orders(:order_1).expiry,
                    ccv: orders(:order_1).ccv ,
                    billing_zip: orders(:order_1).billing_zip }
        }}.must_change 'Order.count', 0

        must_respond_with :bad_request
    end
  end
  describe 'Confirmation' do
    it 'will display a confirmation for an associated Order' do
      get order_confirmation_path(orders(:order_3).id)

      orders(:order_3).id.must_equal orders(:order_3).id
      must_respond_with :success
    end

    it 'will render 404 if order ID does not exist' do
      non_existant_order = -100001
      get order_confirmation_path(non_existant_order)
      must_respond_with :not_found
    end
  end

  describe 'Show' do
    it 'will display an order page' do
      get order_path(orders(:order_4).id)
      must_respond_with :success
      orders(:order_4).id.must_equal orders(:order_4).id
    end

    it 'will return a 404 page for a request for an order id that does not exist' do
      non_existant_order = -20000002
      get order_path(non_existant_order)
      must_respond_with :not_found
    end
  end

  describe 'Edit' do
    it "will provide the page to allow a user to edit an Order" do
      get edit_order_path(orders(:order_3).id)
      must_respond_with :success
      orders(:order_3).id.must_equal orders(:order_3).id
    end

    it 'will render a 404 page for an edit page for a edit page that does not exist' do
      non_existant_order = -400004
      get edit_order_path(non_existant_order)
      must_respond_with :not_found
    end
end

  describe 'Update' do
    it 'is able to update a current object' do
      proc{
            patch order_path(orders(:order_2).id), params:{
              order: {status:orders(:order_2).status,
                      name: "Hello World!",
                      email: orders(:order_2).email,
                      street_address: orders(:order_2).street_address,
                      city: orders(:order_2).city,
                      state: orders(:order_2).state,
                      zip: orders(:order_2).zip,
                      name_cc: orders(:order_2).name_cc,
                      credit_card:orders(:order_2).credit_card,
                      expiry: orders(:order_2).expiry,
                      ccv: orders(:order_2).ccv ,
                      billing_zip: orders(:order_2).billing_zip }
            }
      }.must_change 'Order.count', 0

      updated_user = Order.find_by(id: orders(:order_2).id)
      updated_user.name.must_equal "Hello World!"
      updated_user.email.must_equal orders(:order_2).email
      updated_user.street_address.must_equal orders(:order_2).street_address
      updated_user.city.must_equal orders(:order_2).city
      updated_user.state.must_equal orders(:order_2).state
      updated_user.zip.must_equal orders(:order_2).zip
      updated_user.name_cc.must_equal orders(:order_2).name_cc
      updated_user.credit_card.must_equal orders(:order_2).credit_card
      updated_user.expiry.must_equal orders(:order_2).expiry
      updated_user.ccv.must_equal orders(:order_2).ccv
      updated_user.billing_zip.must_equal orders(:order_2).billing_zip

      flash[:result_text].must_equal "Hello World! has been updated"
      must_respond_with :redirect
      must_redirect_to order_path(orders(:order_2).id)

    end

    it 'will render 404 page for request to update an order that does not exist' do
            non_existant_order = -100000001
            patch order_path(non_existant_order)
            must_respond_with :not_found
    end

    it 'will return a bad request for an attempt to update an order with invalid data' do
      proc{
            patch order_path(orders(:order_2).id), params:{
              order: {status:orders(:order_2).status,
                      name: "  ",
                      email: orders(:order_2).email,
                      street_address: orders(:order_2).street_address,
                      city: orders(:order_2).city,
                      state: orders(:order_2).state,
                      zip: orders(:order_2).zip,
                      name_cc: orders(:order_2).name_cc,
                      credit_card:orders(:order_2).credit_card,
                      expiry: orders(:order_2).expiry,
                      ccv: orders(:order_2).ccv ,
                      billing_zip: orders(:order_2).billing_zip }
            }
      }.must_change 'Order.count', 0
      flash[:result_text].must_equal '   update has failed'
      must_respond_with :bad_request

    end
  end

  describe 'Cancel' do
    it 'will update the status of a current order to "cancelled"' do
      put order_cancel_path( orders(:order_2).id )
      must_respond_with :redirect
      must_redirect_to products_path

      updated_order = Order.find_by(id: orders(:order_2).id)

      updated_order.status.must_equal "cancelled"
      updated_order.id.must_equal orders(:order_2).id

    end
    it 'will render 404 page for an order that does not exist' do
        non_existant_order = -1
        put order_cancel_path(non_existant_order)
        must_respond_with :not_found
    end

    it 'will ignore an invalid Order that request to be cancelled' do

        put order_cancel_path(orders(:order_2)), params:{
          order: {status:orders(:order_2).status,
                  name: nil ,
                  email: orders(:order_2).email,
                  street_address: orders(:order_2).street_address,
                  city: orders(:order_2).city,
                  state: orders(:order_2).state,
                  zip: orders(:order_2).zip,
                  name_cc: orders(:order_2).name_cc,
                  credit_card:orders(:order_2).credit_card,
                  expiry: orders(:order_2).expiry,
                  ccv: orders(:order_2).ccv ,
                  billing_zip: orders(:order_2).billing_zip }
                }
        updated_order = Order.find_by(id: orders(:order_2).id)

        must_respond_with :redirect
        must_redirect_to products_path

        flash[:result_text].must_equal "Something has gone wrong in your orders cancellation."

        ##issues with this test ###
    end
  end

  describe 'Destroy' do
    it 'will destroy an order' do
      delete order_path(orders(:order_3).id)
      must_respond_with :success
    end

    it 'will render 404 page for an order that does not exist' do
        non_existant_order = -1001
        delete order_path(non_existant_order)
        must_respond_with :not_found
    end
  end

end
