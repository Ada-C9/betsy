class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order


  def get_subtotal
    product = Product.find(self.product_id)
    sub_total = product.price * self.quantity
    return sub_total
  end

  def already_exists?
    this_id = self.product_id
    order = Order.find(self.order_id)

    order.order_items.each do |item|
      if item.product_id = this_id
        return true
      end
    end

    return false
  end
end
