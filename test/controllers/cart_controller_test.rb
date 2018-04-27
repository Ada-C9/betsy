

require "test_helper"

describe CartController do

  before do

    #USER
    @user_1 = users(:user_1)

    #ORDER TO USE AS TEST CART
    @cart = orders(:order_5)

    #TEST ORDER
    @order_1 = orders(:order_1)

    #ORDER_ITEMS ATTACHED TO ORDER 4
    @item7 = order_items(:order_item_7) #prod 7
    @item8 = order_items(:order_item_8) #prod 8
    @item9 = order_items(:order_item_9) #prod 9
    @item9 = order_items(:order_item_10) #prod 10

    #PRODUCTS
    @product_1 = products(:product_1)
    @product_2 = products(:product_2)
    @product_3 = products(:product_3)
    @product_4 = products(:product_4)
    @product_5 = products(:product_5)
    @product_6 = products(:product_6)

    #PRODUCTS ATTACHED TO ORDER_ITEMS FOR ORDER 4
    @product_7 = products(:product_7)
    @product_8 = products(:product_8)
    @product_9 = products(:product_9)
    @product_10 = products(:product_10)

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

      #Arrrange
      @bogus_product_id = 101
      post add_to_cart_path(@product_5.id) #Note-- does not matter what this product is for purposes of the test-- we just need it to activate the route.

      #Validate test
      session[:cart_order_id].must_equal Order.last.id
      Product.find_by(id: @bogus_product_id).must_be_nil

      #Act
      post add_to_cart_path(@bogus_product_id)

      #Assert
      flash[:result_text].must_equal "That product could not be added to your cart"

      must_redirect_to cart_path

    end

    it "creates a new order-item instance if the user does not already have an order-item with that product_id in their cart, and assigns the cart's id to its order_id attribute" do

      #Arrange
      post add_to_cart_path(@product_2.id)
      cart_order = Order.find_by(id: session[:cart_order_id])

      ###Validate test
      cart_order.order_items.count.must_equal 1
      current_product_in_cart = cart_order.order_items.last.product.name
      added_product_1_order_id = cart_order.order_items.last.order_id
      added_product_1_order_id.must_equal cart_order.id

      #Act
      post add_to_cart_path(@product_3.id)

      #Assert
      cart_order.order_items.count.must_equal 2

      ###The names of the two products will be different
      new_product_in_cart = cart_order.order_items.last.product.name
      current_product_in_cart.wont_equal new_product_in_cart

      ### The order_ids of the two order_items will be the same.
      added_product_2_item_id = cart_order.order_items.last.order_id
      added_product_2_item_id.must_equal added_product_1_order_id

    end

    it "Increments the existing order-item's quantity by one, if the user already has an order-item with that product id in their cart " do

      #Arrange
      post add_to_cart_path(@product_6.id)
      cart_order = Order.find_by(id: session[:cart_order_id])

      ###Validate test
      cart_order.order_items.count.must_equal 1
      current_product_in_cart_name = cart_order.order_items.last.product.name
      current_product_in_cart_quantity = cart_order.order_items.last.quantity
      current_product_in_cart_quantity.must_equal 1

      #Act
      post add_to_cart_path(@product_6.id)

      #Assert

      ### No more order items will have been added.
      cart_order.order_items.count.must_equal 1

      ### The product's name will not have changed.
      product_after_second_post_name = cart_order.order_items.last.product.name
      product_after_second_post_name.must_equal current_product_in_cart_name

      ### The quantity will have increased by one.
      product_after_second_post_quantity = cart_order.order_items.last.quantity
      (product_after_second_post_quantity - current_product_in_cart_quantity).must_equal 1

    end

    it "responds with 'failure' if there is not enough inventory on-hand to fulfil the user's 'add' request" do

      #Arrange
      post add_to_cart_path(@product_1.id)
      cart_order = Order.find_by(id: session[:cart_order_id])

      ###Validate test
      cart_order.order_items.count.must_equal 1
      current_product_in_cart_name = cart_order.order_items.last.product.name
      current_product_in_cart_stock = cart_order.order_items.last.product.stock
      current_product_in_cart_quantity = cart_order.order_items.last.quantity
      current_product_in_cart_quantity.must_equal 1
      current_product_in_cart_stock.must_equal 1

      #Act
      post add_to_cart_path(@product_1.id)

      #Assert

      ### No more order items will have been added.
      cart_order.order_items.count.must_equal 1

      ### The quantity will remain the same.
      product_after_second_post_quantity = cart_order.order_items.last.quantity
      (product_after_second_post_quantity - current_product_in_cart_quantity).must_equal 0

      ### Appropriate error messages will be given.
      flash[:result_text].must_equal "Not enough inventory on-hand to complete your request."

    end

  end

  describe "update_cart_info" do


    it 'is able to update the current cart' do

      #Arrange

      post add_to_cart_path(@product_1.id)
      before_cart_order = Order.find_by(id: session[:cart_order_id])

      #Validate the test

      before_cart_order.wont_be_nil
      before_cart_order.status.must_equal "pending"

      before_cart_order.name.must_be_nil
      before_cart_order.email.must_be_nil
      before_cart_order.street_address.must_be_nil
      before_cart_order.city.must_be_nil
      before_cart_order.state.must_be_nil
      before_cart_order.zip.must_be_nil
      before_cart_order.name_cc.must_be_nil
      before_cart_order.credit_card.must_be_nil
      before_cart_order.expiry.must_be_nil
      before_cart_order.ccv.must_be_nil
      before_cart_order.billing_zip.must_be_nil



      #Act
      patch update_cart_info_path params:{

            order: {

              name: "Order of Operations",
              email: orders(:order_1).email,
              street_address: orders(:order_1).street_address,
              city: orders(:order_1).city,
              state: orders(:order_1).state,
              zip: orders(:order_1).zip,
              name_cc: orders(:order_1).name_cc,
              credit_card:orders(:order_1).credit_card,
              "expiry(1i)" => "2019",
              "expiry(2i)" => "12",
              "expiry(3i)" => "11",
              ccv: orders(:order_1).ccv,
              billing_zip: orders(:order_1).billing_zip
             }
          }

      #Assert

      ### Must update the values of the cart's attributes.

      after_cart_order = Order.find_by(id: session[:cart_order_id])


      after_cart_order.name.must_equal "Order of Operations"
      after_cart_order.email.must_equal "customer_1@test.com"
      after_cart_order.street_address.must_equal "street_address_1"
      after_cart_order.city.must_equal "city_1"
      after_cart_order.state.must_equal "state_1"
      after_cart_order.zip.must_equal "11111"
      after_cart_order.name_cc.must_equal "name_cc_1"
      after_cart_order.credit_card.must_equal "1234123412341111"
      after_cart_order.expiry.to_s.must_equal "2019-12-11"
      after_cart_order.ccv.must_equal "111"
      after_cart_order.billing_zip.must_equal "11111"


      ###Must provide an appropriate response message
      flash[:status].must_equal :success
      flash[:result_text].must_equal "Your order information has been successfully updated!"

      ### Must redirect to cart path.

      must_redirect_to cart_path

    end

    it 'will fail if there is no cart' do

      #Arrange

      #Step 1: Get a session going, with a cart.
      post add_to_cart_path(@product_1.id)
      before_cart_order = Order.find_by(id: session[:cart_order_id])

      before_cart_order.wont_be_nil

      #step 2: Prepare the cart for the cart-destruction process.

      patch update_cart_info_path params:{

            order: {

              name: "Order of Operations",
              email: orders(:order_1).email,
              street_address: orders(:order_1).street_address,
              city: orders(:order_1).city,
              state: orders(:order_1).state,
              zip: orders(:order_1).zip,
              name_cc: orders(:order_1).name_cc,
              credit_card:orders(:order_1).credit_card,
              "expiry(1i)" => "2019",
              "expiry(2i)" => "12",
              "expiry(3i)" => "11",
              ccv: orders(:order_1).ccv,
              billing_zip: orders(:order_1).billing_zip
             }
          }

      # Step 3: Destroy the cart via the route designated for such things.

      patch update_to_paid_path

      #Now we have a situation where Session is awake, but the cart is gone.

      #Validate the test
      after_arrange_cart_order = Order.find_by(id: session[:cart_order_id])

      after_arrange_cart_order.must_be_nil

      #Act:

      #Now we try this method without a cart.

      patch update_cart_info_path params:{

            order: {

              name: "Howdy",
              email: orders(:order_1).email,
              street_address: orders(:order_1).street_address,
              city: orders(:order_1).city,
              state: orders(:order_1).state,
              zip: orders(:order_1).zip,
              name_cc: orders(:order_1).name_cc,
              credit_card:orders(:order_1).credit_card,
              "expiry(1i)" => "2019",
              "expiry(2i)" => "12",
              "expiry(3i)" => "11",
              ccv: orders(:order_1).ccv,
              billing_zip: orders(:order_1).billing_zip
             }
          }

      #Assert

      ### Must update the values of the cart's attributes.

      after_act_cart_order = Order.find_by(id: session[:cart_order_id])


      ###Must provide an appropriate response message
      flash[:status].must_equal :failure
      flash[:result_text].must_equal "We were unable to find your cart."

      ### Must redirect to cart path.

      must_respond_with :not_found


    end
  end

  describe "update_to_paid" do

    it "changes the status of an order from 'pending' to 'paid' when that order's attributes are properly populated, removes its ID from session, and redirects to the confirmation page." do

      #Arrange
      post add_to_cart_path(@product_1.id)
      cart_order = Order.find_by(id: session[:cart_order_id])
      cart_order.wont_be_nil

      patch update_cart_info_path(cart_order.id),  params: {
        order: {
          status:orders(:order_1).status,
          name: "Hello World!",
          email: orders(:order_1).email,
          street_address: orders(:order_1).street_address,
          city: orders(:order_1).city,
          state: orders(:order_1).state,
          zip: orders(:order_1).zip,
          name_cc: orders(:order_1).name_cc,
          credit_card: orders(:order_1).credit_card,
          "expiry(1i)" => "2019",
          "expiry(2i)" => "12",
          "expiry(3i)" => "11",
          ccv: orders(:order_1).ccv,
          billing_zip: orders(:order_1).billing_zip
         }
      }

      our_test_order = Order.find_by(name: "Hello World!")
      before_status = our_test_order.status
      #Act
      patch update_to_paid_path


      #Assert
      ### status must have changed from pending to paid.

      after_test_order = Order.find_by(name: "Hello World!")
      after_test_order.status.must_equal "paid"
      after_test_order.status.wont_equal before_status

      ### appropriate flash messages must be given.
      flash[:status].must_equal :success
      flash[:result_text].must_equal "Your order has been submitted!"

      ### The cart_order_id from Session must be changed to nil.
      session[:cart_order_id].must_be_nil


    end

    it "will respond with failure when an order does not have all the necessary information in its attributes" do

      #Arrange

      post add_to_cart_path(@product_1.id)

      cart_order = Order.find_by(id: session[:cart_order_id])


      ### Validate test
      cart_order.status.must_equal "pending"
      before_status = cart_order.status

      #### New order will be missing key information
      cart_order.name_cc.must_equal nil

      #Act
      patch update_to_paid_path

      #Assert
      ### Will display appropriate failure message
      flash[:result_text].must_equal "We weren't able to process your order. Please double-check the form."

      ### Status will not have changed
      after_status = cart_order.status
      after_status.must_equal before_status

      ### The session's cart_order_id key will still be populated with the cart_order's id.

      session[:cart_order_id].must_equal cart_order.id

      ### Proper redirect will happen

      must_redirect_to cart_path

    end
  end

  describe "destroy" do

    it "When the cart contains multiple items, destroys all the order-items associated with the current cart" do  # Remember that empty_cart has been relocated.

      #Arrange

      post add_to_cart_path(@product_1.id)
      post add_to_cart_path(@product_2.id)
      cart_order_before = Order.find_by(id: session[:cart_order_id])
      before_count = cart_order_before.order_items.count

      #Vaidate Test
      before_count.must_equal 2
      initial_cart_items = OrderItem.where(order_id: cart_order_before.id)
      initial_cart_items.count.must_equal 2

      #Act

      delete cart_destroy_path

      #Assert

      cart_order_after = Order.find_by(id: session[:cart_order_id])

      ###  The same instance of cart exists before and after the method is called.

      cart_order_before.id.must_equal cart_order_after.id

      ### The method destroys all the items associated with the current cart

      cart_order_after.order_items.count.must_equal 0
      afterward_cart_items = OrderItem.where(order_id: cart_order_after.id)
      afterward_cart_items.count.must_equal 0

      ### The method finishes by redirecting to the cart path.

      must_redirect_to cart_path

    end

    it "When the cart contains a single item, destroys all the order-items associated with the current cart, and renders the empty-cart view" do  # Remember that empty_cart has been relocated.

    #Arrange

    post add_to_cart_path(@product_3.id)
    cart_order_before = Order.find_by(id: session[:cart_order_id])
    before_count = cart_order_before.order_items.count

    #Vaidate Test
    before_count.must_equal 1
    initial_cart_items = OrderItem.where(order_id: cart_order_before.id)
    initial_cart_items.count.must_equal 1

    #Act

    delete cart_destroy_path

    #Assert

    cart_order_after = Order.find_by(id: session[:cart_order_id])

    ###  The same instance of cart exists before and after the method is called.

    cart_order_before.id.must_equal cart_order_after.id

    ### The method destroys all the items associated with the current cart

    cart_order_after.order_items.count.must_equal 0
    afterward_cart_items = OrderItem.where(order_id: cart_order_after.id)
    afterward_cart_items.count.must_equal 0

    (initial_cart_items.count - afterward_cart_items.count).must_equal 0

    ### The method finishes by redirecting to the cart path.

    must_redirect_to cart_path


    end

    it "displays appropriate messages if called when the cart is already empty, and makes no changes to the database."    do

    ##Arrange
    #Step 1: Activate the cart
    overall_before_count = OrderItem.all.count
    post add_to_cart_path(@product_3.id)
    cart_order_before = Order.find_by(id: session[:cart_order_id])
    before_count = cart_order_before.order_items.count

    #Vaidate Test Pt 1
    before_count.must_equal 1
    initial_cart_items = OrderItem.where(order_id: cart_order_before.id)
    initial_cart_items.count.must_equal 1
    that_one_item = initial_cart_items.first

    #Step 2: Remove its one item:
    delete remove_single_item_path(that_one_item.id)

    #Validate Test Pt. 2:

    stage_2_cart_items = OrderItem.where(order_id: cart_order_before.id)
    stage_2_cart_items.count.must_equal 0
    OrderItem.find_by(id: that_one_item.id).must_be_nil
    current_cart = Order.find_by(id: session[:cart_order_id])
    current_cart.order_items.count.must_equal 0

    #Step 3:  Now we have an active-but-empty cart in which to act.

    #ACT:

    delete cart_destroy_path

    #Assert :

    ### Must not reduce the contents of the database

    overall_after_count = OrderItem.all.count

    overall_before_count.must_equal overall_after_count

    ### Must serve appropriate flash messages

    flash[:result_text].must_equal "Your cart was already empty!"

    ### Must redirect to the cart path

    must_redirect_to cart_path

    end


    it "When the cart contains a single item, destroys all the order-items associated with the current cart, and renders the empty-cart view" do  # Remember that empty_cart has been relocated.

    #Arrange
    #Step 1: Activate the cart
    post add_to_cart_path(@product_3.id)
    cart_order_before = Order.find_by(id: session[:cart_order_id])
    before_count = cart_order_before.order_items.count

    #Step 2: Vaidate Test
    before_count.must_equal 1
    initial_cart_items = OrderItem.where(order_id: cart_order_before.id)
    initial_cart_items.count.must_equal 1
    that_one_item = initial_cart_items.first

    #ACT:

    delete cart_destroy_path

    #Assert

    cart_order_after = Order.find_by(id: session[:cart_order_id])

    ###  The same instance of cart exists before and after the method is called.

    cart_order_before.id.must_equal cart_order_after.id

    ### The method destroys all the items associated with the current cart

    OrderItem.find_by(id: that_one_item.id).must_be_nil

    cart_order_after.order_items.count.must_equal 0
    afterward_cart_items = OrderItem.where(order_id: cart_order_after.id)
    afterward_cart_items.count.must_equal 0

    ### The method finishes by redirecting to the cart path.

    must_redirect_to cart_path

    end

    it "responds with failure and appropriate error message if there is no identifiable cart" do

    #Act

    delete cart_destroy_path

    #Assert

    ### Must provide appropriate error message
    flash[:result_text].must_equal "Unable to remove the items from your cart."

    ### Must redirect to the cart_path

    must_redirect_to cart_path


    end

  end

  describe "remove_single_item" do

    it "destroys a specified order-item when it is the only item in the cart, and then it renders the :empty_cart view" do

      #Arrange
      post add_to_cart_path(@product_3.id)
      cart_order_before = Order.find_by(id: session[:cart_order_id])
      before_count = cart_order_before.order_items.count

      #Vaidate Test
      before_count.must_equal 1
      initial_cart_items = OrderItem.where(order_id: cart_order_before.id)
      initial_cart_items.count.must_equal 1

      #Act
      sole_cart_item_id = initial_cart_items.last.id

      delete remove_single_item_path(sole_cart_item_id)
      cart_order_after = Order.find_by(id: session[:cart_order_id])
      after_count = cart_order_after.order_items.count
      afterward_cart_items = OrderItem.where(order_id: cart_order_after.id)

      #Assert
      ### The same order instance is being used as the cart before and after the method is called.

      cart_order_before.id.must_equal cart_order_after.id

      ###Must remove the item from the cart

      (before_count - after_count).must_equal 1

      ###Must eliminate the item from the database

      afterward_cart_items.count.must_equal 0

    end

    it "destroys a specified order-item when it has a quantity greater than one" do

      #Arrange
      post add_to_cart_path(@product_3.id)
      post add_to_cart_path(@product_3.id)
      cart_order_before = Order.find_by(id: session[:cart_order_id])
      before_count = cart_order_before.order_items.count

      #Vaidate Test
      before_count.must_equal 1
      initial_cart_items = OrderItem.where(order_id: cart_order_before.id)
      initial_cart_items.count.must_equal 1
      sole_cart_product_type = initial_cart_items.first
      number_of_identicals_in_initial_cart = sole_cart_product_type.quantity
      number_of_identicals_in_initial_cart.must_equal 2

      #Act
      sole_cart_item_id = sole_cart_product_type.id

      delete remove_single_item_path(sole_cart_item_id)

      cart_order_after = Order.find_by(id: session[:cart_order_id])
      after_count = cart_order_after.order_items.count
      afterward_cart_items = OrderItem.where(order_id: cart_order_after.id)

      #Assert
      #### The same order instance is being used as the cart before and after the method is called.

      cart_order_before.id.must_equal cart_order_after.id

      ####Must remove the item from the cart

      (before_count - after_count).must_equal 1

      ####Must eliminate the item from the database

      afterward_cart_items.count.must_equal 0


    end



    it "destroys the correct item when there are multiple items in the cart, and then redirects to the cart view" do

      #Arrange
      post add_to_cart_path(@product_3.id)
      post add_to_cart_path(@product_4.id)
      cart_order_before = Order.find_by(id: session[:cart_order_id])
      before_count = cart_order_before.order_items.count

      #Vaidate Test
      before_count.must_equal 2
      initial_cart_items = OrderItem.where(order_id: cart_order_before.id)
      initial_cart_items.count.must_equal 2
      first_initial_cart_item = initial_cart_items.first
      last_initial_cart_item = initial_cart_items.last
      first_initial_cart_item.id.wont_equal last_initial_cart_item.id

      #Act
      first_initial_item_id = first_initial_cart_item.id

      delete remove_single_item_path(first_initial_item_id)

      cart_order_after = Order.find_by(id: session[:cart_order_id])
      after_count = cart_order_after.order_items.count
      afterward_cart_items = OrderItem.where(order_id: cart_order_after.id)

      #Assert
      ### The same order instance is being used as the cart before and after the method is called.

      cart_order_before.id.must_equal cart_order_after.id

      ###Must remove the item from the cart

      (before_count - after_count).must_equal 1

      ###Must eliminate the item from the database

      afterward_cart_items.count.must_equal 1
      OrderItem.find_by(id: first_initial_item_id).must_be_nil

      ###The rest of the contents of the cart must remain associated with the cart and in the database.

      afterward_cart_items.where(id: last_initial_cart_item.id).count.must_equal 1


      OrderItem.where(id: last_initial_cart_item.id).count.must_equal 1

      ### Will redirect to the cart path

      must_redirect_to cart_path

    end


    it "responds with the appropriate failure messages if cart is empty, and makes no changes to the database" do

      #Arrange / Validate the test

      post add_to_cart_path(@product_3.id)
      delete cart_destroy_path

      cart_order_before = Order.find_by(id: session[:cart_order_id])

      cart_order_before.wont_be_nil
      cart_order_before.order_items.count.must_equal 0

      total_order_items_before = OrderItem.all
      item_not_in_cart = total_order_items_before.find_by(id: @item7.id)
      item_not_in_cart.wont_be_nil

      #Act

      delete remove_single_item_path(@item7.id)

      #Assert

      ### The same order instance will be serving as the cart before and after the method is called.

      cart_order_after = Order.find_by(id: session[:cart_order_id])

      cart_order_after.wont_be_nil
      cart_order_after.id.must_equal cart_order_before.id

      ### Must provide appropriate error message
      flash[:result_text].must_equal "Unable to remove the items from your cart."

      ### Nothing will have been removed from the database

      total_order_items_after = OrderItem.all

      total_order_items_after.find_by(id: @item7.id)
      item_not_in_cart.wont_be_nil

      total_order_items_after.must_equal total_order_items_before

      ### No change will have been made to the contents of the cart.

      cart_order_before.order_items.count.must_equal cart_order_after.order_items.count

      ### Must redirect to the cart_path

      must_redirect_to cart_path


    end



    it "returns failure if cart is not empty, but does not contain the specified item, and remains in the cart view" do


      #Arrange
      post add_to_cart_path(@product_3.id)
      cart_order_before = Order.find_by(id: session[:cart_order_id])
      before_count = cart_order_before.order_items.count

      #Vaidate Test
      before_count.must_equal 1
      initial_cart_items = OrderItem.where(order_id: cart_order_before.id)
      initial_cart_items.count.must_equal 1

      bogus_order_item_id = 23
      OrderItem.find_by(id: bogus_order_item_id).must_be_nil

      #Act
      sole_cart_item_id = initial_cart_items.last.id

      delete remove_single_item_path(bogus_order_item_id)


      cart_order_after = Order.find_by(id: session[:cart_order_id])
      after_count = cart_order_after.order_items.count
      afterward_cart_items = OrderItem.where(order_id: cart_order_after.id)

      #Assert
      ### The same order instance is being used as the cart before and after the method is called.

      cart_order_before.id.must_equal cart_order_after.id

      ###Nothing will be removed from the cart.

      (before_count - after_count).must_equal 0

      ###Nothing will be removed from the database

      afterward_cart_items.count.must_equal 1
      OrderItem.find_by(id: afterward_cart_items.first.id).wont_be_nil

      #### It will provide appropriate error messages

      flash[:result_text].must_equal "Unable to remove the items from your cart."

      #### It will redirect to the cart path

      must_redirect_to cart_path

    end
  end

end
