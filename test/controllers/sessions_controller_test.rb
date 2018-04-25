require "test_helper"

describe SessionsController do

  describe "new" do
  end

  describe "create" do

    it "logs in an existing user and redirects to the root route" do

      start_count = User.count

      user = users(:user_1)

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

      get auth_callback_path(:github)

      must_redirect_to root_path
      session[:user_id].must_equal user.id
      User.count.must_equal start_count

    end

    it "creates an account for a new user and redirects to the root route" do

      start_count = User.count

      user = User.new(provider: "github", uid: 40420, username: "drywall_bob", email: "bob@drywall.com")

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

      get auth_callback_path(:github)

      must_redirect_to root_path
      session[:user_id].must_equal User.last.id
      User.count.must_equal start_count + 1

    end

    it "redirects to the login route if given invalid user data" do

      start_count = User.count

      user = User.new(provider: "github", uid: 40420, username: "", email: "!!!!!!!!")

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

      get auth_callback_path(:github)

      must_redirect_to root_path

      session[:user_id].must_be_nil

      User.count.must_equal start_count

    end
  end

  describe "index" do
  end

  describe "destroy" do
  end

end
