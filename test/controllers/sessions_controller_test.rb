require "test_helper"

describe SessionsController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
  describe 'auth_callback' do
    it 'creates a DB entry for a new user' do
      #arrange
      user = User.new(
        provider: 'github',
        uid: 80085,
        email: 'test@tester.com',
        name: 'test user'
      )
      user.must_be :valid?
      old_user_count = User.count

      login(user)
      User.count.must_equal old_user_count + 1
      session[:user_id].must_equal User.last.id
    end

    it 'logs in an existing user' do
      #arrange
      user = User.first
      old_user_count = User.count

      login(user)

      User.count.must_equal old_user_count
      session[:user_id].must_equal user.id
    end

    it 'does not log in with insufficient data' do
      #Auth hash does not include a uid
      user = User.new(
        uid: 80085,
        name: 'test user'
      )
      user.wont_be :valid?
      old_user_count = User.count

      login(user)
      User.count.must_equal old_user_count
    end

    it 'does not log in if the user data is invalid' do
      old_user_count = User.count

      exist_user = User.first
      name = exist_user.name

      user = User.new(
        provider: 'github',
        uid: 80085,
        email: 'test@tester.com',
        name: name
      )
      user.wont_be :valid?
      login(user)
      get root_path

      User.count.must_equal old_user_count
    end

    it 'can logout of a user session' do
      user = User.first
      login(user)
      session[:user_id].must_equal user.id

      delete logout_path
      must_respond_with :redirect
      session[:user_id].must_be_nil
    end

    it 'will not let user login if already logged in' do
      login(User.first)

      user = User.new(
        provider: 'github',
        uid: 80085,
        email: 'test@tester.com',
        name: name
      )

      user.must_be :valid?
      login(user)
      get root_path
      session[:user_id].must_equal User.first.id
    end
  end
end
