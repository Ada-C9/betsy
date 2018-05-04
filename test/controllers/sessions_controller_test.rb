require "test_helper"

describe SessionsController do
  describe 'auth_callback' do
    it "should create a new user and redirect to root page" do
      user = User.new(provider: 'github', uid: 76621, email: 'mail4@me.org', username: 'Lemuel Larsky')

      user.must_be :valid?
      original_count = User.count
      user.save
      # act
      login(user)

      # assert

      must_redirect_to root_path
      User.count.must_equal original_count + 1
      session[:user_id].must_equal User.last.id

    end


    it "logs in existing user and redirect to root page" do
      # arrange
      user = User.first
      original_count = User.count

      # act
      login(user)

      # assert

      must_redirect_to root_path
      User.count.must_equal original_count
      session[:user_id].must_equal user.id

    end

    it "does not log in with invalid data" do
      user = User.new(provider: 'github', uid: nil , email: 'mail@me.org', username: 'Milkah Lamb')

      user.wont_be :valid?

      original_count = User.count

      # act
      login(user)

      # assert

      must_redirect_to root_path
      User.count.must_equal original_count


    end

    describe 'logout' do
      it "can logout" do
        # Arrange
        login(User.first)

        # Act
        delete logout_path

        assert_nil nil

      end

    end

  end
end
