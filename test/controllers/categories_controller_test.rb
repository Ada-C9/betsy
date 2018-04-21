require "test_helper"

describe CategoriesController do
  describe 'index' do
    it 'can succeed with all categories' do
      Category.count.must_be :>, 0

      get categories_path
      must_respond_with :success
    end

    it 'can succeed with no categories' do
      Category.destroy_all

      get categories_path
      must_respond_with :success
    end
  end

  describe 'show' do
    it "can find an exsisting category" do
      get category_path(Category.first)
      must_respond_with :success
    end

    it "renders 404 not found for a fake id" do
      fake_category_id = Category.last.id + 1
      get category_path(fake_category_id)
      must_respond_with :not_found
    end
  end
end
