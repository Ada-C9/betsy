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

  describe "create" do
    it "saves a valid category" do
      category_data = {name: 'new category'}
      merchant = Merchant.first
      old_category_count = Category.count

      Category.new(category_data).must_be :valid?
      login(merchant)

      post categories_path, params: {category: category_data}

      must_respond_with :redirect
      must_redirect_to merchant_path(id: merchant.id)
      Category.count.must_equal old_category_count + 1
    end
  end

end
