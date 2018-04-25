require "test_helper"
require 'pry'

describe SessionsController do

  describe "new" do
  end

  describe "create" do

    it "logs in an existing user and redirects to the root route" do

      start_count = User.count

      user = users(:user_1)

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

      get auth_callback_path(:github)


      flash[:result_text].must_equal "Logged in successfully"
      must_redirect_to root_path
      session[:user_id].must_equal user.id
      User.count.must_equal start_count

    end
    
    it "creates an account for a new user and redirects to the root route" do

      start_count = User.count

      user = User.new(provider: "github", uid: 40420, username: "drywall_bob", email: "bob@drywall.com")

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

      get auth_callback_path(:github)

      must_respond_with :success
      user.username.must_equal "drywall_bob"
      User.count.must_equal start_count + 1
      must_redirect_to root_path

      session_id = session[:user_id]

      binding.pry

      user.id.must_equal User.last.id

      session[:user_id].must_equal user.id


    end
    #
    # it "redirects to the login route if given invalid user data" do
    #
    #   start_count = User.count
    #
    #   user = User.new(provider: "github", uid: 40420, username: "", email: "!!!!!!!!")
    #
    #   OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
    #
    #   get auth_callback_path(:github)
    #
    #   flash[:status] = :failure
    #   must_redirect_to root_path
    #   session[:user_id].must_be_nil
    #   User.count.must_equal start_count
    #
    # end
  end

  describe "index" do
  end

  describe "destroy" do
  end

end

# describe SessionsController do
#
#   describe "login_form" do
#
#     it "must succeed" do
#
#       get login_path
#       must_respond_with :success
#
#     end
#
#   end
#
#   describe "login" do
#
#     before do
#
#       @unknown_user_name = "Yolanda"
#
#     end
#
#     it "must succeed for an existing user" do
#
#       user_d = users(:dan)
#
#       post login_path, params: {username: "dan"}
#
#       session[:user_id].must_equal user_d.id
#
#       must_redirect_to root_path
#
#
#     end
#
#     it "must succeed for a new user with a valid name" do
#
#       existing_user = User.find_by(username: @unknown_user_name)
#
#       existing_user.must_be_nil
#
#       post login_path, params: {username: @unknown_user_name}
#
#       session[:user_id].wont_be_nil
#       must_redirect_to root_path
#
#     end
#
#     it "must create a new user instance when it recieves a new, valid username" do
#
#       #Just proves that the test works
#       existing_user = User.find_by(username: @unknown_user_name)
#       existing_user.must_be_nil
#
#
#       before_user_count = User.all.count
#
#       post login_path, params: {username: @unknown_user_name}
#
#       after_user_count = User.all.count
#
#       (after_user_count - before_user_count).must_equal 1
#       new_user = User.find_by(username: @unknown_user_name)
#       new_user.username.must_equal @unknown_user_name
#       session[:user_id].must_equal new_user.id
#
#     end
#
#     it "must fail for a new user who doesn't enter a user name" do
#
#       null_username = ""
#
#       post login_path, params: {username: null_username}
#
#       post login_path must_respond_with :bad_request
#
#     end
#
#   end
#
#   describe "logout" do
#
#     it "must succeed" do
#
#       post login_path, params: {username: "testy test"}
#       session[:user_id].wont_be_nil
#
#       post logout_path
#
#       session[:user_id].must_be_nil
#
#     end
#   end
#
# end
