require "test_helper"

describe ProductsController do
  describe 'index' do
    it 'can succeed with all categories' do
      Product.count.must_be :>, 0

      get products_path
      must_respond_with :success
    end

    it 'can succeed with no categories' do
      Product.destroy_all

      get products_path
      must_respond_with :success
    end
  end

  describe 'show' do
    it "can find an exsisting category" do
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
