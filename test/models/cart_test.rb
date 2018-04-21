require "test_helper"

describe Cart do
  describe 'validations' do
    it 'can be created without any fields' do
      cart = Cart.new

      result = cart.valid?

      result.must_equal true
    end
  end

  describe 'relations' do
    before do
      @cart = Cart.create!
    end

    it 'connects to cartitems and cartitem_ids' do
      cartitem = Cartitem.create!(product: Product.first, cart: @cart, quantity: 2)

      @cart.cartitems.must_include cartitem
      @cart.cartitem_ids.must_include cartitem.id
    end

    it 'connects to products and product_ids through cartitems' do
      product = Product.create!(name: 'key lime pie', price: 399, merchant: Merchant.first)
      cartitem = Cartitem.create!(product: product, cart: @cart, quantity: 2)

      @cart.products.must_include product
      @cart.product_ids.must_include product.id
    end

    it 'connects to order and order_id' do
      cart = carts(:cart_one)
      cart.order.must_equal orders(:order_one)
    end
  end
end
