require "test_helper"

describe UsersController do
  describe "Index" do
  it "should get index" do
    get users_path
    must_respond_with :success
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

describe "Create" do
  it "should create an a user" do
    post users_path, params:{ post: {username: "a_user", email: "users(:user_2).email", uid: "users(:user_2).uid", provider: "users(:user_2).provider"}
    }
    must_respond_with :redirect
  end
end

end
