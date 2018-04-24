require "test_helper"

describe Order do
  describe 'validations' do
    before do
      @order = Order.new(
        cart: carts(:cart_one),
        name: 'Drew',
        email: 'drew@somthingcool.com',
        creditcard: '1234123412341234',
        expiration_month: Date.parse('8/10/18'),
        expiration_year: Date.parse('8/10/18'),
        name_on_card: 'Drew Crisanti',
        cvv: '123',
        mail_address: '123 Main Street, Small Town, USA',
        billing_address: '123 Main Street, Small Town, USA',
        status: 'completed',
        zipcode: '11111')
    end

    it 'can be created with all required fields when status is pending' do
      order = Order.new(cart: carts(:cart_two), status: 'pending')

      result = order.valid?

      result.must_equal true
    end

    it 'can be created with all required fields when status is not pending' do
      result = @order.valid?

      result.must_equal true
    end

    it 'is invalid when name is missing and status is not pending' do
      @order.name = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when email is missing and status is not pending' do
      @order.email = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when credit card is missing and status is not pending' do
      @order.creditcard = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when credit card is not 16 characters and status is not pending' do
      @order.creditcard = '12341234'

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when expiration month is missing and status is not pending' do
      @order.expiration_month = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when expiration year is missing and status is not pending' do
      @order.expiration_year = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when name on card is missing and status is not pending' do
      @order.name_on_card = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when cvv is missing and status is not pending' do
      @order.cvv = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when cvv is less than three characters and status is not pending' do
      @order.cvv = '12'

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when cvv is more than four characters and status is not pending' do
      @order.cvv = '12345'

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when mail address is missing and status is not pending' do
      @order.mail_address = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when billing address is missing and status is not pending' do
      @order.billing_address = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when status is missing and status is not pending' do
      @order.status = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when zip code is missing and status is not pending' do
      @order.zipcode = nil

      result = @order.valid?

      result.must_equal false
    end
  end

  describe 'relations' do
    it 'connects to cart and cart_id' do
      order = orders(:order_one)
      order.cart.must_equal carts(:cart_one)
      order.cart_id.must_equal carts(:cart_one).id
    end

    it 'can set a cart' do
      order = Order.new(
        name: 'Drew',
        email: 'drew@somthingcool.com',
        creditcard: '1234123412341234',
        expiration_month: Date.parse('8/10/18'),
        expiration_year: Date.parse('8/10/18'),
        name_on_card: 'Drew Crisanti',
        cvv: '123',
        mail_address: '123 Main Street, Small Town, USA',
        billing_address: '123 Main Street, Small Town, USA',
        status: 'pending',
        zipcode: '11111')
      order.cart = carts(:cart_two)

      order.cart_id.must_equal carts(:cart_two).id
    end
  end

  describe "is_pending method" do
    it "returns false if status is not pending" do
      order = orders(:order_one)
      result = order.is_pending
      result.must_equal false
    end

    it "returns false if status is not pending" do
      order = orders(:order_two)
      result = order.is_pending
      result.must_equal true
    end
  end

  describe "order_tax method" do
    it "calculates the tax for items in an order" do
      order = orders(:order_one)
      result = order.order_tax
      result.must_equal 231.4
    end

    it "returns 0 if there are no items in the order" do
      order = Order.first
      order_items = Cartitem.where(cart_id: order.cart_id)
      order_items.destroy_all
      result = order.order_tax
      result.must_equal 0
    end
  end

  describe "total_cost method" do
    it "calculates the total cost for items in an order" do
      order = orders(:order_one)
      result = order.total
      result.must_equal 2545.4
    end

    it "returns 0 if there are no items in the order" do
      order = Order.first
      order_items = Cartitem.where(cart_id: order.cart_id)
      order_items.destroy_all
      result = order.total
      result.must_equal 0
    end
  end
end
