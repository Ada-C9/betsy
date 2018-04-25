require "test_helper"
require 'pry'

describe ProductsController do
  describe 'Index' do
    it 'should display the index' do
        binding.pry
      get user_products_path(users(:user_3).id)

      must_respond_with :success
    end
  end


end
