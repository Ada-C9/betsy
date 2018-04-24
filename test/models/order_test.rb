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
        status: 'pending',
        zipcode: '11111')
    end

    it 'can be created with the required fields' do
      result = @order.valid?

      result.must_equal true
    end

    it 'is invalid when name is missing' do
      @order.name = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when email is missing' do
      @order.email = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when credit card is missing' do
      @order.creditcard = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when credit card is not 16 characters' do
      @order.creditcard = '12341234'

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when expiration month is missing' do
      @order.expiration_month = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when expiration year is missing' do
      @order.expiration_year = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when name on card is missing' do
      @order.name_on_card = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when cvv is missing' do
      @order.cvv = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when cvv is less than three characters' do
      @order.cvv = '12'

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when cvv is more than four characters' do
      @order.cvv = '12345'

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when mail address is missing' do
      @order.mail_address = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when billing address is missing' do
      @order.billing_address = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when status is missing' do
      @order.status = nil

      result = @order.valid?

      result.must_equal false
    end

    it 'is invalid when zip code is missing' do
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
end
