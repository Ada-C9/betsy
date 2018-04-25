require "test_helper"
require 'pry'

describe SessionsController do

  describe "new" do
  end

  describe "create" do

    it "logs in an existing user and redirects to the root route" do

      #Arrange
      start_count = User.count
      user = users(:user_1)
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

      #Act
      get auth_callback_path(:github)

      #Assert
      flash[:result_text].must_equal "Logged in successfully"
      must_redirect_to root_path
      session[:user_id].must_equal user.id
      User.count.must_equal start_count

    end

    it "creates an account for a new user and redirects to the root route" do

      # Arrange

      start_count = User.count
      user = User.new(provider: "github", uid: 40420, username: "drywall_bob", email: "bob@drywall.com")
      initial_user_id = user.id
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

      ### Validating arrangement:
      initial_user_id.must_be_nil

      # Act
      get auth_callback_path(:github)
      new_user = User.find_by(username: "drywall_bob")
      session_id_accessible = session[:user_id]

      # Assert
      flash[:result_text].must_equal "Successful first login!"
      User.count.must_equal start_count + 1
      User.last.must_equal new_user
      session[:user_id].must_equal new_user.id
      initial_user_id.wont_equal new_user.id
      must_redirect_to root_path

    end

    it "redirects to the login route if given invalid user data" do

      #Arrange
      start_count = User.count
      user = User.new(provider: "github", uid: 40420, username: "", email: "!!!!!!!!")
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

      #Act
      get auth_callback_path(:github)
      bogus_user = User.find_by(username: "drywall_bob")
      session_id_accessible = session[:user_id]

      #Assert
      flash[:status].must_equal :failure
      bogus_user.must_be_nil
      session[:user_id].must_be_nil
      User.count.must_equal start_count
      must_redirect_to root_path

    end
  end

  describe "index" do
  end

  describe "destroy" do

    it "logs out a logged-in user" do

      # Arrange
      user_2 = users(:user_2)
      login(user_2)


      ###Validate arrangement
      user_2_id = User.find_by(username: "username_2").id
      session[:user_id].must_equal user_2_id

      #Act
      delete logout_path

      #Assert
      session[:user_id].must_be_nil
      flash[:status].must_equal :success
      flash[:result_text].must_equal "Successfully logged out"
      must_redirect_to root_path


    end

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
