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

  describe "subtotal method" do
    it "calculates subtotal for all items in the cart" do
      cart = carts(:cart_one)
      result = cart.subtotal
      result.must_equal 2314
    end

    it "returns 0 if there are no items in the cart" do
      cart = Cart.first
      cart.cartitems.destroy_all
      cart.cartitems.count.must_equal 0
      cart.subtotal.must_equal 0
    end
  end

  describe "total_items method" do
    it "calculates the total items in the cart" do
      cart = carts(:cart_one)
      result = cart.total_items
      result.must_equal 6
    end

    it "returns 0 if there are no items in the cart" do
      cart = Cart.first
      cart.cartitems.destroy_all
      result = cart.total_items
      result.must_equal 0
    end
  end

  describe "tax method" do
    it "calculates the tax for items in a cart" do
      cart = carts(:cart_one)
      result = cart.tax
      result.must_equal 231.4
    end

    it "returns 0 if there are no items in the cart" do
      cart = Cart.first
      cart.cartitems.destroy_all
      result = cart.tax
      result.must_equal 0
    end
  end

  describe "total_cost method" do
    it "calculates the total cost for items in a cart" do
      cart = carts(:cart_one)
      result = cart.total_cost
      result.must_equal 2545.4
    end

    it "returns 0 if there are no items in the cart" do
      cart = Cart.first
      cart.cartitems.destroy_all
      result = cart.total_cost
      result.must_equal 0
    end
  end
end
