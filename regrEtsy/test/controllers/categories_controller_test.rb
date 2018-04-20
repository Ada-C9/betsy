require "test_helper"

describe CategoriesController do
  describe "authenticated user" do
    # before do
    #   login(User.first)
    # end

    describe "index" do
      it "sends a success respond when there are many categories" do
        Category.count.must_be :>, 0

        get categories_path

        must_respond_with :success
      end

      it "sends a success respond when there are no categories" do
        Category.destroy_all

        get categories_path

        must_respond_with :success
      end
    end

    describe "new" do
      it "responds with success" do
        get new_category_path
        must_respond_with :success
      end
    end

    describe "create" do
      it "can add a valid category" do
        category_data = {
          name: "Category Test"
        }

        old_category_count = Category.count

        Category.new(category_data).must_be :valid?

        post categories_path, params: { category: category_data }

        must_respond_with :redirect
        must_redirect_to categories_path

        Category.count.must_equal old_category_count + 1
        Category.last.name.must_equal category_data[:name]
      end

      it "won't add a duplicate category" do
        category_data = {
          name: Category.first.name
        }

        old_category_count = Category.count

        Category.new(category_data).wont_be :valid?

        post categories_path, params: { category: category_data }

        must_respond_with :bad_request
        Category.count.must_equal old_category_count
      end
    end

    describe "show" do
      it "sends success if the category exists" do
        get category_path(Category.first)
        must_respond_with :success
      end

      it "sends not_found if the category does not exist" do
        category_id = Category.last.id + 1

        get category_path(category_id)

        must_respond_with :not_found
      end
    end

    describe "edit" do
      it "sends success if the category exists" do
        get edit_category_path(Category.first)
        must_respond_with :success
      end

      it "sends not_found if the book does not exist" do
        category_id = Category.last.id + 1

        get edit_category_path(category_id)

        must_respond_with :not_found
      end
    end

    describe "update" do
      it "updates an existing book with valid data" do
        category = Category.first
        category_data = category.attributes
        category_data[:name] = "Updated Category Name"

        category.assign_attributes(category_data)
        category.must_be :valid?

        patch category_path(category), params: { category: category_data }

        must_redirect_to category_path(category)

        category.reload
        category.name.must_equal category_data[:name]
      end

      it "sends bad_request for invalid data" do
        category = Category.first
        category_data = category.attributes
        category_data[:name] = ""

        category.assign_attributes(category_data)
        category.wont_be :valid?

        patch category_path(category), params: { category: category_data }

        must_respond_with :bad_request

        category.reload
        category.name.wont_equal category_data[:name]
      end

      it "sends not_found for a book that does not exist" do
        category_id = Category.last.id + 1

        patch category_path(category_id)

        must_respond_with :not_found
      end
    end

    describe "destroy" do
      it "destroys a real category" do
        category_id = Category.first.id
        old_category_count = Category.count

        delete category_path(category_id)

        must_respond_with :redirect
        must_redirect_to categories_path

        Category.count.must_equal old_category_count - 1
        Category.find_by(id: category_id).must_be_nil
      end

      it "sends not_found when the book does not exist" do
        category_id = Category.last.id + 1
        old_category_count = Category.count

        delete category_path(category_id)

        must_respond_with :not_found
        Category.count.must_equal old_category_count
      end
    end

  end

  describe "guest user" do
    it "rejects requests for new category form" do
      get new_category_path
      must_respond_with :unauthorized
    end

    it "rejects requests to create a category" do
      category_data = {
        name: "Test Category"
      }

      old_category_count = Category.count
      Category.new(category_data).must_be :valid?

      post categories_path, params: { category: category_data }

      must_respond_with :unauthorized
      Category.count.must_equal old_category_count
    end

    it "rejects requests for edit category form" do
      get edit_category_path(Category.first)
      must_respond_with :unauthorized
    end

    it "rejects requests to update a category" do
      category = Category.first
      category_data = category.attributes
      category_data[:name] = "updated category name"

      category.assign_attributes(category_data)
      category.must_be :valid?

      patch category_path(category), params: { category: category_data }

      must_respond_with :unauthorized
    end

    it "rejects requests to delete a category" do
      category_id = Category.first.id
      old_category_count = Category.count

      delete category_path(category_id)

      must_respond_with :unauthorized
      Category.count.must_equal old_category_count
    end
  end

end
