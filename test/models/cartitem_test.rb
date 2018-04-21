require "test_helper"

describe Cartitem do
  describe 'validations' do
    before do
      @cartitem = Cartitem.new(product: Product.first, cart: Cart.first, quantity: 1)
    end

    it 'can be created with all required fields' do
      result = @cartitem.valid?

      result.must_equal true
    end

    it 'is invalid without a product' do
      @cartitem.product = nil

      result = @cartitem.valid?

      result.must_equal false
    end

    it 'is invalid without a cart' do
      @cartitem.cart = nil

      result = @cartitem.valid?

      result.must_equal false
    end

    it 'is invalid without a quantity' do
      @cartitem.quantity = nil

      result = @cartitem.valid?

      result.must_equal false
    end

    it 'is invalid if quantity is not an integer' do
      @cartitem.quantity = 3.5

      result = @cartitem.valid?

      result.must_equal false
    end

    it 'is invalid if quantity is less than 1' do
      @cartitem.quantity = 0

      result = @cartitem.valid?

      result.must_equal false
    end      
  end

  describe 'relations' do
    it 'connects to products and product_ids' do
      cartitem = cartitems(:item_three)
      cartitem.product.must_equal products(:macaron)
      cartitem.product_id.must_equal products(:macaron).id
    end

    it 'connects to carts and cart_ids' do
      cartitem = cartitems(:item_one)
      cartitem.cart.must_equal carts(:cart_one)
      cartitem.cart_id.must_equal carts(:cart_one).id
    end
  end

  describe "subtotal" do
    it "calculates the subtotal for cartitem" do
      cartitem1 = Cartitem.first
      result = cartitem1.subtotal
      result.must_equal 13.16
    end
  end

  describe "subtotal" do
    it "calculates the subtotal for cartitem" do
      cartitem1 = Cartitem.first
      result = cartitem1.subtotal
      result.must_equal 13.16
    end
  end
end
