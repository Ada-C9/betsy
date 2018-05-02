require "test_helper"

describe OrdersController do

  describe "index" do
    it "should get order index" do
      get orders_path
      value(response).must_be :success?
    end
  end

  describe "show" do
    it "should get show" do
      perform_login(merchants(:astro), :github)
      get order_path(orders(:star_mouse_order))
      must_respond_with :success
    end
  end

  describe "new" do
    it "should be able to render a new form" do
      get new_order_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "should create a new order" do
      proc {
        post orders_path, params: {
          order: {
            email_address: orders(:mystring_order).email_address,
            cc_name: orders(:mystring_order).cc_name,
            cc_number: orders(:mystring_order).cc_number,
            cc_exp_month: orders(:mystring_order).cc_exp_month,
            cc_exp_year: orders(:mystring_order).cc_exp_year,
            cc_cvv: orders(:mystring_order).cc_cvv,
            cc_zip: orders(:mystring_order).cc_zip,
            status: orders(:mystring_order).status,
            street: orders(:mystring_order).street,
            customer_name: orders(:mystring_order).customer_name,
            city: orders(:mystring_order).city,
            state:orders(:mystring_order).state,
            mailing_zip: orders(:mystring_order).mailing_zip,
          }
        }
      }.must_change 'Order.count', 1
      must_respond_with :redirect
      must_redirect_to view_cart_path
    end

    it "should not create an invalid order" do
      proc {
        post orders_path, params: {
          order: {
            email_address: " ",
            cc_name: orders(:mystring_order).cc_name,
            cc_number: orders(:mystring_order).cc_number,
            cc_exp_month: orders(:mystring_order).cc_exp_month,
            cc_exp_year: orders(:mystring_order).cc_exp_year,
            cc_cvv: orders(:mystring_order).cc_cvv,
            cc_zip: orders(:mystring_order).cc_zip,
            status: " ",
            street: orders(:mystring_order).street,
            customer_name: orders(:mystring_order).customer_name,
            city: orders(:mystring_order).city,
            state:orders(:mystring_order).state,
            mailing_zip: orders(:mystring_order).mailing_zip,
          }
        }
      }.must_change 'Order.count', 0
    end
  end

  describe "edit" do
    it "should provide a form to allow a user to edit an order" do
      get edit_order_path(orders(:star_mouse_order).id)
      must_respond_with :success
    end

    it "should redirect if order doesn't exist" do
      get edit_order_path(1111111)
      must_respond_with :redirect
      must_redirect_to products_path
    end
  end

  describe "checkout order" do
    it "Updates order and redirects to order path" do
      proc {
        patch checkout_order_path(orders(:star_mouse_order).id), params: {
          order: {
            email_address: "google@google.com",
            cc_name: "Jackie O",
            cc_number: 1234123412341234,
            cc_ccv: 123,
            cc_zip: 40032,
            status: "paid",
            street: "650 walnut",
            customer_name: "Jackie O",
            city: "Higland Park",
            state: "IL",
            mailing_zip: 60035,
            cc_exp_month: 2,
            cc_exp_year: 2021
          }
        }
      }.must_change 'Order.count', 0

      must_respond_with :redirect
      must_redirect_to order_path(orders(:star_mouse_order).id)
    end

    it "Does not update order and redirects back with invalid data" do
      proc {
        patch checkout_order_path(orders(:star_mouse_order).id), params: {
          order: {
            email_address: "google@google.com",
            cc_name: "Jackie O",
            cc_number: 1232341234,
            cc_ccv: 123,
            cc_zip: 40032,
            status: "paid",
            street: "650 walnut",
            customer_name: "Jackie O",
            city: "Higland Park",
            state: "PM",
            mailing_zip: 60035,
            cc_exp_month: 2,
            cc_exp_year: 2021
          }
        }
      }.must_change 'Order.count', 0

      must_respond_with :redirect
      must_redirect_to view_cart_path
    end
  end

  describe "update" do
    it "is able to update a current order" do
      proc {
        patch order_path(orders(:mystring_order).id),params: {
          order: {      email_address: orders(:mystring_order).email_address,
            cc_name: orders(:mystring_order).cc_name,
            cc_number: orders(:mystring_order).cc_number,
            cc_exp_month: orders(:mystring_order).cc_exp_month,
            cc_exp_year: orders(:mystring_order).cc_exp_year,
            cc_cvv: orders(:mystring_order).cc_cvv,
            cc_zip: orders(:mystring_order).cc_zip,
            status: orders(:mystring_order).status,
            street: orders(:mystring_order).street,
            customer_name: "New Name",
            city: orders(:mystring_order).city,
            state:orders(:mystring_order).state,
            mailing_zip: orders(:mystring_order).mailing_zip,
          }
        }
      }.must_change 'Order.count', 0
      updated_order = Order.find_by(id: orders(:mystring_order).id)
      updated_order.customer_name.must_equal "New Name"
      must_respond_with :redirect
      must_redirect_to order_path(orders(:mystring_order).id)
    end
  end

  describe "cancel order" do
    it "will update the status of a current order to cancelled" do
      patch mark_order_cancelled_path(orders(:mystring_order).id)
      must_respond_with :redirect
      must_redirect_to root_path

      updated_order = Order.find_by(id: orders(:mystring_order).id)
      updated_order.status.must_equal "cancelled"
    end
  end

end
