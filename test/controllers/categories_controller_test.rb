require "test_helper"

describe CategoriesController do
  let(:u) { users(:user_1) }
  
  # describe "index" do
  #   it "should run successfully" do
  #     get categories_path
  #     must_respond_with :success
  #   end
  # end

  describe "new" do
    it "should run successfully" do
      login(u)
      get new_category_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "should redirect if category exists" do
      category_data = {
        category: { name: categories(:category_1).name }
      }
      post categories_path, params: category_data
      must_respond_with :bad_request
    end

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
