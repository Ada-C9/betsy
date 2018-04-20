require "test_helper"

describe SessionsController do

  describe "auth_callback" do
    it "logs in an existing user and redirect to root route" do
      merchant = Merchant.first
      old_merchant_count = Merchant.count

      login(merchant)

      must_redirect_to root_path
      Merchant.count.must_equal old_merchant_count
      session[:merchant_id].must_equal merchant.id
    end

    it "creates a DB entry for a new user and redirect to root path" do
      skip
      user = User.new(
        provider: "github",
        uid: 505,
        email: "dada@test.org",
        username: "dadatest"
      )

      user.must_be :valid?
      old_user_count = User.count

      login(user)

      User.count.must_equal old_user_count + 1
      must_redirect_to root_path
      session[:user_id].must_equal User.last.id
    end

    it "does not log in with insufficient data and redirect to root path" do
      skip
      user = User.new(
        provider: "github",
        uid: 505,
        email: "dada@test.org",
        username: ""
      )

      user.wont_be :valid?
      old_user_count = User.count

      login(user)

      User.count.must_equal old_user_count
      must_redirect_to root_path
    end

  end
end
