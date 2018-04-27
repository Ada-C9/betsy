require "test_helper"

describe ProductsController do
  describe "authenticated user" do
    before do
      login(User.first)
    end

    describe 'root' do
      it 'should get root path' do
        get root_path
        must_respond_with :success
      end
    end # ends 'describe 'root' do'

    describe 'products index' do
      it 'should get the products index' do
        get products_path
        must_respond_with :success
      end

      it 'sends a success response when there is more than one product' do
        # Assumptions
        Product.count.must_be :>, 0

        # Act
        get products_path

        # Assert
        must_respond_with :success
      end

      it 'sends a success response when there are no products' do
        # Arrange
        Product.destroy_all

        # Act
        get products_path

        # Assert
        must_respond_with :success
      end

      it "should get a user's product index" do
        get user_products_path()
        must_respond_with :success
      end

      it 'should render 404 if user_id does not exist' do
        get user_products_path()
        must_respond_with :success
      end

      it 'should get search results' do
        get products_path, params: {search: "aspirin"}
        must_respond_with :success
      end
    end # ends 'describe 'index' do'

    describe 'new' do
      it 'responds with success' do
        get new_product_path
        must_respond_with :success
      end
    end # ends describe 'new' do

    describe 'create' do
      it 'can add a valid product' do
        # Arrange
        product_data = {
          name: 'controller test product',
          user_id: User.first.id
        }
        old_product_count = Product.count

        # Assumptions
        Product.new(product_data).must_be :valid?

        # Act
        post products_path, params: { product: product_data }

        # Assert
        must_respond_with :redirect
        must_redirect_to products_path

        Product.count.must_equal old_product_count + 1
        Product.last.name.must_equal product_data[:name]
      end

      it "won't add an invalid product" do
        # Arrange
        product_data = {
          name: '',
        }
        old_product_count = Product.count

        # Assumptions
        Product.new(product_data).wont_be :valid?

        # Act
        post products_path, params: { product: product_data }
        # Assert
        must_respond_with :bad_request
        Product.count.must_equal old_product_count
      end

    end # ends describe 'create' do

  describe 'guest user' do
    describe 'root' do
      it 'should get root path' do
        get root_path
        must_respond_with :success
      end
    end # ends 'describe 'root' do'

    describe 'products index' do
      it 'should get the products index' do
        get products_path
        must_respond_with :success
      end
    end
  end


  end # ends 'describe "authenticated user" do'
end # ends 'describe ProductsController do'
