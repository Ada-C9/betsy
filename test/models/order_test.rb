require "test_helper"

describe Order do
  let(:order) { Order.new address: "123, Fake address", card_name: "A name", cc_number: "1234567891234567", cc_expiration: Date.new(2001,2) , cvv: "123", zip_code: "98005", email: "email@test.com", merchant_id: merchants(:lucy).id, status: "open"  }

  describe 'validations' do
    it "must be valid" do
      order.must_be :valid?
    end

    # it 'must have a address' do
    #   order.address = nil
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :address
    # end
    #
    # it 'must have an address with length more than 0 characters' do
    #   order.address = ""
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :address
    # end
    #
    # it ' cannot have an address with length more than 35' do
    #   order.address = "123451234512345123451234512345123451"
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :address
    # end
    #
    # it 'must have a card name' do
    #   order.card_name = nil
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :card_name
    # end
    #
    # it 'must have a card name with more than 0 characters' do
    #   order.card_name = ""
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :card_name
    # end
    #
    # it 'must have a card number' do
    #   order.cc_number = nil
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :cc_number
    # end
    #
    # it 'must have a card expiration' do
    #   order.cc_expiration = nil
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :cc_expiration
    # end
    #
    # it 'card expiration must be a date' do
    #   order.cc_expiration = "a string"
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :cc_expiration
    # end
    #
    # it 'must have a cvv' do
    #   order.cvv = nil
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :cvv
    # end
    #
    # it "must have a length of three characters" do
    #   order.cvv = "cvvv"
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :cvv
    # end
    #
    # it 'must have a zipcode' do
    #   order.zip_code = nil
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :zip_code
    # end
    #
    # it "zipcode length must be 5 " do
    #   order.zip_code = "980756"
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :zip_code
    # end
    #
    # it 'must have a email' do
    #   order.email = nil
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :email
    # end
    #
    # it "must have a valid email format" do
    #   order.email = "12345@.email.com"
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :email
    # end
    #
    # it "must have a unique email id" do
    #   order.email = "some_person@testing.com"
    #
    #   order.valid?.must_equal false
    #   order.errors.must_include :email
    # end
  end

  describe "relations" do
    it "has a list of orderproducts" do

      order.must_respond_to :orderproducts

      order.orderproducts.each do |orderproduct|
        orderproduct.must_be_kind_of Orderproduct
      end
    end
  end

  describe "cancel_order" do
    it "changes the status of a 'paid' order to 'canceled'" do
      order.status = "paid"
      order.save
      assert order.status == "paid"

      order.cancel_order.must_equal true
      order.status.must_equal "canceled"
    end
    it "does not changed the status of an order if it is already canceled" do
      order.status = "canceled"
      order.save
      assert order.status == "canceled"

      order.cancel_order.must_equal true
      order.status.must_equal "canceled"
    end
  end

  describe "total" do
    it "calculates the total of an order" do
      order.save

      Orderproduct.create(quantity: 1, product_id: products(:candy).id, order_id: order.id)
      Orderproduct.create(quantity: 1, product_id: products(:cake).id, order_id: order.id)

      order.total.must_be_kind_of Integer
      order.total.must_equal (products(:candy).price + products(:cake).price)
    end

    it "returns zero if order has no products" do
      Orderproduct.destroy_all
      assert Orderproduct.all.empty?
      order.save

      order.total.must_be_kind_of Integer
      order.total.must_equal  0
    end
  end

end
