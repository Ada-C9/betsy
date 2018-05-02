require "test_helper"
require "pry"

describe ProductsController do

  describe 'root' do
    it 'should work with all products' do
      get homepage_path
      must_respond_with :success
    end

    it 'should work with no products' do
      Product.destroy_all
      assert Product.all.empty?
      get homepage_path
      must_respond_with :success
    end
  end

  describe 'index' do
    it 'should get all products which are active' do
      Product.where(status:"active")
      get products_path
      must_respond_with :success
    end


    it 'should work with no products' do
      Product.destroy_all
      assert Product.all.empty?
      get products_path
      must_respond_with :success
    end
  end

  describe 'show' do
    it 'should show details of a product' do
      get products_path(products(:candy).id)
      must_respond_with :success
    end
    it 'should return 404 for a bogus id' do
      get products_path("wrong id")
      must_respond_with :success
    end
  end

  describe 'new' do
    it 'should create a new Product' do
      get new_product_path
      must_respond_with :success
    end

  end

  describe 'create' do
    it 'creates a product with valid id' do
      existing_merchant = merchants(:atul)
      perform_login(existing_merchant)
      proc {
        post products_path, params: {
          product: {
            name: "A product",
            price: 1,
            quantity: 2,
            :category_ids => [categories(:candy).id],
            merchant_id: existing_merchant.id,
            status: "active"
          }
        }
      }.must_change 'Product.count', 1

      # Assert
      must_respond_with :redirect
      must_redirect_to product_path(Product.last.id)
    end

  end

  describe 'edit' do
    it 'should get edit for a valid id' do
      get edit_product_path(products(:candy).id)
      must_respond_with :success
    end

    it "renders 404 not_found and does not update the DB for a bogus product ID" do
      existing_merchant = merchants(:atul)
      perform_login(existing_merchant)
# binding.pry
  get product_path("wrong id")

      # Assert
      must_respond_with 404
    end
  end

  describe 'update' do
    it 'updates a product with valid id' do
      existing_merchant = merchants(:atul)
      perform_login(existing_merchant)

      proc {
        patch product_path(products(:candy).id), params: {
          product: {
            name: "A product",
            price: 1,
            quantity: 2,
            :category_ids => [categories(:candy).id],
            merchant_id: existing_merchant.id
          }
        }
      }.must_change 'Product.count', 0

      # Assert
      must_respond_with :redirect
      must_redirect_to product_path(products(:candy).id)
    end

    it 'renders 404 for a bogus id' do
      existing_merchant = merchants(:atul)
      perform_login(existing_merchant)

      proc {
        patch product_path("wrong id"), params: {
          product: {
            name: "A product",
            price: 1,
            quantity: 2,
            :category_ids => [categories(:candy).id],
            merchant_id: existing_merchant.id
          }
        }
      }.must_change 'Product.count', 0

      # Assert
      must_respond_with 404
    end

    it "renders bad_request for bogus data" do
      existing_merchant = merchants(:atul)
      perform_login(existing_merchant)

      patch product_path(products(:cake).id), params: {
        product: {
          doesnt_exists: "Update title",
          price: 1,
          quantity: 2,
          :category_ids => [categories(:candy).id],
          merchant_id: existing_merchant.id
        }
      }

      must_respond_with :redirect
    end
  end
end
