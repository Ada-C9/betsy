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
  end

  describe "update_cart_info" do
  end

  describe "update_to_paid" do
  end

  describe "destroy" do
  end

  describe "remove_single_item" do
  end

end
