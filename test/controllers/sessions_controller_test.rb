require "test_helper"

describe SessionsController do

  describe "auth_callback" do
    it "logs in an existing merchant and redirect to root route" do
      merchant = Merchant.first
      old_merchant_count = Merchant.count
      login(merchant)

      must_redirect_to root_path
      Merchant.count.must_equal old_merchant_count
      session[:merchant_id].must_equal merchant.id
    end

    it "creates a DB entry for a new merchant and redirect to root path" do
      merchant = Merchant.new(
        provider: "github",
        uid: 505,
        email: "dada@test.org",
        username: "dadatest"
      )

      merchant.must_be :valid?
      old_merchant_count = Merchant.count

      login(merchant)

      Merchant.count.must_equal old_merchant_count + 1
      must_redirect_to root_path
      session[:merchant_id].must_equal Merchant.last.id
    end

    it "does not log in with insufficient data and redirect to root path" do
      skip
      merchant = Merchant.new(
        provider: "github",
        uid: 505,
        email: "dada@test.org",
        username: ""
      )

      merchant.wont_be :valid?
      old_merchant_count = Merchant.count

      login(merchant)

      Merchant.count.must_equal old_merchant_count
      must_redirect_to root_path
    end

  end
end
