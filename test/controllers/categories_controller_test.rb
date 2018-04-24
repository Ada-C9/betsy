require "test_helper"

describe CategoriesController do

  describe "index" do
    it "should run successfully" do
      get categories_path
      must_respond_with :success
    end
  end

  describe "new" do
    it "should run successfully" do
      get new_category_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "should create category" do
      category_data = {
        category: { name: "Test category" }
      }
      proc {
        post categories_path, params: category_data
      }.must_change 'Category.count', 1
    end
  end

end
