require "test_helper"

describe CategoriesController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
  describe 'index' do
    it 'sends a success response when there are many categories' do
      # Assumptions
      Category.count.must_be :>, 0
      # Act
      get categories_path
      # Assert
      must_respond_with :success
    end

    it 'sends a success response when there are no categories' do
      # Arrange
      Category.destroy_all
      # Act
      get categories_path
      # Assert
      must_respond_with :success
    end
  end

  describe 'show' do
    it 'sends success if the categories exists' do
      get category_path(Category.first)
      must_respond_with :success
    end

    it 'sends not_found if the categories D.N.E.' do
      # Get an invalid book ID somehow
      # more than one way to do this
      category_id = Category.last.id + 1

      get category_path(category_id)

      must_respond_with :not_found
    end
  end

  describe 'new' do
    it 'responds with success' do
      user = User.first
      login(user)
      get new_category_path
      must_respond_with :success
    end
  end

  describe 'create' do

    it 'can create a valid category' do
      user = User.first
      login(user)
      cat_params = {
        name: "test category"
      }
      old_count = Category.count

      Category.new(cat_params).must_be :valid?

      post categories_path, params: {category: cat_params}
      must_respond_with :redirect
      must_redirect_to categories_path

      Category.count.must_equal old_count + 1
      Category.last.name.must_equal cat_params[:name]
    end

    it "won't create an invalid category" do
      user = User.first
      login(user)
      cat_data = {
        name: Category.first.name
      }
      old_count = Category.count

      Category.new(cat_data).wont_be :valid?

      # Act
      post categories_path, params: { category: cat_data }

      # Assert
      must_respond_with :bad_request
      Category.count.must_equal old_count
    end
  end

  describe 'destroy' do
    it 'can destroy an empty category' do
      user = User.first
      login(user)
      category_id = Category.first.id
      old_count = Category.count

      delete category_path(category_id)

      must_respond_with :redirect
      must_redirect_to categories_path

      Category.count.must_equal old_count - 1
      Category.find_by(id: category_id).must_be_nil
    end

    it "can't destroy a category with products" do
      user = User.first
      login(user)
      old_count = Category.count
      category = Category.first

      category.products << products(:toy)

      delete category_path(category.id)

      must_redirect_to categories_path

      Category.count.must_equal old_count
      Category.find_by(id: category.id).must_equal category
    end

    it 'sends not_found when the book D.N.E' do
      old_count = Category.count
      category_id = Category.last.id + 1

      get category_path(category_id)

      must_respond_with :not_found
      Category.count.must_equal old_count
    end
  end
end
