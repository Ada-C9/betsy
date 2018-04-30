require "test_helper"

describe CategoriesController do

  describe "index" do
    it "sends a success reponse when there are many categories" do
      Category.count.must_be :>, 0
      get categories_path
      must_respond_with :success
    end

    it "sends a success response when there are no categories" do
      # destroy all products before destroying all categories
      Product.destroy_all
      Category.destroy_all
      Category.count.must_equal 0
      get merchants_path
      must_respond_with :success
    end
  end

end
