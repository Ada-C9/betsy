require "test_helper"

describe UsersController do
  let(:u) { users(:user_1) }
  describe "index" do
    it "should run successfully" do
      get users_path
      must_respond_with :success
    end
  end
end
describe "Show" do
  it "should show a users page" do
    get user_path(users(:user_1).id)
    must_respond_with :success
  end
  it "should render 404 not found for show page request to a user that has not been created" do
    # non_existant_user = 10000001
    # get user_path(non_existant_user)
    # must_respond_with :missing
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

end
