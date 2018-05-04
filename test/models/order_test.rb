require "test_helper"

describe Order do
  let(:order) { Order.new }
  let(:order1) { orders(:order1) }

  describe "relations" do

    it "has a list of order_items" do
      order1.order_items.each do |item|
        item.must_be_instance_of OrderItem
        item.order.must_be_instance_of Order
        item.order.must_equal order1
      end
    end
  end

  describe "validations" do
    before do
      @order = Order.new(email: "rufo@petsy.com", mail_adr: "2615 233rd SE, Sammamish, WA",cc_name: "Rufino Woof", cc_num: "9875632147652345", cc_exp: "09/22", cc_cvv: "987",bill_zip: "98075", status: "paid")
    end


    it "must have a mailing address" do
      @order.mail_adr = nil
      @order.valid?.must_equal false
    end

    it "must have a name in the credit card information" do
      @order.cc_name = nil
      @order.valid?.must_equal false
      @order.cc_name = "Rufino Woof"
      @order.valid?.must_equal true
    end

    it "must have an email address" do
      @order.email.must_equal "rufo@petsy.com"
      @order.valid?.must_equal true
      @order.email = nil
      @order.valid?.must_equal false
    end

    it "must have a billing zip code number" do
      @order.bill_zip.must_equal "98075"
      @order.valid?.must_equal true

      [nil,"","wooof"].each do |num|
        @order.bill_zip = num
        @order.valid?.must_equal false
      end
    end


    it "must have a credit card number of 16 digits" do
      @order.cc_num.must_equal "9875632147652345"
      @order.valid?.must_equal true

      [nil,"45638","raaaa",""].each do |num|
        @order.cc_num = num
        @order.valid?.must_equal false
      end
    end

    it "must have an expiration date" do
      @order.cc_exp.must_equal "09/22"
      @order.valid?.must_equal true

      @order.cc_exp = nil
      @order.valid?.must_equal false
    end

    it "must include a CVV number of 3 digits" do
      [nil,"18294673","fuw"].each do |num|
        @order.cc_cvv = num
        @order.valid?.must_equal false
      end

      ["345","182","666"].each do |num|
        @order.cc_cvv = num
        @order.valid?.must_equal true
      end
    end


  end
  describe "custom methods" do
    describe "total_sum" do
      before do
        @order = Order.new
        @order.order_items << OrderItem.first
        @order.valid?.must_equal true
        @order.save
      end
      it "returns the total of an order of only one order item " do
        order.save

        OrderItem.create(quantity: 1, product_id: products(:product1).id, order_id: order.id)

        order.total_sum.must_be_kind_of Integer
        order.total_sum.must_equal (products(:product1).price)
        order.total_sum.must_equal 2100

      end

      it "returns the total of an order of multiple order items " do
        order.save

        OrderItem.create(quantity: 1, product_id: products(:product1).id, order_id: order.id)
        OrderItem.create(quantity: 1, product_id: products(:product2).id, order_id: order.id)
        OrderItem.create(quantity: 1, product_id: products(:product3).id, order_id: order.id)

        order.total_sum.must_be_kind_of Integer
        order.total_sum.must_equal (products(:product1).price + products(:product2).price + products(:product3).price)
        order.total_sum.must_equal 4100
      end

      it "returns the total of an order of multiple order items " do
        order.save

        OrderItem.create(quantity: 0, product_id: products(:product1).id, order_id: order.id)

        order.total_sum.must_be_kind_of Integer
        order.total_sum.must_equal 0

      end

    end

    describe "reduce_inventory" do
      it "reduces the inventory of the items purchased" do
        order = Order.new
        order.save
        order_item = order_items(:orderitem1)
        order_item.quantity.must_equal 10
        order_item.save
        order.order_items << order_item


        product = order_item.product
        product.stock = products(:product2).stock
        product.stock.must_equal 25
        order.reduce_inventory

        order.reload
        product.reload
        
        product.stock.must_equal 15
      end
    end
  end
end
