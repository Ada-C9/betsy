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
  #
  # #NOTE: The following methods are only available to a logged in user aka a 'merchant'.

  describe 'logged in merchant' do
    before do
      @merchant = Merchant.first
      login(Merchant.first)
    end

    describe 'new' do
      it 'responds with success for a logged in user' do
        get new_product_path
        must_respond_with :success
      end
    end

    describe 'create' do
      it 'can add a valid product' do
        product_data = products(:cheesecake)

        counting = Product.count

        product_data.must_be :valid?

        post products_path, params: { product: product_data.attributes }

        must_respond_with :redirect
        must_redirect_to product_path(Product.last.id)

        Product.count.must_equal counting + 1
        Product.last.name.must_equal product_data[:name]
      end

      it 'will not add an invalid product' do
        product_data = {
          name: " "
        }
        old_count = Product.count

        # Assumptions
        Product.new(product_data).wont_be :valid?

        # Act
        post products_path, params: { product: product_data }

        # Assert
        must_respond_with :bad_request
        Product.count.must_equal old_count
      end
    end

    describe 'edit' do
      it 'sends success if the product does exsist' do
        get edit_product_path(Product.first)
        must_respond_with :success
      end

      it 'sends not_found if the book does not exsist' do
        product_id = Product.last.id + 1

        get edit_product_path(product_id)

        must_respond_with :not_found
      end
    end

    describe 'update' do
      it 'updates an exsisting product with valid data' do
        product = Product.first
        product_data = product.attributes
        product_data[:name] = "some updated name"

        # Assumptions
        product.assign_attributes(product_data)
        product.must_be :valid?

        # Act
        patch product_path(product), params: { product: product_data }

        # Assert
        must_redirect_to product_path(product)

        product.reload
        product.name.must_equal product_data[:name]
      end

      it 'sends a bad request for invalid data' do
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

        product.reload
        product.name.wont_equal product_data[:name]
      end
    end

    describe 'retire' do
      before do
        login(Merchant.first)
        @product = Product.first
        @product.merchant_id = @merchant.id
      end

      it 'can successfully retire a product that still has stock' do
        @product.stock = 4

        patch retire_path(@product)
        @product.reload
        @product.wont_be :visible
        must_respond_with :redirect
        flash[:status].must_equal :success
      end

      it "retires an item that stock has reached 0" do
        @product.stock = 0
        @product.visible = true
        @product.save

        patch retire_path(@product)
        @product.reload
        @product.wont_be :visible
        must_respond_with :redirect
        flash[:status].must_equal :success
      end

      it 'will not retire an item that is already retired and will respond with result_text if the product cannot be retired' do
        @product.visible = false
        @product.stock = 0
        @product.save
        patch retire_path(@product)
        @product.reload
        @product.wont_be :visible
        must_respond_with :redirect
        flash[:status].must_equal :failure
      end
    end
  end

  #NOTE: These are tests for a guest user. No ability to alter or create products. Only show and index.

  describe 'guest user' do
    it 'rejects requests for new product form' do
      get new_product_path
      must_respond_with :redirect
    end

    it 'rejects requests to create a product' do
      product_data = products(:cheesecake)

      old_count = Product.count

      # Assumptions
      product_data.must_be :valid?

      # Act
      post products_path, params: { product: product_data }

      must_respond_with :redirect
      Product.count.must_equal old_count
    end

    it 'rejectes requests for the edit form' do
      get edit_product_path(Product.first.id)
      must_respond_with :redirect
    end

    it 'rejects requests to update a product' do
      product = Product.first
      product_data = product.attributes
      product_data[:name] = "some updated name"

      # Assumptions
      product.assign_attributes(product_data)
      product.must_be :valid?

      # Act
      patch product_path(product), params: {product: product_data}

      must_respond_with :unauthorized
    end

    it 'rejects requests to retire a product' do
      product = Product.first
      product_data = product.attributes

      product.assign_attributes(product_data)
      product.must_be :valid?

      patch retire_path(product), params: {product: product_data}

      must_respond_with :redirect
      flash[:status].must_equal :failure
    end
  end

  describe 'by_name' do
    it 'can find a product by name' do
      skip
    end

    it 'will respond with Not Found, if the name does not exsist' do
      skip
    end
  end
end

# TODO: Tests for the following methods: new, create, edit, update. product_params, find_products
