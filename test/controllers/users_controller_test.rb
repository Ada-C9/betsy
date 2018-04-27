require 'test_helper'

describe UsersController do

  describe 'show' do
    it 'sends success if the user extant' do
      get user_path(User.first)
      must_respond_with :success
    end

    it 'it sends a 404 if the user is not found' do
      user_id = User.last.id + 1
      get user_path(user_id)
      must_respond_with :not_found
    end
  end

  describe 'new' do
    it 'succeeds with new user' do
      get new_user_path
      must_respond_with :success
    end
  end
end
