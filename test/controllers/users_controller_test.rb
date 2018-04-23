require "test_helper"

describe UsersController do
  describe "index" do

    it "should get index" do
      person = users(:ada)
      get users_path(person.id)
      must_respond_with :success
    end

    it "succeeds with no users" do
      users(:ada).destroy
      users(:grace).destroy
      users(:gretchen).destroy

      users.count.must_equal 0

    end
  end
  #
  # describe "show" do
  #
  #   it "should get show" do
  #
  #   end
  # end

end
