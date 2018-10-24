require "test_helper"
require 'pry'

describe ProductsController do

  describe 'index' do
    it 'sends a success response when there are many products' do
      # Assumptions
      Product.count.must_be :>, 0

      # Act
      get products_path

      # Assert
      must_respond_with :success

    end
  end

  describe 'new' do
    before do
      @product_data = {
        name: "test-name",
        price: 11,
        stock: 4,
        product_status: nil,
        user_id: User.first.id
      }
    end
    it 'responds with success' do
      user = User.first
      login(user)
      get new_product_path
      must_respond_with :success
    end

    it 'creates a product associated with user' do

      product = Product.first

      product.user_id.wont_equal nil

    end



    it 'can add a product' do
      # Arrange
      user = User.first
      login(user)
      old_product_count = Product.count

      # Assumptions
     a =  Product.new(@product_data)
     a.must_be :valid?

      # Act
      post products_path, params: { product: @product_data }
      #Assert
      must_respond_with :redirect
      must_redirect_to products_path

      Product.count.must_equal old_product_count + 1
      a.id.must_equal @product_data[:id]
    end

    it "won't add an invalid product" do
      # Arrange

      old_product_count = Product.count

      @product_data1 = {
        name: "test-name",
        price: 11,
        stock: 4,
        product_status: nil,
        user_id: User.first.id
      }
      # Assumptions
      product = Product.new(@product_data1)

      # Assert
      Product.count.must_equal old_product_count
    end

  end

  describe 'show' do
    it 'sends success if the product exists' do
      get product_path(Product.first)
      must_respond_with :success
    end

    it 'sends not_found if the book D.N.E.' do
      # Get an invalid book ID somehow
      # more than one way to do this
      product_id = Product.last.id + 1

      get product_path(product_id)

      must_respond_with :not_found
    end
  end

  describe 'edit' do
  it 'sends success if the product exists' do
    user = User.first
    login(user)
    get edit_product_path(Product.first)
    must_respond_with :success
  end

  it 'sends not_found if the product D.N.E.' do
    # Get an invalid book ID somehow
    # more than one way to do this
    product_id = Product.last.id + 1

    get edit_product_path(product_id)

    must_respond_with :not_found
  end
end

describe 'update' do
    it 'updates an existing product with valid data' do
      # Arrange
      user = User.first
      login(user)
      product = Product.first
      product_data = product.attributes
      product_data[:stock] = 3
      product_data[:stock] = 2

      # Assumptions
      product.assign_attributes(product_data)
      product.must_be :valid?

      # Act
      patch product_path(product), params: { product: product_data }

      # Assert
      must_redirect_to product_path(product)
      # Need to read the actual value from the
      # DB, not from our local variable
      # Book.first.title.must_equal book_data[:title]
      product.reload
      product.stock.must_equal product_data[:stock]
    end

    it 'sends bad_request for invalid data' do
      # Arrange
      user = User.first
      login(user)
      product = Product.first
      product_data = product.attributes
      product_data[:name] = ""

      # Assumptions
      product.assign_attributes(product_data)
      product.wont_be :valid?

      # Act
      patch product_path(product), params: { product: product_data }

      # Assert
      must_respond_with :bad_request

      # Need to read the actual value from the
      # DB, not from our local variable
      # Book.first.title.must_equal book_data[:title]
      product.reload
      product.name.wont_equal product_data[:name]
    end

    it 'sends not_found for a product that D.N.E.' do
      product_id = Product.last.id + 1

      patch product_path(product_id)

      must_respond_with :not_found
    end
  end


  describe 'retired' do

    it 'changes a product_status when a product is retired' do
      user = User.first
      login(user)
      @product = Product.first
      @product.user = user
      @product.save
      @product.reload

      # @product.retire
      post product_retire_path(@product)
      must_respond_with :redirect


      #fetch info from db for test
      @product.reload

      @product.product_status.must_equal 'retired'

    end

    # it 'retires products associated with user when user is deleted' do
    #   products = user.products
    #   user.destroy
    #   products.first.product_status.must_equal 'retired'
    # end
  end
end
