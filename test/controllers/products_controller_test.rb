require "test_helper"

describe ProductsController do

  describe 'index' do
    it "sends a success response where there are products" do

      Product.count.must_be :>,0

      get products_path

      must_respond_with :success

    end

    it "sends a success response when there are no products" do
      Product.destroy_all

      get products_path

      Product.count.must_equal 0
      must_respond_with :success
    end
  end

  describe 'new' do
    it "sends a success response when merchant adds a new product" do
      login(Merchant.first)
      get new_product_path
      must_respond_with :success
    end

    # it "sends bad request when a guest tries to add a new product" do
    #   get new_product_path
    #   must_respond_with :bad_request
    # end
  end

  describe 'create' do

    it "can add a product with valid data" do
      merchant = Merchant.first
      product_data = {
        name: 'random',
        price: 3,
        available: 4,
        merchant_id: merchant.id
      }
      old_product_count = Product.count

      product = Product.new(product_data)

      product.must_be :valid?

      post products_path, params: { product: product_data}

      must_respond_with :redirect
      
      must_redirect_to merchant_products_path(merchant.id)

      Product.count.must_equal old_product_count + 1

      Product.last.name.must_equal product_data[:name]
    end

    it "renders error for invalid data" do

      product_data = {
        merchant_id: Merchant.first.id
      }
      old_product_count = Product.count

      product = Product.new(product_data)

      product.wont_be :valid?

      post products_path, params: { product: product_data}

      must_respond_with :bad_request

      Product.count.must_equal old_product_count
    end
  end

  describe 'edit' do

    it "send success if form loads" do
      merchant = Merchant.first
      login(merchant)
      get edit_product_path(Product.find_by(merchant: merchant))
      must_respond_with :success
    end

    it "sends not_found if product does not exist" do

      product_id = Product.last.id + 1

      get edit_product_path(product_id)
      must_respond_with :not_found

    end
  end

  describe 'show' do
    it "send success if the product exists" do

      get product_path(Product.first)
      must_respond_with :success
    end

    it "sends not_found if product does not exist" do

      product_id = Product.last.id + 1

      get product_path(product_id)
      must_respond_with :not_found

    end
  end

  describe 'update' do
    it "updates existing product with valid data" do

      # product = Product.first
      # product_data = product.attributes
      #
      # product_data[:name] = "sweaty stuff"
      #
      # product.assign_attributes(product_data)
      #
      # product.must_be :valid?
      #
      # patch product_path(product), params: { product: product_data }
      #
      # must_redirect_to product_path(product)
      #
      # product.reload
      # product.name.must_equal product_data[:name]
    end

    it "sends bad_request when data is invalid" do

      merchant = Merchant.first
      login(merchant)

      product = Product.find_by(merchant: merchant)

      product_data = product.attributes

      product_data[:name] = ""

      product.assign_attributes(product_data)

      product.wont_be :valid?

      patch product_path(product), params: { product: product_data }

      must_respond_with :bad_request

      product.reload
      product.name.wont_equal product_data[:name]
    end

    it "sends not_found for a product that does not exist" do

      product_id = Product.last.id + 1

      patch product_path(product_id)

      must_respond_with :not_found
    end

  end

  describe 'destroy' do
    it "can destroy a product" do

      merchant = Merchant.first
      login(merchant)

      product_id = Product.find_by(merchant: merchant).id

      old_product_count = Product.count

      delete product_path(product_id)

      must_respond_with :redirect
      must_redirect_to products_path

      Product.count.must_equal old_product_count - 1
    end

    it "sends not_found when product does not exist" do

      product_id = Product.first.id + 1
      old_product_count = Product.count

      delete product_path(product_id)

      must_respond_with :not_found

      Product.count.must_equal old_product_count

    end
  end
end
