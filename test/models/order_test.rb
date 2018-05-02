require "test_helper"

# IMPORTANT! These tests may seem like overkill, but we choose to try out some
# complicated/new validation approaches and needed to make sure we were actually
# doing what we wanted.

describe Order do
  describe "valid" do
    let(:order) { orders(:user_mcuser_order) }

    it "must be valid if complete when not pending" do
      order.must_be :valid? # status is paid

      order.update(status: "cancelled")
      order.must_be :valid?

      order.update(status: "complete")
      order.must_be :valid?
    end

    it "must be valid if only provided pending status" do
      Order.create(status: "pending").must_be :valid?
    end

    it "must not be valid if only provided non-pending status" do
      Order.create(status: "paid").valid?.must_equal false
      Order.create(status: "cancelled").valid?.must_equal false
      Order.create(status: "complete").valid?.must_equal false
      Order.create(status: nil).valid?.must_equal false
      Order.create(status: "foo").valid?.must_equal false
    end

    # Valid customer_name ======================================================
    # -------------------------------------------------------------- NOT Pending
    it "must have at least one character in customer_name" do
      order.update(status: "paid")

      order.update(customer_name: "")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:customer_name]

      order.update(customer_name: "         ")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:customer_name]

      order.update(customer_name: nil)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:customer_name]
    end

    # ------------------------------------------------------------------ Pending
    it "customer name can only be valid or nil if pending" do

      order.update(status: "pending")

      order.update(customer_name: "")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:customer_name]

      order.update(customer_name: "         ")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:customer_name]

      order.update(customer_name: nil)
      order.valid?.must_equal true
      order.customer_name.must_be_nil

      order.update(customer_name: "foo")
      order.valid?.must_equal true
      order.customer_name.must_equal "foo"
    end

    # Valid street =============================================================
    # -------------------------------------------------------------- NOT Pending
    it "must have at least one character in street" do
      order.update(status: "paid")

      order.update(street: "")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:street]

      order.update(street: "         ")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:street]

      order.update(street: nil)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:street]
    end

    # ------------------------------------------------------------------ Pending
    it "street can only be valid or nil if pending" do
      order.update(status: "pending")

      order.update(street: "")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:street]

      order.update(street: "         ")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:street]

      order.update(street: nil)
      order.valid?.must_equal true
      order.street.must_be_nil

      order.update(street: "foo")
      order.valid?.must_equal true
      order.street.must_equal "foo"
    end

    # Valid city ===============================================================
    # -------------------------------------------------------------- NOT Pending
    it "must have at least one character in city" do
      order.update(status: "paid")

      order.update(city: "")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:city]

      order.update(city: "         ")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:city]

      order.update(city: nil)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:city]
    end

    # ------------------------------------------------------------------ Pending
    it "city can only be valid or nil if pending" do
      order.update(status: "pending")

      order.update(city: "")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:city]

      order.update(city: "         ")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:city]

      order.update(city: nil)
      order.valid?.must_equal true
      order.city.must_be_nil

      order.update(city: "foo")
      order.valid?.must_equal true
      order.city.must_equal "foo"
    end

    # Valid cc_name ============================================================
    # -------------------------------------------------------------- NOT Pending
    it "must have at least one character in cc_name" do
      order.update(status: "paid")

      order.update(cc_name: "")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_name]

      order.update(cc_name: "         ")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_name]

      order.update(cc_name: nil)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_name]
    end

    # ------------------------------------------------------------------ Pending
    it "cc_name can only be valid or nil if pending" do

      order.update(status: "pending")

      order.update(cc_name: "")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_name]

      order.update(cc_name: "         ")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_name]

      order.update(cc_name: nil)
      order.valid?.must_equal true
      order.cc_name.must_be_nil

      order.update(cc_name: "foo")
      order.valid?.must_equal true
      order.cc_name.must_equal "foo"
    end

    # Valid mailing zip ========================================================
    # -------------------------------------------------------------- NOT Pending
    it "must have String and 5 digits in mailing_zip" do
      order.update(status: "paid")

      order.update(mailing_zip: "     ")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:mailing_zip]

      order.update(mailing_zip: "123456")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:mailing_zip]

      order.update(mailing_zip: "1234")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:mailing_zip]

      # order.update(mailing_zip: 12345) # not a String
      # order.valid?.must_equal false
      # order.errors.messages.keys.must_equal [:mailing_zip]

      order.update(mailing_zip: nil)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:mailing_zip]

      order.update(mailing_zip: "12345")
      order.valid?.must_equal true
      order.mailing_zip.must_equal "12345"
    end

    # ------------------------------------------------------------------ Pending
    it "mailing_zip can only be valid or nil if pending" do
      order.update(status: "pending")

      order.update(mailing_zip: "     ")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:mailing_zip]

      order.update(mailing_zip: "123456")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:mailing_zip]

      order.update(mailing_zip: "1234")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:mailing_zip]

      order.update(mailing_zip: "1 234")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:mailing_zip]

      order.update(mailing_zip: "1 2345")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:mailing_zip]

      order.update(mailing_zip: nil)
      order.valid?.must_equal true
      order.mailing_zip.must_be_nil

      order.update(mailing_zip: "12345")
      order.valid?.must_equal true
      order.mailing_zip.must_equal "12345"
    end

    # Valid cc zip =============================================================
    # -------------------------------------------------------------- NOT Pending
    it "must have String and 5 digits in cc_zip" do
      order.update(status: "paid")

      order.update(cc_zip: "     ")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_zip]

      order.update(cc_zip: "123456")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_zip]

      order.update(cc_zip: "1234")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_zip]

      order.update(cc_zip: "1 234")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_zip]

      order.update(cc_zip: "1 2345")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_zip]

      order.update(cc_zip: nil)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_zip]

      order.update(cc_zip: "12345")
      order.valid?.must_equal true
      order.cc_zip.must_equal "12345"
    end

    # ------------------------------------------------------------------ Pending
    it "cc_zip can only be valid or nil if pending" do
      order.update(status: "pending")

      order.update(cc_zip: "     ")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_zip]

      order.update(cc_zip: "123456")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_zip]

      order.update(cc_zip: "1234")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_zip]

      order.update(cc_zip: "1 234")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_zip]

      order.update(cc_zip: "1 2345")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:cc_zip]

      order.update(cc_zip: nil)
      order.valid?.must_equal true
      order.cc_zip.must_be_nil

      order.update(cc_zip: "12345")
      order.valid?.must_equal true
      order.cc_zip.must_equal "12345"
    end

    # Valid email ==============================================================
    # -------------------------------------------------------------- NOT Pending
    it "must have '@' sign in email" do
      order.update(status: "paid")

      order.update(email_address: "")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:email_address]

      order.update(email_address: "helloworld")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:email_address]

      order.update(email_address: nil)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:email_address]

      order.update(email_address: "foo@bar")
      order.valid?.must_equal true
      order.email_address.must_equal "foo@bar"

      order.update(email_address: "@")
      order.valid?.must_equal true
      order.email_address.must_equal "@"
    end

    # ------------------------------------------------------------------ Pending
    it "email can only be valid or nil if pending" do
      order.update(status: "pending")

      order.update(email_address: "")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:email_address]

      order.update(email_address: "helloworld")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:email_address]

      order.update(email_address: nil)
      order.valid?.must_equal true
      order.email_address.must_be_nil

      order.update(email_address: "foo@bar")
      order.valid?.must_equal true
      order.email_address.must_equal "foo@bar"

      order.update(email_address: "@")
      order.valid?.must_equal true
      order.email_address.must_equal "@"
    end

    # Valid cc_number ==========================================================
    # -------------------------------------------------------------- NOT Pending
    it "must have 16 digits in cc_number" do
      order.update(status: "paid")

      order.update(cc_number: 123456789012345)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_number]

      order.update(cc_number: 12345678901234567)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_number]

      order.update(cc_number: nil)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_number]

      order.update(cc_number: "hello, world")
      order.valid?.must_equal false

      order.update(cc_number: 1234567890123456)
      order.valid?.must_equal true
      order.cc_number.must_equal 1234567890123456
    end

    # ------------------------------------------------------------------ Pending
    it "cc_number can only be valid or nil if pending" do
      order.update(status: "pending")

      order.update(cc_number: 123456789012345)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_number]

      order.update(cc_number: 12345678901234567)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_number]

      order.update(cc_number: "hello, world")
      order.valid?.must_equal false

      order.update(cc_number: 1234567890123456)
      order.valid?.must_equal true
      order.cc_number.must_equal 1234567890123456

      order.update(cc_number: nil)
      order.valid?.must_equal true
      order.cc_number.must_be_nil
    end

    # Valid cc_cvv =============================================================
    # -------------------------------------------------------------- NOT Pending
    it "must have 3 digits String in cc_cvv" do
      order.update(status: "paid")

      order.update(cc_cvv: 1234)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_cvv]

      order.update(cc_cvv: 12)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_cvv]

      order.update(cc_cvv: nil)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_cvv]

      order.update(cc_cvv: "hello, world")
      order.valid?.must_equal false

      order.update(cc_cvv: "123")
      order.valid?.must_equal true
      order.cc_cvv.must_equal "123"

      order.update(cc_cvv: "000")
      order.valid?.must_equal true
      order.cc_cvv.must_equal "000"

    end

    # ------------------------------------------------------------------ Pending
    it "cc_cvv can only be valid or nil if pending" do
      order.update(status: "pending")

      order.update(cc_cvv: "1234")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_cvv]

      order.update(cc_cvv: "12")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_cvv]

      order.update(cc_cvv: "hello, world")
      order.valid?.must_equal false

      order.update(cc_cvv: "123")
      order.valid?.must_equal true
      order.cc_cvv.must_equal "123"

      order.update(cc_cvv: "000")
      order.valid?.must_equal true
      order.cc_cvv.must_equal "000"

      order.update(cc_cvv: nil)
      order.valid?.must_equal true
      order.cc_cvv.must_be_nil
    end

    # Valid cc_number ==========================================================
    # -------------------------------------------------------------- NOT Pending
    it "must have 16 digits in state" do
      order.update(status: "paid")

      order.update(state: "WAA")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:state]

      order.update(state: "W")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:state]

      order.update(state: "wa")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:state]

      order.update(state: nil)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:state]

      order.update(state: "WA")
      order.valid?.must_equal true
      order.state.must_equal "WA"
    end

    # ------------------------------------------------------------------ Pending
    it "state can only be valid or nil if pending" do
      order.update(status: "pending")
      order.update(state: "WAA")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:state]

      order.update(state: "W")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:state]

      order.update(state: "wa")
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:state]

      order.update(state: "WA")
      order.valid?.must_equal true
      order.state.must_equal "WA"

      order.update(state: nil)
      order.valid?.must_equal true
      order.state.must_be_nil
    end

    # Valid cc expiration ======================================================
    # -------------------------------------------------------------- NOT Pending
    it "must have valid expiration date in the future" do
      order.update(status: "paid")

      order.update(cc_exp_month: nil, cc_exp_year: nil)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_expiration]

      order.update(cc_exp_month: 12, cc_exp_year: nil)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_expiration]

      order.update(cc_exp_month: nil, cc_exp_year: 2050)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_expiration]

      order.update(cc_exp_month: Date.today.month - 1, cc_exp_year: Date.today.year)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_expiration]

      order.update(cc_exp_month: Date.today.month, cc_exp_year: Date.today.year)
      order.valid?.must_equal true

      order.update(cc_exp_month: Date.today.month + 1, cc_exp_year: Date.today.year)
      order.valid?.must_equal true

      order.update(cc_exp_month: Date.today.month - 1, cc_exp_year: Date.today.year + 1)
      order.valid?.must_equal true

      order.update(cc_exp_month: Date.today.month, cc_exp_year: Date.today.year + 1)
      order.valid?.must_equal true
    end

    # ------------------------------------------------------------------ Pending
    it "state can only be valid or nil if pending" do
      order.update(status: "pending")

      order.update(cc_exp_month: 12, cc_exp_year: nil)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_expiration]

      order.update(cc_exp_month: nil, cc_exp_year: 2050)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_expiration]

      order.update(cc_exp_month: Date.today.month - 1, cc_exp_year: Date.today.year)
      order.valid?.must_equal false
      order.errors.messages.keys.must_equal [:credit_card_expiration]

      order.update(cc_exp_month: Date.today.month, cc_exp_year: Date.today.year)
      order.valid?.must_equal true

      order.update(cc_exp_month: Date.today.month + 1, cc_exp_year: Date.today.year)
      order.valid?.must_equal true

      order.update(cc_exp_month: Date.today.month, cc_exp_year: Date.today.year + 1)
      order.valid?.must_equal true

      order.update(cc_exp_month: Date.today.month - 1, cc_exp_year: Date.today.year + 1)
      order.valid?.must_equal true

      order.update(cc_exp_month: nil, cc_exp_year: nil)
      order.valid?.must_equal true
    end

  end

  describe "relations" do
    let(:order) { orders(:user_mcuser_order) }
    let(:new_order_item) {
        OrderItem.new(quantity: 1, price: 6032, is_shipped: false, product: products(:ball))
    }
    let(:new_order) { Order.create(status: "pending") }

    it "responds to order_items" do
      # order = orders(:novelty)
      orders(:pending_order).must_respond_to :order_items
      orders(:pending_order).order_items.must_equal []
    end

    it "can have order_items" do
      # order = orders(:novelty)
      # new_order_item = OrderItem.new(quantity: 1, price: 6032, is_shipped: false, product: products(:ball))
      new_order.order_items << new_order_item

      new_order.order_items.must_equal [new_order_item]
    end

    it "must be added to order item's order" do
      order = orders(:mystring_order)
      order.order_items << new_order_item

      new_order_item.order.must_equal order
    end

    # it "can have multiple order_items" do
    #   # order = orders(:novelty)
    #   order.order_items << order_items(:ball)
    #   order.order_items << order_items(:icecream)
    #
    #   order.order_items.must_equal [order_items(:ball), order_items(:icecream)]
    # end
    #
    # it "can be initialized with order_items" do
    #   new_order = Order.create(name: "foo", order_items: [order_items(:ball), order_items(:icecream)])
    #   new_order.valid?.must_equal true
    # end

  # it "can be initialized with order_items" do
  #   # new_order = Order.create(name: "foo", order_items: [Date.today])
  #   # new_order.valid?.must_equal false
  #   new_order = Order.create(name: "foo")
  #   new_order.order_items << order_items(:icecream)
  #   new_order.add_product(Date.today)
  #
  #   new_order.order_items.must_equal [order_items(:icecream)]
  # end
  end
end
