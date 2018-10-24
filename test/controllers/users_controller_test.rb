require "test_helper"

describe UsersController do
  describe 'logged in user' do

    before do
      login(User.first)
    end

    describe "index" do
      it "sends a success response when there are many users" do
        User.count.must_be :>, 0

        get users_path

        must_respond_with :success
      end

    end

    describe "show" do
      it "sends success if the user exists" do
        get user_path(User.first)
        must_respond_with :success
      end

      it "sends not_found if the user doesnt exist" do
        user_id = User.last.id + 1
        get user_path(user_id)

        must_respond_with :not_found
      end

    end

    describe "edit" do
      it "sends success if user exists" do
        get edit_user_path(User.first)
        must_respond_with :success
      end

      it "sends not_found if the book doesnt exist" do
        user_id = User.last.id + 1
        get edit_user_path(user_id)
        must_respond_with :not_found
      end
    end

    describe "create" do
      it "can add a valid user" do
        user_data = {
          uid: "8977",
          provider: "github",
          info: {
            email: "someemail@gmail.com",
            name: "testing"
          }
        }

        old_user_count = User.count

        # User.new(user_data).must_be :valid?

        get auth_callback_path(:github), params: {user: user_data}

        must_respond_with :redirect
        must_redirect_to root_path

        # User.count.must_equal old_user_count + 1
        # User.last.name.must_equal user_data[:info][:name]
      end

      it "won't add an invalid user" do
        user_data = {
          email: "test@gmail.com",
          uid: "8977",
          provider: "github"
        }

        old_user_count = User.count

        User.new(user_data).wont_be :valid?

        get auth_callback_path(:github), params: {user: user_data}

        must_respond_with :redirect

        User.count.must_equal old_user_count
      end

      it "won't add user with duplicate data" do
        repeat = User.first.email

        user_data = {
          name: "Test Email",
          email: repeat,
          uid: "8977",
          provider: "github"
        }

        old_user_count = User.count

        User.new(user_data).wont_be :valid?

        get auth_callback_path(:github), params: {user: user_data}

        must_respond_with :redirect

        User.count.must_equal old_user_count

      end

    end

    describe "update" do
      it "updates an existing user with valid data" do
        user = User.first
        user_data = user.attributes
        user_data[:name] = "Updated Name"

        user.assign_attributes(user_data)
        user.must_be :valid?

        patch user_path(user), params: { user: user_data }

        must_respond_with :redirect
        must_redirect_to user_path(user)

        user.reload
        user.name.must_equal user_data[:name]
      end

      it "sends bad_request for invalid data" do
        user = User.first
        user_data = user.attributes
        user_data[:name] = User.last.name

        user.assign_attributes(user_data)
        user.wont_be :valid?

        patch user_path(user), params: { user: user_data }

        must_respond_with :bad_request

        user.reload
        user.name.wont_equal user_data[:name]
      end

      it "sends not_found for a book that doesnt exist" do
        user_id = User.last.id + 1

        patch user_path(user_id)

        must_respond_with :not_found
      end

    end

    describe "destroy" do
      it "destroys a real user" do
        user = User.first
        expect_count = User.count - 1

        delete user_path(user)

        must_respond_with :redirect
        must_redirect_to root_path

        User.find_by(id: user.id).must_be_nil
      end

      it "removes any products from user if destroyed" do
        user = User.first
        product = Product.first
        product.user = user

        user.products.count.must_be :>, 0

        delete user_path(user)

        product.reload
        product.user_id.wont_equal user.id
      end

      it "sends not_found when the user doesnt exist" do
        user_id = User.last.id + 1
        old_user_count = User.count

        delete user_path(user_id)

        must_respond_with :not_found
        User.count.must_equal old_user_count
      end

    end
  end
end
