require "test_helper"

describe Order do
  before do
    @order = Order.new(
      cart: carts(:my_cart),
      name: 'Drew',
      email: 'drew@somthingcool.com',
      creditcard: '1234123412341234',
      expiration_date: 'August 2022',
      name_on_card: 'Drew Crisanti',
      cvv: 123,
      mail_address: '123 Main Street, Small Town, USA',
      billing_address: '123 Main Street, Small Town, USA',
      status: 'pending',
      zipcode: '11111')
  end

  it 'can be created with the required fields' do
    result = @order.valid?

    result.must_equal true
  end


end
