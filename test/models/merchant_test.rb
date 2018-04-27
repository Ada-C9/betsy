require "test_helper"

describe Merchant do
  describe 'validations' do
    before do
      @merchant = Merchant.new(username: 'dan', email: 'dan@alibonbon.com')
    end

    it 'can be created with all required fields' do
      result = @merchant.valid?

      result.must_equal true
    end

    it 'is invalid without a username' do
      @merchant.username = nil

      result = @merchant.valid?

      result.must_equal false
    end

    it 'is invalid without an email' do
      @merchant.email = nil

      result = @merchant.valid?

      result.must_equal false
    end

    it 'is invalid with a duplicate username' do
      existing_merchant = Merchant.first
      @merchant.username = existing_merchant.username

      result = @merchant.valid?

      result.must_equal false
    end

    it 'is invalid with a duplicate email' do
      existing_merchant = Merchant.first
      @merchant.email = existing_merchant.email

      result = @merchant.valid?

      result.must_equal false
    end
  end


  describe 'relations' do
    it 'has many products' do
      merchant = merchants(:wini)
      product = Product.create!(name: 'key lime pie', price: 399, merchant: merchant)

      merchant.products.must_include product
      merchant.product_ids.must_include product.id
    end
  end

  describe 'show_four' do
    it 'shows first four products of the merchant' do
      merchant = Merchant.first
      product1 = {
        name: 'product1',
        price: 233,
        merchant: merchant
      }
      product2 = {
        name: 'product2',
        price: 233,
        merchant: merchant
      }
      product3 = {
        name: 'product3',
        price: 233,
        merchant: merchant
      }
      product4 = {
        name: 'product4',
        price: 233,
        merchant: merchant
      }
      product5 = {
        name: 'product5',
        price: 233,
        merchant: merchant
      }
      new_products = [product1, product2, product3, product4, product5]
      new_products.each do |pro|
        Product.create(pro)
      end

      result = merchant.show_four
      result.count.must_equal 4
      result.wont_include product5
    end

    it "returns all products if there is four or less than four products in the merchant" do
      merchant = Merchant.first
      product1 = {
        name: 'product1',
        price: 233,
        merchant: merchant
      }
      product2 = {
        name: 'product2',
        price: 233,
        merchant: merchant
      }
      product3 = {
        name: 'product3',
        price: 233,
        merchant: merchant
      }

      new_products = [product1, product2, product3]
      new_products.each do |pro|
        merchant.products << Product.create(pro)
      end

      result = merchant.show_four

      result.count.must_equal 3
      result[0].name.must_equal product1[:name]
      result[0].price.must_equal product1[:price]
    end
  end

  describe "build_from_github" do
  end

  describe "visible_products" do
    before do
      @merchant1 = Merchant.first
      product1 = {
        name: 'product1',
        price: 233,
        merchant: @merchant1,
        visible: true
      }
      product2 = {
        name: 'product2',
        price: 233,
        merchant: @merchant1,
        visible: false
      }
      product3 = {
        name: 'product3',
        price: 233,
        merchant: @merchant1,
        visible: true
      }

      new_products = [product1, product2, product3]
      new_products.each do |prod|
        @merchant1.products << Product.create(prod)
      end
    end

    it "should show the correct quantity of visible products" do

      @merchant1.visible_products.count.must_equal 2

    end

    it "should return 0 when no visible products" do
      @merchant1.products.each do |prod|
        prod.visible = false
      end

      @merchant1.visible_products.count.must_equal 0
    end
  end

  describe "invisible_products" do
    before do
      @merchant1 = Merchant.first
      product1 = {
        name: 'product1',
        price: 233,
        merchant: @merchant1,
        visible: true
      }
      product2 = {
        name: 'product2',
        price: 233,
        merchant: @merchant1,
        visible: false
      }
      product3 = {
        name: 'product3',
        price: 233,
        merchant: @merchant1,
        visible: true
      }

      new_products = [product1, product2, product3]
      new_products.each do |prod|
        @merchant1.products << Product.create(prod)
      end
    end

    it "should show the correct quantity of invisible products" do

      @merchant1.invisible_products.count.must_equal 1

    end

    it "should return 0 when no visible products" do
      @merchant1.products.each do |prod|
        prod.visible = true
      end

      @merchant1.invisible_products.count.must_equal 0
    end
  end

  describe "my_cartitems" do
    before do
      @merchant1 = Merchant.first
      product1 = {
        name: 'product1',
        price: 233,
        merchant: @merchant1,
      }
      product2 = {
        name: 'product2',
        price: 233,
        merchant: @merchant1,
      }

      new_products = [product1, product2]
      new_products.each do |prod|
        @merchant1.products << Product.create(prod)
      end
    end

    it "should return all the cartitems that exit that are my products" do
      cartitem1 = Cartitem.create(product_id: @merchant1.products.first.id, cart_id: Cart.first.id, quantity: 2)
      cartitem2 = Cartitem.create(product_id: @merchant1.products.last.id, cart_id: Cart.first.id, quantity: 1)
      cartitem3 = Cartitem.create(product_id: @merchant1.products.first.id, cart_id: Cart.last.id, quantity: 3)

      @merchant1.my_cartitems.count.must_equal 3
    end

    it "should return 0 when no cartitems that have my products" do
      cartitem1 = Cartitem.create(product_id: Product.last.id + 1, cart_id: Cart.first.id, quantity: 2)
      cartitem2 = Cartitem.create(product_id: Product.last.id + 2, cart_id: Cart.first.id, quantity: 1)
      cartitem3 = Cartitem.create(product_id: Product.last.id + 3, cart_id: Cart.last.id, quantity: 3)

      @merchant1.my_cartitems.count.must_equal 0
    end
  end

  describe "my_carts" do
    before do
      @merchant1 = Merchant.first
      product1 = {
        name: 'product1',
        price: 233,
        merchant: @merchant1,
      }
      product2 = {
        name: 'product2',
        price: 233,
        merchant: @merchant1,
      }

      new_products = [product1, product2]
      new_products.each do |prod|
        @merchant1.products << Product.create(prod)
      end
    end

    it "should return all the carts that have at least one product one time" do
      cartitem1 = Cartitem.create(product_id: @merchant1.products.first.id, cart_id: Cart.first.id, quantity: 2)
      cartitem2 = Cartitem.create(product_id: @merchant1.products.last.id, cart_id: Cart.first.id, quantity: 1)
      cartitem3 = Cartitem.create(product_id: @merchant1.products.first.id, cart_id: Cart.last.id, quantity: 3)

      @merchant1.my_carts.count.must_equal 2

    end

    it "should return an empty array when no cart have my items" do
      cartitem1 = Cartitem.create(product_id: Product.last.id + 1, cart_id: Cart.first.id, quantity: 2)
      cartitem2 = Cartitem.create(product_id: Product.last.id + 2, cart_id: Cart.first.id, quantity: 1)
      cartitem3 = Cartitem.create(product_id: Product.last.id + 3, cart_id: Cart.last.id, quantity: 3)

      @merchant1.my_carts.count.must_equal 0
    end


    describe "my_orders" do
      before do
        @merchant1 = Merchant.first
        product1 = {
          name: 'product1',
          price: 233,
          merchant: @merchant1,
        }
        product2 = {
          name: 'product2',
          price: 233,
          merchant: @merchant1,
        }

        new_products = [product1, product2]
        new_products.each do |prod|
          @merchant1.products << Product.create(prod)
        end
        @cart1 = Cart.create
        @cart2 = Cart.create

        cartitem1 = Cartitem.create(product_id: @merchant1.products.first.id, cart_id: @cart1.id, quantity: 2)
        cartitem2 = Cartitem.create(product_id: @merchant1.products.last.id, cart_id: @cart2.id, quantity: 1)
        cartitem3 = Cartitem.create(product_id: @merchant1.products.first.id, cart_id: @cart2.id, quantity: 3)

      end

      it "should return every order that has one of your products" do
        order1 = Order.create(cart_id: @cart1.id, status: "pending")
      
        @merchant1.my_orders.count.must_equal 1
      end


    end

    describe "my_total_revenue" do
      it "should return 0 when there are no orders for merchant" do
        merchant = Merchant.first

        merchant.my_total_revenue.must_be_kind_of Integer
        merchant.my_total_revenue.must_equal 0
      end

      it "should return the sum of all your products in different orders" do
      end
    end
  end
end
