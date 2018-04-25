require "test_helper"

describe ProductsController do
  describe 'index' do
    it 'can succeed with all products' do
      Product.count.must_be :>, 0

      get products_path
      must_respond_with :success
    end

    it 'can succeed with no products' do
      Product.destroy_all

      get products_path
      must_respond_with :success
    end
  end

  describe 'show' do
    it "can find an exsisting product" do
      get product_path(Product.first)
      must_respond_with :success
    end

    it "renders 404 not found for a fake id" do
      fake_product_id = Product.last.id + 1
      get product_path(fake_product_id)

      must_respond_with :not_found
    end
  end
end
# TODO: Tests for the following methods: new, create, edit, update. product_params, find_products
#FIXME: TESTS: Case 1) -finding a product ---> post exsists, and can be found when user is not logged in: will respond with success
