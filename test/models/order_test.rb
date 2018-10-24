require "test_helper"
describe Order do

  describe "validations" do
    before do
      @order = orders(:one)
    end

    it "can be created with all required fields" do
      result = @order.valid?
      result.must_equal true
    end

    it "can be created without all fields" do
      #set all to nil
      order = Order.new
      result = @order.valid?

      result.must_equal true
    end

    it 'can create a purchase with all valid fields' do
      result = @order.save(context: :purchase)
      result.must_equal true
    end

    it "cannot be purchased without all valid fields" do
      #take out email and zipcode
      @order.cvv = nil
      @order.name = nil
      result = @order.save(context: :purchase)
      result.must_equal false
    end

    it "cannot be purchased with invalid cc number" do
      @order.cvv = '123412341234123412341'
      result = @order.save(context: :purchase)
      result.must_equal false
    end

    it 'cannot be purchased if cc expiration date is invalid' do
      @order.ccexpiration = Date.today + (6*365)
      result = @order.save(context: :purchase)
      result.must_equal false
    end

    it 'cannot be purchased if cvv is invalid' do
      @order.cvv = '58690000'
      result = @order.save(context: :purchase)
      result.must_equal false
    end
  end

  describe "relations" do
    before do
      @order = Order.first
    end

    it "connects order and cart_item" do
      cart_item = Cartitem.create!(order: @order, product: Product.first, quantity: 3)
      @order.cartitem_ids.must_include cart_item.id
      end
  end

  describe "#complete_checkout" do
    before do
      @order = Order.first
    end

    it "updates state to paid" do
      @order.complete_checkout

      @order.reload
      @order.state.must_equal "paid"
    end

    it "updates cartitem stock" do
      product = Product.first
      original_stock = product.stock
      Cartitem.create!(order: @order, product: product, quantity: 3)

      @order.complete_checkout
      product.reload
      product.stock.must_equal original_stock - 3
    end

  end

  describe "#filter_by" do

    it "returns array of items that belong to user" do
      user = User.first
      product1 = Product.create(name: "testing", stock: 14, price: 4.56, user: user)
      product2 = Product.create(name: "testing2", stock: 9, price: 100.99, user: user)
      product3 = Product.create(name: "testing3", stock: 100, price: 78, user: user)

      order = Order.create!

      Cartitem.create!(order: order, product: product1, quantity: 3)
      Cartitem.create!(order: order, product: product2, quantity: 5)
      Cartitem.create!(order: order, product: product3, quantity: 20)

      result = Order.filter_by(user.id)

      result.must_be_instance_of Array
      result.length.must_equal 3
    end

    it "returns empty array if user doesnt have any items" do
      user = User.create(name: "testing filter", email: "filter@testing.com")

      result = Order.filter_by(user.id)

      result.must_be_instance_of Array
      result.length.must_equal 0
    end

  end

  describe "#total" do
    it "returns sum of total in an order" do
      order = Order.create!
      product1 = Product.first
      product2 = Product.last

      Cartitem.create!(order: order, product: product1, quantity: 3)
      Cartitem.create!(order: order, product: product2, quantity: 7)

      expected_total = (product1.price * 3) + (product2.price * 7)

      result = order.total
      result.must_equal expected_total
    end

    it "returns 0 if order has no items" do
      order = Order.create!

      result = order.total
      result.must_equal 0

    end

  end

  describe "#cancel" do
    before do
      @order = Order.first
    end

    it "changes state of order to cancelled" do
      @order.cancel

      @order.reload
      @order.state.must_equal "cancelled"
    end

  end
end
