require "test_helper"

describe MerchantsController do
  it "should get index" do
    get merchants_path

    must_respond_with :success
  end

  it "should get show" do
    get merchant_path(merchants(:atul).id)

    must_respond_with :success
  end

  describe "new" do
    it "succeeds" do
      get new_merchant_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a valid merchant" do
      proc {
        post merchants_path, params: {
          merchant: {
            username: "hello",
            email: "h@h.com"
          }
        }
      }.must_change "Merchant.count", 1

      must_respond_with :redirect
      must_redirect_to merchants_path
    end
  end

  describe "edit" do
    it "should get edit for valid id" do
      get edit_merchant_path(merchants(:atul).id)

      must_respond_with :success
    end

    it "renders 404 and does not update DB for bad ID" do
      get edit_merchant_path(nil)

      must_respond_with 404
    end
  end

  describe "update" do
    it "should update merchant with valid id" do
      new_username = "hellothere"

      proc {
        patch merchant_path(merchants(:atul).id),
        params: {
          merchant: {
            username: new_username,
            email: "hello@hello.com"
          }
        }
      }.must_change 'Merchant.count', 0

      must_respond_with :redirect
      must_redirect_to merchant_path(merchants(:atul).id)
    end
  end
end
