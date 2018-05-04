require "test_helper"

describe UsersController do

  describe 'index' do
    it 'succeeds when there are users' do
      User.count.must_be :>,0
      get users_path
      must_respond_with :success
    end
  end

  describe 'show' do
    it 'succeeds for an extant user ID' do
      user_id = User.first.id

      get user_path(user_id)

      must_respond_with :success
    end

    it 'renders 404 not_found for a bogus user ID' do
      user_id = User.last.id + 1

      get user_path(user_id)

      must_respond_with :not_found
    end
  end

  describe "new" do
    it "succeeds" do
      get new_user_path

      must_respond_with :success
    end
  end


  describe "edit" do
    it "should get edit for valid id" do
      user_id = User.first.id
        get edit_user_path(user_id)

        must_respond_with :success

    end

    it "renders 404 and does not update DB for bad ID" do
      user_id = User.last.id + 1

        get edit_user_path(user_id)

        must_respond_with :not_found

    end
  end

end
