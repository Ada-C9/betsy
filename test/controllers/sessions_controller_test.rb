require "test_helper"

describe SessionsController do

  describe 'new' do
    it 'succeeds with a new user' do
      get new_user_path
      must_respond_with :success
    end
  end

  describe "auth_callback" do
    it "should log in an existing user and redirects them back to the homepage" do
      start_count = User.count
      user = users(:anne)

      #Action
      login(user)
      #Assert
      must_respond_with :redirect
      must_redirect_to root_path
      User.count.must_equal start_count
      session[:user_id].must_equal user.id
    end

    it "can login a new user" do
      start_count = User.count
      user = User.new(
        username: "Greg",
        provider: 'github',
        email: 'Greg@naver.com',
        uid: 901 )

      login(user)

      #Assert
      must_respond_with :redirect
      must_redirect_to root_path
      User.count.must_equal (start_count + 1)
      session[:user_id].must_equal User.last.id
    end

    it 'logs in an existing user' do
      # Arrange
      start_count = User.count
      user = User.first

      # Act
      login(user)

      # Assert
      User.count.must_equal start_count
      session[:user_id].must_equal user.id
    end

    it 'does not login if the user data is invalid' do
      # Validations fails
      user = User.new(
      uid: 99999,
      provider: "github",
      email: nil,
      name: nil)

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      get auth_callback_path(:github)

      must_respond_with :redirect
      must_redirect_to root_path
      # session[:user_id].must_equal nil
    end

    it 'does not log in with insufficient data' do
      start_count = User.count

      user = User.new(
        provider: "github",
        name: 'something',
        uid: 99999)

      login(user)

      User.count.must_equal start_count
      # Auth hash doesn not include a uid
    end
  end

  describe 'logout' do
    it "can logout a user" do
      login(users(:anne))
      session[:user_id].must_equal users(:anne).id

      delete logout_path
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe 'user_email' do
    it "splits email into username" do
      user = {name: 'name',
        username: nil,
        email: 'ada@developers.org',
        uid: "9999",
        provider: 'github'
      }

      user_count = User.count
      User.new(user).must_be :valid?
      post users_path, params: { user: user }
      must_respond_with :success
      User.count.must_equal user_count + 1
      User.last.username.must_equal "ada"
      end
    end
end
