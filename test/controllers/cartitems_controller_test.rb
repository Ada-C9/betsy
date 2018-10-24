require "test_helper"

describe CartitemsController do
  describe 'index' do
    it 'sends a success reresponse when there are many cartitems' do
      Cartitem.count.must_be :>, 0

      get cart_path

      must_respond_with :success
    end

    it 'sends a success response when there are no cartitems' do
      Cartitem.destroy_all

      get cart_path

      must_respond_with :success
    end

  end

  describe 'create' do
    #method was written and you're not using it anywhere
    #cartitems are entities that created by another action, create is not being used and shouldn't be in the code
    it 'it can create a valid cartitem' do
      # Arrange

      a = Product.find_by(name: 'chew toy')
      id = a.id
      cartitem_data = {
        quantity: 1,
        product_id: id,
        order_id: Order.first.id
      }
      old_cartitem_count = Cartitem.count


      # Act
      post product_cartitems_path(id), params: { cartitem: cartitem_data }
      #
      # # Assert
      must_respond_with :redirect
      must_redirect_to cart_path
      #
      Cartitem.count.must_equal old_cartitem_count + 1
      # Book.last.title.must_equal book_data[:title]
    end

  end
  describe 'update' do
    it "updates a quantity in cartitem from cart page" do
      a = Product.find_by(name: 'chew toy')
      id = a.id
      cartitem_data = {
        quantity: 1,
        product_id: id,
        order_id: Order.first.id
      }
      cart =  Cartitem.create!(cartitem_data)

      # Act
      patch update_cartitem_path(cart), params: { cartitem: {quantity: 2}}
      cart.reload
      # Assert

      must_respond_with :redirect
      must_redirect_to cart_path
      # #
      cart.quantity.must_equal  2

    end

    it "updates quantity of product from product page, when product already exists in cart" do
      a = Product.find_by(name: 'chew toy')
     get cart_path

      product_id = a.id

      post product_cartitems_path(product_id), params: { cartitem: {quantity: 2}}

      post product_cartitems_path(product_id), params: { cartitem: {quantity: 2}}
       b = Cartitem.last

      b.quantity.must_equal 4
      #call get path so that a session is set and then update the quantity, first loggin in by creating a cart
      #add 1 quantity to a cart exists with a quantity and then we add the same product again
    end
  end

  describe 'delete' do

    it "deletes a cartitem" do

      order = Order.create!
      product = Product.create!(
        name: 'test-test-product',
        price: 44,
        stock: 4,
        user: User.first
      )

      b = Cartitem.create!(quantity: 3, order: order, product: product)


      old_count = Cartitem.count

      delete delete_cartitem_path(b)

      must_respond_with :redirect
      must_redirect_to cart_path

      Cartitem.count.must_equal old_count - 1
    end

  end

  describe 'ship' do
    it "responds with redirect if item exists" do
      cartitem = Cartitem.create!(order: Order.first, product: Product.first, quantity: 3)
      patch ship_path(cartitem)
      must_respond_with :redirect
    end

    it "responds with not found if item doesnt exist" do
      cartitem_id = Cartitem.last.id + 1
      patch ship_path(cartitem_id)
      must_respond_with :not_found
    end
  end
end
