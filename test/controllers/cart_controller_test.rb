require "test_helper"
require 'pry'

describe CartController do

  before do

    @user_1 = users(:user_1)

    @cart = orders(:order_5)

    @item7 = order_items(:order_item_7) #prod 7
    @item8 = order_items(:order_item_8) #prod 8
    @item9 = order_items(:order_item_9) #prod 9
    @item9 = order_items(:order_item_10) #prod 10

    @product_7 = products(:product_7)
    @product_8 = products(:product_8)
    @product_9 = products(:product_9)
    @product_10 = products(:product_10)

    @product_2 = products(:product_2)
    @product_3 = products(:product_3)
    @product_4 = products(:product_4)

  end

  describe "access_cart" do


    it "must succeed" do

      #Act
      get cart_path

      #Assert
      must_respond_with :success

    end

    it "finds the correct order by session key if one already exists" do

      #Arrange
      login(@user_1) # We just need to log in somebody to activate the session.  It doesn't matter who, and we won't use user_1's info for anything except validating the arrangement.

      post add_to_cart_path(@product_2.id)
      session_cart_id = session[:cart_order_id]

      ####Validate Test
      session[:user_id].must_equal @user_1.id
      validating_id = Order.find_by(id: session[:cart_order_id]).id
      validating_id.must_equal Order.last.id

      #Act
      get cart_path

      #Assert
      must_respond_with :success

    end


  end

  describe "add_to_cart" do

    it "If a cart does not already exist, creates a new instance of Order and assigns its ID to the proper key in session" do

      #Arrange
      before_count = Order.count

      #Act
      post add_to_cart_path(@product_2.id) #Note-- does not matter what this product is for purposes of the test-- we just need it to activate the route.

      #Assert
      validating_id = Order.find_by(id: session[:cart_order_id]).id
      validating_id.must_equal Order.last.id

      after_count = Order.count
      (after_count - before_count).must_equal 1

    end

    it "If a cart already exists, finds the corresponding instance of Order according to the key in session, and does not add to the database" do

      #Arrange
      before_1st_post_count = Order.count
      post add_to_cart_path(@product_3.id)
      after_1st_post_count = Order.count
      initial_session_cart_id = session[:cart_order_id]

      #### Validate the test
      (after_1st_post_count - before_1st_post_count).must_equal 1
      initial_session_cart_id.wont_be_nil

      #Act
      post add_to_cart_path(@product_4.id)
      after_2nd_post_count = Order.count
      test_session_cart_id = session[:cart_order_id]

      #Assert
      (after_1st_post_count - after_2nd_post_count).must_equal 0
      test_session_cart_id.must_equal initial_session_cart_id

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

  # describe "update_cart_info" do
  #
  #   #BORROWED FROM SELAM'S ORDER UPDATE TEST-- MAKE SURE OF FIT.
  #   it 'is able to update a current object' do
  #     proc{
  #           patch order_path(orders(:order_2).id), params:{
  #             order: {status:orders(:order_2).status,
  #                     name: "Hello World!",
  #                     email: orders(:order_2).email,
  #                     street_address: orders(:order_2).street_address,
  #                     city: orders(:order_2).city,
  #                     state: orders(:order_2).state,
  #                     zip: orders(:order_2).zip,
  #                     name_cc: orders(:order_2).name_cc,
  #                     credit_card:orders(:order_2).credit_card,
  #                     expiry: orders(:order_2).expiry,
  #                     ccv: orders(:order_2).ccv ,
  #                     billing_zip: orders(:order_2).billing_zip }
  #           }
  #     }.must_change 'Order.count', 0
  #
  #     must_respond_with :redirect
  #     must_redirect_to order_path(orders(:order_2).id)
  #   end
  #
  #   it 'will render 404 page for request to update an order that does not exist' do
  #           non_existant_order = 100000001
  #           patch order_path(non_existant_order)
  #           must_respond_with :not_found
  #   end
  #
  #   it 'will return a bad request for an attempt to update an order with invalid data' do
  #     proc{
  #           patch order_path(orders(:order_2).id), params:{
  #             order: {status:orders(:order_2).status,
  #                     name: "",
  #                     email: orders(:order_2).email,
  #                     street_address: orders(:order_2).street_address,
  #                     city: orders(:order_2).city,
  #                     state: orders(:order_2).state,
  #                     zip: orders(:order_2).zip,
  #                     name_cc: orders(:order_2).name_cc,
  #                     credit_card:orders(:order_2).credit_card,
  #                     expiry: orders(:order_2).expiry,
  #                     ccv: orders(:order_2).ccv ,
  #                     billing_zip: orders(:order_2).billing_zip }
  #           }
  #     }.must_change 'Order.count', 0
  #
  #     must_respond_with :bad_request
  #
  #   end
  #
  #
  # end
  #
  # describe "update_to_paid" do
  #
  #   it "will respond with failure when an order does not have all the necessary information in its attributes" do
  #   end
  #
  #   it "changes the status of an order from 'pending' to 'paid' when that order's attributes are properly populated, and redirects to the confirmation page." do
  #   end
  # end
  #
  # describe "destroy" do
  #
  #   it "destroys all the order-items associated with the current cart, and renders the empty-cart view" do  # Remember that empty_cart has been relocated.
  #   end
  #
  #   it "responds with failure if there is no identifiable cart" do
  #
  #   end
  #
  # end
  #
  # describe "remove_single_item" do
  #
  #   it "destroys a specified order-item" do
  #   end
  #
  #   it "" do
  #   end
  # end

end
