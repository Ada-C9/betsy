require "test_helper"

describe UsersController do
  let(:u) { users(:user_1) }
  describe "index" do
    it "should run successfully" do
      get users_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "should run successfully for valid user" do
      get user_path(u.id)
      must_respond_with :success
    end

    it "should run successfully for valid user with params" do
      get user_path(u.id), params: { term: "pending" }
      must_respond_with :success
    end

    it "should render 404 for invalid user" do
      get user_path(9)
      must_respond_with :not_found
    end
  end

  describe "create" do
    it "should run successfully" do
      user_data = {
        user: { name: "Test User" }
      }
        post users_path, params: user_data
        must_respond_with :success
      end

      it "should create user" do
        user_data = {
          user: { name: "Test User", id: "test" }
        }
        proc {
          post users_path, params: user_data
        }.must_change 'User.count', 0
      end
    end

  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      # Count the users, to make sure we're not (for example) creating
      # a new user every time we get a login request
      start_count = User.count

      # Get a user from the fixtures
      user = users(:grace)

      # Tell OmniAuth to use this user's info when it sees
      # an auth callback from github
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

      # Send a login request for that user
      # Note that we're using the named path for the callback, as defined
      # in the `as:` clause in `config/routes.rb`
      get auth_callback_path(:github)

      must_redirect_to root_path

      # Since we can read the session, check that the user ID was set as expected
      session[:user_id].must_equal user.id

      # Should *not* have created a new user
      User.count.must_equal start_count
    end

    it "creates an account for a new user and redirects to the root route" do
    end

    it "redirects to the login route if given invalid user data" do
    end
  end

end
