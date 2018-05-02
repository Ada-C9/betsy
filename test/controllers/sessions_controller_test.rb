require "test_helper"

describe SessionsController do
  describe "create" do
    it "should log in an existing user and redirect to homepage" do
      before_count = Merchant.count
      existing_merchant = merchants(:lucy)

      perform_login(existing_merchant)

      must_redirect_to homepage_path
      Merchant.count.must_equal before_count
    end


    it "should create a new user and redirect to homepage" do
      new_user = Merchant.new(
        provider: "github",
        uid: 239802,
        username: "test user",
        email: "test@test.com"
      )

      proc {
        perform_login(new_user)
      }.must_change "Merchant.count", 1

      must_respond_with :redirect
      must_redirect_to homepage_path
    end

    describe "destroy" do
      it "should logout a user" do
        existing_merchant = merchants(:atul)

        perform_logout(existing_merchant)

        must_respond_with :redirect
        must_redirect_to homepage_path
      end
    end

  end

end
