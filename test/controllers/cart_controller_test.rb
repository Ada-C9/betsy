require "test_helper"
require 'pry'

describe CartController do

  before do

    @user_1 = users(:user_1)

    # @cart = orders(:order_5)

    @item7 = order_items(:order_item_7) #prod 7
    @item8 = order_items(:order_item_8) #prod 8
    @item9 = order_items(:order_item_9) #prod 9
    @item9 = order_items(:order_item_10) #prod 10

    @product_7 = products(:product_7)
    @product_8 = products(:product_8)
    @product_9 = products(:product_9)
    @product_10 = products(:product_10)

  end

  describe "access_cart" do

    it "renders the empty cart view when no user is logged in" do


    end

    it "finds the correct order by session key if one already exists" do

    end


  end

  describe "add_to_cart" do

    it "If a cart does not already exist, creates a new instance of Order and assigns its ID to the proper key in session" do

    end

    it "If a cart already exists, finds an instance of Order according to the key in session" do

    end

    it "responds with 'failure' if the ID for the product desired is not in the database" do

    end

    it "creates a new order-item instance if the user does not already have an order-item with that product_id in their cart, and assigns the cart's id to its order_id attribute" do

    end

    it "Increments the existing order-item's quantity by one, if the user already has an order-item with that product id in their cart " do

    end

    it "responds with 'failure' if there is not enough inventory on-hand to fulfil the user's 'add' request" do

    end

  end

  describe "update_cart_info" do

    #BORROWED FROM SELAM'S ORDER UPDATE TEST-- MAKE SURE OF FIT.
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

      must_respond_with :redirect
      must_redirect_to order_path(orders(:order_2).id)
    end

    it 'will render 404 page for request to update an order that does not exist' do
            non_existant_order = 100000001
            patch order_path(non_existant_order)
            must_respond_with :not_found
    end

    it 'will return a bad request for an attempt to update an order with invalid data' do
      proc{
            patch order_path(orders(:order_2).id), params:{
              order: {status:orders(:order_2).status,
                      name: "",
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

      must_respond_with :bad_request

    end

      
  end

  describe "update_to_paid" do

    it "will respond with failure when an order does not have all the necessary information in its attributes" do
    end

    it "changes the status of an order from 'pending' to 'paid' when that order's attributes are properly populated, and redirects to the confirmation page." do
    end
  end

  describe "destroy" do

    it "destroys all the order-items associated with the current cart, and renders the empty-cart view" do  # Remember that empty_cart has been relocated.
    end

    it "responds with failure if there is no identifiable cart" do

    end

  end

  describe "remove_single_item" do

    it "destroys a specified order-item" do
    end

    it "" do
    end
  end

end
