require "test_helper"

describe MerchantsController do

  describe "index" do
    it "succeeds when there are merchants" do
      Merchant.count.must_be :>, 0

      get merchants_path
      must_respond_with :success
    end

    it "succeeds when there are no merchants" do
      Product.destroy_all      
      Merchant.destroy_all
      get merchants_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "succeeds for an extant merchant ID" do
      merchant1 = Merchant.first
      get merchant_path(merchant1)
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus merchant ID" do
      merchant404 = Merchant.last.id + 404
      get merchant_path(merchant404)
      must_respond_with :not_found
    end
  end

end
