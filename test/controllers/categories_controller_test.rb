require "test_helper"

describe CategoriesController do
  describe "index" do
    it "succeeds when there are categories" do
        Category.count.must_equal 3
        get categories_path
        must_respond_with :success
    end

    it "succeeds when there are no categories" do
      Category.all.each do |item|
        item.destroy
      end

      Category.count.must_equal 0
      get categories_path
      must_respond_with :success
    end
  end

  describe "new" do
    it "succeeds" do
      get new_category_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a product with valid data" do
      Category.count.must_equal 3
        proc {
            post categories_path params: {
              category: {
                name: "Dangerous"
              }
            }
        }.must_change "Category.count", 1
      # must_respond_with :redirect
      # must_redirect_to products_path
    end
  end

end
