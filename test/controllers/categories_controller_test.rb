require "test_helper"


describe CategoriesController do
  let(:user) { users(:one) }
  describe 'index' do
    it 'sends a success response when there are many categories' do
      Category.count.must_be :>, 0

      # Act
      get categories_path

      # Assert
      must_respond_with :success
    end

  end

  describe 'new' do
    it 'responds with success with a logged user' do
      # category = Category.first
      login(user)

      get new_category_path

      must_respond_with :success
    end


  end

  describe "create" do
    it "lets a logged user to create a category" do
      category_data = {name: 'new category'}
      user = User.first
      old_category_count = Category.count

      Category.new(category_data).must_be :valid?
      login(user)

      post categories_path, params: {category: category_data}

      must_respond_with :redirect
      must_redirect_to users_path
      Category.count.must_equal old_category_count + 1
    end

    it "can add a valid category" do
      # Arrange
      category_data = {
        name: 'test category name'
      }
      old_category_count = Category.count

      # Assumption
      Category.new(category_data).must_be :valid?

      # Act
      post categories_path, params: { category: category_data }

      # # Assert
      # # ***The HTTP response below
      # must_respond_with :redirect
      # must_redirect_to categorys_path

      Category.count.must_equal old_category_count + 1
      Category.last.name.must_equal category_data[:name]
    end

    it "won't add an invalid category" do
      # Arrange
      category_data = {
        name: nil
      }
      old_category_count = Category.count

      # Assumption
      Category.new(category_data).wont_be :valid?

      # Act
      post categories_path, params: { category: category_data }

      # Assert
      # must_respond_with :bad_request
      Category.count.must_equal old_category_count
    end
  end

end
