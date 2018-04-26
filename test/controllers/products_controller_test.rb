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

  #QUESTION: These are only valid methods for logged in users. Do I need to create two sets of tests for these methods: 1) for logged in users & 2) tests for how it should respond to non log in users?

  describe 'new' do

  end

  describe 'create' do

  end

  describe 'edit' do

  end

  describe 'update' do

  end

  describe 'retire' do

  end


end
# TODO: Tests for the following methods: new, create, edit, update. product_params, find_products
