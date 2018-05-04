require "test_helper"
require 'pry'
describe SessionsController do

  it "logs in an existing user and redirect to root_path" do
    user = users(:ada)
    start_count = User.count
    login(user, :github)
    User.count.must_equal start_count
    must_redirect_to root_path
    session[:user_id].must_equal user.id
  end

  it "must have a username" do
    user = users(:ada)
    login(user, :github)
    user.username.must_equal "countess_ada"
  end

  it "clears the session and redirects back to the root path when a merchant logs out" do
    user = users(:ada)
    login(user, :github)
    delete logout_path
    session[:user_id].must_equal nil
    must_redirect_to root_path
  end

end
