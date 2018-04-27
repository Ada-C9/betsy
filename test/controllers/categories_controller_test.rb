require "test_helper"

describe CategoriesController do
  describe "guest user" do
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
      it "can find an existing category" do
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

  describe "login merchant" do
    before do
      @merchant = Merchant.first
      login(@merchant)
    end

    describe "new" do
      it "responds with success" do
        get new_merchant_category_path(@merchant)
        must_respond_with :success
      end
    end

    describe "create" do
      it "can create a valid category" do
        category_data = {
          name: "fluffy"
        }

        old_category_count = Category.count

        Category.new(category_data).must_be :valid?

        post merchant_categories_path(@merchant), params: { category: category_data}

        must_respond_with :redirect
        Category.count.must_equal old_category_count + 1
        Category.last.name.must_equal "fluffy"
      end

      it "can not create a category which is already existed" do
        category_data = {
          name: "cake"
        }

        old_category_count = Category.count

        Category.new(category_data).must_be :invalid?

        post merchant_categories_path(@merchant), params: { category: category_data}

        must_respond_with :bad_request
        Category.count.must_equal old_category_count
      end
    end
  end
end
