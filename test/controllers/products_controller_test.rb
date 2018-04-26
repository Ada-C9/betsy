require "test_helper"

describe ProductsController do
  #NOTE: index and show are available to both logged in merchants and guest users

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

  #NOTE: The following methods are only available to a logged in user aka a 'merchant'.

  describe 'logged in merchant' do
    before do
      login(Merchant.first)
    end

    describe 'new' do
      it 'responds with success' do
        skip
      end
    end

    describe 'create' do
      it 'can add a valid product' do
        skip
      end

      it 'will not add an invalid product' do
        skip
      end
    end

    describe 'edit' do
      it 'sends success if the product does exsist' do
        skip
      end

      it 'sends not_found if the book does not exsist' do
        skip
      end
    end

    describe 'update' do
      it 'updates an exsisting product with valid data' do
        skip
      end

      it 'sends a bad request for invalid data' do
        skip
      end

      it 'sends not_found if the the product does not exsist' do
        skip
      end
    end

    describe 'retire' do
      it 'can successfully retire a product that still has stock and redirects' do
        skip
      end

      it "retires an item that stock has reached 0 and redirects" do
        skip
      end

      it 'will not retire an item that is already retired' do
        skip
      end

      it 'will resoind with result_text if the product cannot be retired' do
        skip
      end
    end
  end

  #NOTE: These are tests for a guest user. No ability to alter or create products. Only show and index.

  describe 'guest user' do

  end

end

# TODO: Tests for the following methods: new, create, edit, update. product_params, find_products
