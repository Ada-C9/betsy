require "test_helper"
require 'pry'
describe MerchantsController do

  describe "index" do
    it "sends a success reponse when there are many merchants" do
      Merchant.count.must_be :>, 0
      get merchants_path
      must_respond_with :success
    end

    it "sends a success response when there are no merchants" do
      # destroy all products before destroying all merchants due to foreign key constraint
      Product.destroy_all
      Merchant.destroy_all
      Merchant.count.must_equal 0
      get merchants_path
      must_respond_with :success
    end

  end

  describe "new" do
    it "sends a success response" do
      get new_merchant_path
      must_respond_with :found
    end
  end

  describe "show" do
    it "sends a success response if the merchant exists in the database" do
      merchant = Merchant.first

      merchant.must_be :valid?

      get merchant_path(merchant)

      must_respond_with :found
    end

    it "sends not_found if the merchant does not exist in the database" do
      merchant = Merchant.last.id + 1

      get merchant_path(merchant)

      must_redirect_to root_path
    end
  end

end
