require "test_helper"

describe SessionsController do
  describe 'create action via auth_callback_path' do
    it "creates a new DB entry for a new user" do
      merchant = Merchant.new(
        provider: 'github',
        uid: 0000,
        email: 'test@test.org',
        username: 'testuser'
      )

      merchant.must_be :valid?
      old_merchant_count = Merchant.count

      login(merchant)

      Merchant.count.must_equal old_merchant_count + 1
      session[:merchant_id].must_equal Merchant.last.id
    end
    it "cannot create new user due to invalid data" do
      merchant = Merchant.new(
        provider: 'github',
        uid: 0000,
        username: 'testuser'
      )

      merchant.wont_be :valid?
      old_merchant_count = Merchant.count

      login(merchant)

      Merchant.count.must_equal old_merchant_count
    end

    it "logs in existing merchant" do
      merchant = Merchant.first
      old_merchant_count = Merchant.count

      login(merchant)

      session[:merchant_id].must_equal Merchant.first.id
      must_redirect_to merchant_path(Merchant.first.id)
      Merchant.count.must_equal old_merchant_count
    end

    it "flashes error for invalid info in callback path" do
      merchant = Merchant.new(
        provider: 'github',
        email: 'test@test.org',
        username: 'testuser'
      )

      login(merchant)

      flash[:error].must_equal "Could not authenticate user via Github"
      must_redirect_to root_path
    end
  end

  describe 'destroy action' do
    it "logs user out" do
      merchant = Merchant.first

      login(merchant)
      logout(merchant)

      session[:merchant_id].must_be_nil
    end
  end
end
