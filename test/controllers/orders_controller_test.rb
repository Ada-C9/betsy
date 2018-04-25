require "test_helper"
require 'pry'
describe OrdersController do
  before do
    @test_user = users(:beyonce)
    @test_order = orders(:cart1)
    @test_product = products(:cherries)
  end

  describe "index" do
    it "should get index" do
      get orders_path
      value(response).must_be :success?
    end
  end

  # describe "new" do
  #   it "should get new" do
  #     get new_order_path
  #     value(response).must_be :success?
  #   end
  #
  #   it "should assign user to guest when session user_id is nil" do
  #     session[:user_id] = nil
  #     get new_order_path
  #   end
  # end

  describe "create" do
    it "should get create" do
      get new_order_path(@test_user.id)
      value(response).must_be :success?
    end

    it "valid data should create a new order for logged in user" do
      user = users(:beyonce)
      login(user)

      post add_to_order_path, params: { :product_id => products(:cherries).id,
      :quantity => 2}

      order_count = Order.count

      post orders_path, params: { order:
          { user: user ,
            status: "paid" ,
            name: user.name ,
            card_number: 1234123412341234 ,
            email: user.email ,
            street: "malden" ,
            city: "seattle" ,
            state: "wa" ,
            zip: 12345 ,
            date_year: 19 ,
            date_month: 5 ,
            date_day: 3 ,
            cvv: 123
          }
      }
      must_respond_with :redirect

      must_redirect_to order_details_path(Order.last.id)

      Order.count.must_equal (order_count + 1)
    end

    it "valid data should create a new order when no user is logged in" do
      user = User.first
      user.id = 1
      user.save

      post add_to_order_path, params: { :product_id => products(:cherries).id,
      :quantity => 2}

      order_count = Order.count

      post orders_path, params: { order:
          { user: user ,
            status: "paid" ,
            name: user.name ,
            card_number: 1234123412341234 ,
            email: user.email ,
            street: "malden" ,
            city: "seattle" ,
            state: "wa" ,
            zip: 12345 ,
            date_year: 19 ,
            date_month: 5 ,
            date_day: 3 ,
            cvv: 123
          }
      }
      must_respond_with :redirect

      must_redirect_to order_details_path(Order.last.id)

      Order.count.must_equal (order_count + 1)
    end

    it "invalid data should redirect to order new page if user logged in" do
      user = users(:beyonce)
      login(user)

      post add_to_order_path, params: { :product_id => products(:cherries).id,
      :quantity => 2}

      order_count = Order.count

      post orders_path, params: { order:
          { user: user ,
            status: "paid" ,
            name: user.name ,
            card_number: nil ,
            email: user.email ,
            street: "malden" ,
            city: "seattle" ,
            state: "wa" ,
            zip: 12345 ,
            date_year: 19 ,
            date_month: 5 ,
            date_day: 3 ,
            cvv: 123
          }
      }
      must_respond_with :bad_request

      Order.count.must_equal order_count

    end

    it "invalid data should redirect to order new page if no user logged in" do

      user = User.first
      user.id = 1
      user.save

      post add_to_order_path, params: { :product_id => products(:cherries).id,
      :quantity => 2}

      order_count = Order.count

      post orders_path, params: { order:
          { user: user ,
            status: "paid" ,
            name: user.name ,
            card_number: nil ,
            email: user.email ,
            street: "malden" ,
            city: "seattle" ,
            state: "wa" ,
            zip: 12345 ,
            date_year: 19 ,
            date_month: 5 ,
            date_day: 3 ,
            cvv: 123
          }
      }
      must_respond_with :bad_request

      Order.count.must_equal order_count
    end

  end

  # describe "show" do
  #   it "should get show" do
  #     get order_details_path(@test_order.id)
  #     value(response).must_be :success?
  #   end
  # end

end
