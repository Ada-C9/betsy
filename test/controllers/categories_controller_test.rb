require "test_helper"

describe CategoriesController do

  describe "index" do
    it "should get index" do
      get categories_path
      value(response).must_be :success?
    end
    it "succeeds when there are categories" do
      get categories_path

      must_respond_with :success
    end

    it "succeeds when there are no categories" do
      Category.destroy_all
      assert Category.all.empty?
      get categories_path
      must_respond_with :success
    end
  end

  it "should get show" do
    get categories_path(categories(:candy).id)
    value(response).must_be :success?
  end

  describe "new" do
    it "should get new" do
      get new_category_path
      value(response).must_be :success?
    end
  end

  describe "create" do
    it "creates a category with valid data" do

      proc {
        post categories_path, params: {
          category: {
            name: "New Category"
          }
        }
      }.must_change 'Category.count', 1

      # Assert
        must_respond_with :redirect
      must_redirect_to new_product_path
    end

    it" cannot create a category with invalid data" do
      proc {
        post categories_path, params: {
          category: {
            name: ""
          }
        }
      }.must_change 'Category.count', 0

      # Assert
      must_respond_with :redirect
      must_redirect_to categories_path


    end

    it "should get create" do
      get categories_path
      value(response).must_be :success?
    end
  end

  describe 'update' do
    it "should get update" do
      get categories_path(categories(:candy).id)
      value(response).must_be :success?
    end
    it "succeeds for valid data and an extant category ID" do

      patch category_path(categories(:candy).id), params: {
        category: {
          name: "Update name"
        }
      }

      must_respond_with :redirect
      must_redirect_to categories_path(categories(:candy).id)
    end

    it "renders bad_request for bogus data" do

      patch category_path(categories(:candy).id), params: {
        category: {
          doesnt_exists: "Update name"
        }
      }

      must_respond_with :redirect
    end

    it "renders 404 not_found for a bogus category ID" do
      patch category_path("wrong id")

      must_respond_with :missing # 404
    end
  end

  describe 'edit' do
    it "should get edit" do
      get categories_path(categories(:candy).id)
      value(response).must_be :success?
    end
  end

  describe 'destroy' do
    it "should get destroy" do
      get categories_path(categories(:candy).id)
      value(response).must_be :success?
    end
    it "succeeds for an extant category ID" do
        proc {
          delete category_path(categories(:candy).id)
        }.must_change 'Category.count', -1

        must_respond_with :redirect
      end

      it "renders 404 not_found and does not update the DB for a bogus category ID" do
        proc {
          delete category_path("wrond id")
        }.must_change 'Category.count', 0

        must_respond_with :missing
      end
  end


end
