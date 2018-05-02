require "test_helper"
require 'pry'

describe ProductsController do
  let(:ball) {products(:ball)}
  let(:soap) {products(:soap)}
  let(:novelty) {categories (:novelty)}
  let(:astro_anna) {merchants(:astro)}
  let(:quasar_qutie) {merchants(:quasar)}

  before do
    perform_login(merchants(:astro), :github)
  end

  describe "products index" do
    it "should get index" do
      get products_path
      must_respond_with :success
    end
  end

  describe "show product page" do
    it "should show a user's products" do
      get product_path(ball)
      must_respond_with :success
    end

    it "should redirect if merchant id doesn't exist" do
      get product_path(1000000)
      must_respond_with :redirect
    end

    it "should get search results" do
      get products_path, params: {search: "icecream"}
      must_respond_with :success
    end

    it "gets an individual product page" do
      get product_path(ball)
      must_respond_with :success
    end
  end

  describe "new" do
    it "will bring a form to create a new product" do
      get new_product_path
      must_respond_with :success
    end

    it "will render 404 if merchant is nil" do
      delete logout_path
      get new_product_path
      must_respond_with 404
    end
  end

  describe "create a product" do
    before do
      perform_login(merchants(:astro), :github)
    end
    it "should be able to create a new product" do
      cat_id = [categories(:novelty).id, categories(:food).id]
      proc {
        post products_path,
        params: {
          product: {
            merchant_id: astro_anna.id,
            name: "pencil",
            price_from_form: 10,
            discontinued: false,
            stock: 2,
            description: "best",
            photo: "https://d28rv7itqgss13.cloudfront.net/assets/img/mars_ball-1600_large_2x.jpg",
            category_ids: cat_id
          }
        }
      }.must_change "Product.count", 1
      must_respond_with :redirect
      must_redirect_to products_path
    end
  end

  describe "edit" do
    it "will get the edit form for an existing product" do
      get edit_product_path(ball)
      must_respond_with :success
    end
  end

  describe "update" do
    it "updates an existing product with valid data" do
      cat_id = [categories(:novelty).id, categories(:food).id]

      patch product_path(ball.id), params: {
        product: {
          merchant_id: astro_anna.id,
          name: "super bouncy ball",
          price_from_form: 10,
          discontinued: false,
          stock: 2,
          description: "bouncy",
          photo: "https://d28rv7itqgss13.cloudfront.net/assets/img/mars_ball-1600_large_2x.jpg",
          category_ids: cat_id
        }
      }

      updated_product = Product.find(ball.id)
      updated_product.name.must_equal "super bouncy ball"
      must_redirect_to product_path
    end

    it "does not update with invalid data" do
      cat_id = [categories(:novelty).id, categories(:food).id]

      patch product_path(ball.id), params: {
        product: {
          merchant_id: astro_anna.id,
          name: " ",
          price_from_form: 10,
          # discontinued: false,
          stock: 2,
        }
      }
      updated_product = Product.find(ball.id)
      updated_product.name.must_equal "bouncy ball"
    end
  end

  describe "deactivate action" do
    it "discontinues a product" do
      merchant = merchants(:astro)
      perform_login(merchant, :github)
      patch deactivate_product_path(ball)
      must_redirect_to manage_inventory_path
    end
  end
end
