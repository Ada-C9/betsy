require "test_helper"

describe ProductsController do
  describe 'guest user' do
    describe 'index' do
      it 'succeeds with multiple products for a guest user' do
          Product.count.must_be :>, 0

          get products_path
          must_respond_with :success
      end

      it 'succeeds with no products for a guest user' do
        Product.destroy_all

        Product.count.must_equal 0
        get products_path
        must_respond_with :success
      end

      it 'succeeds for a specific category' do
        category = Category.first

        get category_path(category.name)
        must_respond_with :success
      end

      it 'succeeds with no categories' do
        Category.destroy_all

        get products_path
        must_respond_with :success
      end
    end

    describe 'show' do
      it 'succeeds for an existing product' do
        product_id = Product.first.id

        get product_path(product_id)

        must_respond_with :success
      end

      it 'renders not_found for a non-existing id' do
        product_id = Product.last.id + 1

        get product_path(product_id)

        must_respond_with :not_found
      end
    end
  end

  describe 'authenticated user' do
    let (:product_data) {
      {
        name: 'Product',
        stock: 3,
        price: 3.00,
        merchant_id: Merchant.first.id
      }
    }
    let(:merchant) { Merchant.first }

    before do
      login(merchant)
    end

    describe 'new' do

      it 'succeeds for an authenticated user' do
        get new_merchant_product_path(merchant.id)

        must_respond_with :success
      end
    end

    describe 'create' do

      it 'only works for an authenticated user'

      it "creates a work with valid data" do
        old_product_count = Product.count

        post merchant_products_path(merchant.id), params: { product: product_data }

        must_redirect_to merchant_products_path(merchant.id)
        Product.count.must_equal old_product_count + 1
      end

      it "renders bad_request and does not update the DB for bogus data for an authenticated user" do
        product_data[:name] = nil

        old_product_count = Product.count

        post merchant_products_path(merchant.id), params: { product: product_data }

        must_respond_with :bad_request
        Product.count.must_equal old_product_count
      end
    end

    describe 'edit' do
      it 'succeeds for an authenticated user'
    end

    describe 'update' do
      let (:product) { Product.first }
      let (:old_product_count) { Product.count }

      it 'succeeds with good data' do
        old_product_stock = product.stock

        product_data = {
          name: product.name,
          stock: product.stock - 1,
          price: product.price,
          merchant_id: product.merchant_id
        }

        patch merchant_product_path(product.merchant.id, product.id), params: { product: product_data }
        product.reload

        must_redirect_to merchant_products_path
        Product.count.must_equal old_product_count

        product.stock.must_equal (old_product_stock - 1)
      end

      it 'returns bad_request for bad data'
    end

    describe 'destroy' do
      let (:product) { merchant.products.first }

      it 'retires an existing product' do
        delete merchant_product_path(merchant.id, product.id)

        product.reload
        product.retired.must_equal true
        must_redirect_to merchant_products_path
      end
    end

  end
end
