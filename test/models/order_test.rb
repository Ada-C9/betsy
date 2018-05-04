require "test_helper"

describe Order do

  describe "get total" do
    it "returns order total" do
      order = orders(:one)
      existing_item = order.order_items.first
      existing_item.destroy

      product1 = products(:cat)
      product2 = products(:dog)
      item1 = OrderItem.create(product_id: product1.id, order_id: order.id, quantity: 1)
      item2 = OrderItem.create(product_id: product2.id, order_id: order.id, quantity: 1)

      sum = product1.price + product2.price

      order.get_total.must_equal sum
    end
  end

  describe "merchant products" do
    it "returns a list of the merchant's products" do
      merchant = users(:ada)
      product1 = products(:cat)
      product1.update(user_id: merchant.id)
      product2 = products(:dog)
      product2.update(user_id: merchant.id)

      merchant_product = merchant.products.length
      merchant_product.must_equal 2
    end

    it "doesn't return any product if merchant has zero" do
      merchant = users(:ada)

      Order.merchant_products(merchant.id).must_be_empty
    end
  end

end
