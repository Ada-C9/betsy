require "test_helper"

describe Order do
  let(:order) { Order.new }
  let(:o) { orders(:order_2) } #status complete
  let(:o1) { orders(:order_1) } #staus pending

  describe "relations" do
    it "has a list of orderitems" do
      o.order_items.each do |item|
        item.must_be_instance_of OrderItem
        item.order.must_be_instance_of Order
        item.order.must_equal o
      end
    end
  end

  describe "validations" do
    it "has validation for empty parameters" do
      order.valid?.must_equal false
    end

    it "has validation for status presence" do
      o.status = nil
      o.valid?.must_equal false
      o.errors.messages.must_include :status

      o.status = ""
      o.valid?.must_equal false
      o.errors.messages.must_include :status
    end

    it "has validation for name presence" do
      o.name = nil
      o.valid?.must_equal false
      o.errors.messages.must_include :name

      o.name = ""
      o.valid?.must_equal false
      o.errors.messages.must_include :name
    end

    it "has validation for name length" do
      o.name = "ni"
      o.valid?.must_equal false
      o.errors.messages.must_include :name
    end

    it "has validation for email presence" do
      o.email = nil
      o.valid?.must_equal false
      o.errors.messages.must_include :email

      o.email = ""
      o.valid?.must_equal false
      o.errors.messages.must_include :email
    end

    it "has validation for email format" do
      o.email = "bademail@exmple_nodot"
      o.valid?.must_equal false
      o.errors.messages.must_include :email
    end

    it "has validation for street_address presence" do
      o.street_address = nil
      o.valid?.must_equal false
      o.errors.messages.must_include :street_address

      o.street_address = ""
      o.valid?.must_equal false
      o.errors.messages.must_include :street_address
    end

    it "has validation for city presence" do
      o.city = nil
      o.valid?.must_equal false
      o.errors.messages.must_include :city

      o.city = ""
      o.valid?.must_equal false
      o.errors.messages.must_include :city
    end

    it "has validation for state presence" do
      o.state = nil
      o.valid?.must_equal false
      o.errors.messages.must_include :state

      o.state = ""
      o.valid?.must_equal false
      o.errors.messages.must_include :state
    end

    it "has validation for zip presence" do
      o.zip = nil
      o.valid?.must_equal false
      o.errors.messages.must_include :zip

      o.zip = ""
      o.valid?.must_equal false
      o.errors.messages.must_include :zip
    end

    it "has validation for zip length" do
      [12, 1, 123456].each {|element|
        o.zip = element
        o.valid?.must_equal false
      }
    end

    it "has validation for name_cc presence" do
      o.name_cc = nil
      o.valid?.must_equal false
      o.errors.messages.must_include :name_cc

      o.name_cc = ""
      o.valid?.must_equal false
      o.errors.messages.must_include :name_cc
    end

    it "has validation for credit_card presence" do
      o.credit_card = nil
      o.valid?.must_equal false
      o.errors.messages.must_include :credit_card

      o.credit_card = ""
      o.valid?.must_equal false
      o.errors.messages.must_include :credit_card
    end

    it "has validation for credit_card length" do
      [1234567890113, 12345678901112131420].each {|element|
        o.credit_card = element
        o.valid?.must_equal false
      }
    end

    it "has validation for expiry presence" do
      o.expiry = nil
      o.valid?.must_equal false
      o.errors.messages.must_include :expiry

      o.expiry = ""
      o.valid?.must_equal false
      o.errors.messages.must_include :expiry
    end

    it "has validation for ccv presence" do
      o.ccv = nil
      o.valid?.must_equal false
      o.errors.messages.must_include :ccv

      o.ccv = ""
      o.valid?.must_equal false
      o.errors.messages.must_include :ccv
    end

    it "has validation for ccv length" do
      [12, 1, 12345].each {|element|
        o.ccv = element
        o.valid?.must_equal false
      }
    end
    it "has validation for billing_zip presence" do
      o.billing_zip = nil
      o.valid?.must_equal false
      o.errors.messages.must_include :billing_zip

      o.billing_zip = ""
      o.valid?.must_equal false
      o.errors.messages.must_include :billing_zip
    end

    it "has validation for billing_zip length" do
      [12, 1, 123456].each {|element|
        o.billing_zip = element
        o.valid?.must_equal false
      }
    end

    it "validates credit card expiry cannot be in the past" do
      o.expiry = Date.parse("2017-12-31")
      o.valid?.must_equal false
      o.errors.messages.must_include :expiry
    end

    it "has no validation when items are in cart mean status pending" do
      o.name = ""
      o.state = nil
      o.billing_zip = ""
      o1.valid?.must_equal true
    end

    it "must be valid" do
      o.valid?.must_equal true
    end
  end

  describe "methods" do
    it "computes total cost" do
      o.total_cost.must_equal 0.13
    end

    it "computes last 4 digits of credit card" do
      o.credit_card_last_digits.must_equal "2222"
      o1.credit_card_last_digits.must_equal "1111"
    end

    it "can cancel" do
      o1.status = "paid"
      o1.can_cancel?.must_equal true
    end

  end
end
