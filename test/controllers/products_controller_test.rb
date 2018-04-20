require "test_helper"

describe ProductsController do
  describe 'index' do
    it 'succeeds when there are products' do
      # Product.count.must_be :>,0
      #
      # get products_path
      # must_respond_with :success
    end

    it 'succeeds when there are no works' do
      skip
      # Product.destroy_all
      #
      # get products_path
      # must_respond_with :success
    end
  end

  describe 'show' do
    it 'succeeds for an exsisting product' do
      skip
      # get product_path(Product.first)
      # must_respond_with :success
    end

    it 'renders 404 not found for a bogus product id' do
      skip
      # fake_product_id = Product.last.id + 1
      # get edit_product_path(fake_product_id)
      # must_respond_with :not_found
    end
  end
end
